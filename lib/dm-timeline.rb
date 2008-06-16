require 'rubygems'
gem 'dm-core', '>=0.9.2'
require 'dm-core'
require Pathname(__FILE__).dirname.expand_path / 'dm-timeline' / 'adapter_extensions'
require Pathname(__FILE__).dirname.expand_path / 'dm-timeline' / 'collection_extension'
require Pathname(__FILE__).dirname.expand_path / 'dm-timeline' / 'relationship_extension'

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

        self.valid_from = self.class.repository.adapter.class::START_OF_TIME if self.valid_from.nil?
        self.valid_to   = self.class.repository.adapter.class::END_OF_TIME   if self.valid_to.nil?

        save_without_timeline
      end

    end

    module ClassMethods
      def is_on_timeline

        property :valid_from, DateTime, :default => DateTime.now
        property :valid_to,   DateTime, :default => repository.adapter.class::END_OF_TIME

        include DataMapper::Timeline::InstanceMethods

        alias_method :save_without_timeline, :save
        alias_method :save, :save_with_timeline

        class << self
          def all_with_timeline(query = {})
            conditions      = Timeline::Util.extract_timeline_options(query)
            query_arguments = Timeline::Util.generation_timeline_conditions(conditions)

            collection = all_without_timeline(query.merge(query_arguments))
            collection.at = conditions
            collection
          end

          def first_with_timeline(options = {})
            first_without_timeline(options)
          end

          alias_method :all_without_timeline, :all
          alias_method :all, :all_with_timeline
        end
      end
    end

    module Util
      def self.extract_timeline_options(query)
        if Hash === query && query.has_key?(:at)
          conditions = query.delete(:at)
          if conditions.class == Date
            conditions = [conditions, conditions + 1]
          end
          unless conditions.kind_of? Array
            conditions = [conditions]
          end
          conditions
        else
          [DateTime.now]
        end
      end

      def self.generation_timeline_conditions(conditions)
        if conditions.length < 2 || conditions.first == conditions.last
          {:valid_from.lte => conditions.last, :valid_to.gte => conditions.first}
        else
          {:valid_from.lt => conditions.last, :valid_to.gte => conditions.first}
        end

      end
    end

  end
end
