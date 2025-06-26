class Profile < ApplicationRecord
  belongs_to :user

  include Ransackable
  
end
