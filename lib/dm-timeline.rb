require 'rubygems'
gem 'dm-core', '>=0.9.1'
require 'dm-core'

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

        property :valid_from, DateTime, :default => DateTime.now, :nullable => true
        property :valid_to,   DateTime

        include DataMapper::Timeline::InstanceMethods

        alias_method :save_without_timeline, :save
        alias_method :save, :save_with_timeline

        class << self
          def all_with_timeline(query = {})
            if Hash === query && query.has_key?(:at)
              conditions = query.delete(:at)
            end
            
            unless conditions
              conditions = [DateTime.now, DateTime.now + 1]
            end
            
            all_without_timeline(query.merge(:valid_from.lte => conditions.first, :valid_to.gt => conditions.last))
          end

          def first_with_timeline(options = {})
            first_without_timeline(options)
          end

          alias_method :all_without_timeline, :all
          alias_method :all, :all_with_timeline
        end
      end
    end
  end
end
