class DropJoinTableBooksUsers < ActiveRecord::Migration[7.1]
  def change
    drop_join_table :books, :users
  end
end
