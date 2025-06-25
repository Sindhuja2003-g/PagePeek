ActiveAdmin.register Review do
 
    actions :index, :show, :destroy
  index do
    selectable_column
    id_column
    column :user
    column :book
    column :rating
    column :created_at
    actions
  end

  filter :user
  filter :book
  filter :rating
 


end
