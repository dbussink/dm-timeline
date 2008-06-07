require 'rubygems'
gem 'dm-core', '>=0.9.1'
require 'data_mapper'

module DataMapper
  module Timeline
    def self.included(base)
      base.extend(ClassMethods)
    end

    module InstanceMethods

      def save_with_timeline(options = {})
        if options[:at]
          self.valid_from = options[:at].first
          self.valid_to   = options[:at].last
        end
        save_without_timeline
      end

    end

    module ClassMethods
      def is_on_timeline

        property :revision,   Integer,  :key => true, :default => 1
        property :valid_from, DateTime, :default => DateTime.now
        property :valid_to,   DateTime

        include DataMapper::Timeline::InstanceMethods

        alias_method :save_without_timeline, :save
        alias_method :save, :save_with_timeline

        DataMapper::Repository.extend(RepositoryMethods)
      end

    end

    module RepositoryMethods

      def all_with_timeline(model, options)
        all_without_timeline(model, options)
      end

      def first_with_timeline(model, options)
        first_without_timeline(model, options)
      end

    end

  end
end
