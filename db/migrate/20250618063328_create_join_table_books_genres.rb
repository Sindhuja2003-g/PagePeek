class CreateJoinTableBooksGenres < ActiveRecord::Migration[7.1]
   t.index :book_id
  t.index :genre_id
  def change
    create_join_table :books, :genres do |t|
      
 
    end
  end
end
