class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :rating
      t.text :review
      t.integer :like_count,default:0

      t.timestamps
    end
  end
end
