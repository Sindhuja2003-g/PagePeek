
ActiveAdmin.register_page "OAuth Applications" do
  menu label: "OAuth Apps", url: "/oauth/applications", priority: 100,if: proc { current_admin_user.present? }
end
