module Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      column_names + %w[created_at updated_at]
    end

    def ransackable_associations(_auth_object = nil)
      reflect_on_all_associations.map(&:name).map(&:to_s)
    end
  end
end
