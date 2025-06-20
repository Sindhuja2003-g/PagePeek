class MoveUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    # Remove from profiles
    remove_column :profiles, :name, :string

    # Add to users
    add_column :users, :username, :string
    add_index  :users, :username, unique: true
  end
end
