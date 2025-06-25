ActiveAdmin.register Like do
 
  actions :index, :show
  index do
    selectable_column
    id_column
    column :user
    column :likeable
    column :created_at
    actions
  end

  filter :user
  filter :likeable_type



end
