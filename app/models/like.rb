class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

def self.ransackable_attributes(auth_object = nil)
  %w[user_id likeable_type likeable_id created_at]
end

def self.ransackable_associations(auth_object = nil)
  %w[user likeable]
end



end
