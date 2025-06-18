# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Genre.create!([
  { name: "Fiction" },
  { name: "Non-fiction" },
  { name: "Science Fiction" },
  { name: "Fantasy" },
  { name: "Mystery" },
  { name: "Thriller" },
  { name: "Horror" },
  { name: "Romance" },
  { name: "Historical Fiction" },
  { name: "Young Adult" },
  { name: "Children's" },
  { name: "Adventure" },
  { name: "Biography" },
  { name: "Memoir" },
  { name: "Self-help" },
  { name: "Health & Wellness" },
  { name: "Science" },
  { name: "Technology" },
  { name: "Philosophy" },
  { name: "Psychology" },
  { name: "Religion & Spirituality" },
  { name: "Poetry" },
  { name: "Drama" },
  { name: "Comics & Graphic Novels" },
  { name: "Cookbooks" },
  { name: "Travel" },
  { name: "Art & Photography" },
  { name: "Music" },
  { name: "True Crime" },
  { name: "LGBTQ+" },
  { name: "Dystopian" },
  { name: "Coming-of-Age" },
  { name: "Political" },
  { name: "Humor" },
  { name: "Education" },
  { name: "Anthology" },
  { name: "Western" },
  { name: "Classics" },
  { name: "Short Stories" },
  { name: "Business & Economics" },
  { name: "Sports" },
  { name: "War & Military" },
  { name: "Parenting" },
  { name: "Animals & Nature" }
])
