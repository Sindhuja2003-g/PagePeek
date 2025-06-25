ActiveAdmin.register User do
  permit_params :email, :password, :username, :role
  actions :index, :show, :destroy
  index do
    selectable_column
    id_column
    column :username
    column :email
    column :role
    column :created_at
    actions
  end

  filter :username
  filter :email
  filter :role
  filter :created_at

  show do
    attributes_table do
      row :username
      row :email
      row :role
      row :profile
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :email
      f.input :password
      f.input :role, as: :select, collection: User.roles.keys
    end
    f.actions
  end
end
