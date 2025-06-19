class AddLocationAndGoodreadsUrlToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :location, :string
    add_column :profiles, :goodreads_url, :string
  end
end
