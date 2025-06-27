ActiveAdmin.register Genre do
  permit_params :name

  scope :all, default: true
  scope("With Books")     { |genres| genres.joins(:books).distinct }
  scope("Without Books")  { |genres| genres.left_outer_joins(:books).where(books: { id: nil }) }

  index do
    selectable_column
    id_column
    column :name
    column("Books Count") { |genre| genre.books.count }
    actions
  end

  filter :name
  filter :books_title_cont, as: :string, label: 'Book Title'

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
