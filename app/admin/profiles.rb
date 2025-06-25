ActiveAdmin.register Profile do
  
    actions :index, :show
  index do
    selectable_column
    id_column
    column :user
    column :bio
    column :location
    actions
  end


  filter :location


end
