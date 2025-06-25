class Profile < ApplicationRecord
  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
  %w[bio location created_at]
end

def self.ransackable_associations(auth_object = nil)
  %w[user]
end

  
end
