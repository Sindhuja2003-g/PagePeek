class CreateJoinTableBooksGenres < ActiveRecord::Migration[7.2]
   t.index :book_id
  t.index :genre_id
  def change
    create_join_table :books, :genres do |t|
        # No need for t.timestamps or primary key
 
    end
  end
end
