require 'rails/generators'
require 'rails/generators/active_record'

module AvailabilityScheduler
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :force, type: :boolean, default: true, desc: "Overwrite existing migrations"

      argument :name, type: :string, default: 'default_value', optional: true

      def create_migrations
        migration_template 'create_weekly_schedules.rb', 'db/migrate/create_weekly_schedules.rb'
        migration_template 'create_special_schedules.rb', 'db/migrate/create_special_schedules.rb'
        migration_template 'create_appointments.rb', 'db/migrate/create_appointments.rb'
      end
    end
  end
end
