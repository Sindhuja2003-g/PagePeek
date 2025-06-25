class CreateJoinTableWishlists < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :books do |t|
      t.index [:user_id, :book_id]
      t.index [:book_id, :user_id]
    end

    add_index :wishlists, [:user_id, :book_id], unique: true
    add_index :wishlists, [:book_id, :user_id]
  end
end
