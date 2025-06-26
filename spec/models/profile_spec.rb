# spec/models/profile_spec.rb
require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { create(:user) }
  let(:profile) { build(:profile, user: user) }

  describe 'associations' do
    it 'belongs to a user' do
      expect(profile.user).to eq(user)
    end
  end


end
