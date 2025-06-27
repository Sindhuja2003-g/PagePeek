module Ransackable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :_ransack_config
    self._ransack_config = YAML.load_file(Rails.root.join('config/ransack_permissions.yml'))[name] || {}
  end

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      _ransack_config['attributes'] || []
    end

    def ransackable_associations(_auth_object = nil)
      _ransack_config['associations'] || []
    end
  end
end
