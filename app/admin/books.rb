ActiveAdmin.register Book do
  permit_params :title, :author, :published, genre_ids: []
  
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
