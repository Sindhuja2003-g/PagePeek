ActiveAdmin.register Review do
  actions :index, :show, :destroy

 
  scope("Top Rated (5 Stars)") { |reviews| reviews.where(rating: 5) }
 
  scope("Low Rated") { |reviews| reviews.where('rating <= ?', 2) }

  index do
    selectable_column
    id_column
    column :user
    column :book
    column :rating
    column :created_at
    actions
  end


 
  filter :rating, as: :select, collection: 1..5
  filter :created_at
  filter :book

end
