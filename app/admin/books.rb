ActiveAdmin.register Book do
  permit_params :title, :author, :published, genre_ids: []


   member_action :details, method: :get do
    book = Book.find(params[:id])
    details = <<~TEXT
      Title: #{book.title}
      Author: #{book.author}
      Description: #{book.description}
      Published: #{book.published}
      Likes: #{book.likes.count}
      Genres: #{book.genres.pluck(:name).join(', ')}
      Reviews:
      #{book.reviews.map { |r| "- #{r.user.username}: #{r.review} (Rating: #{r.rating})" }.join("\n")}
    TEXT

    render plain: details
  end

 
  action_item :view_details, only: :show do
    link_to 'View Book Details', details_admin_book_path(resource)
  end

  
  
  index do
    selectable_column
    id_column
    column :title
    column :author
    column :published
    column("Likes") { |book| book.likes.count }
    actions
  end

  filter :title
  filter :author
  filter :published


  show do
    attributes_table do
      row :title
      row :author
      row :published
      row("Likes") { book.likes.count }
    end
    active_admin_comments
  end

  scope :most_liked
  filter :author, as: :select, collection: -> { Book.distinct.pluck(:author) }

  form do |f|
    f.inputs do
      f.input :title
      f.input :author
      f.input :published
      f.input :genres, as: :check_boxes, collection: Genre.all
    end
    f.actions
  end
end
