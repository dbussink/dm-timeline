module DataMapper
  module Associations
    class Relationship
      
      def get_children_with_timeline(parent, options = {}, finder = :all, *args)
        if parent.collection.at
          options.merge!(DataMapper::Timeline::Util.generation_timeline_conditions(parent.collection.at))
        end
        get_children_without_timeline(parent, options, finder, *args)
      end

      alias_method :get_children_without_timeline, :get_children
      alias_method :get_children, :get_children_with_timeline
    end

    class RelationshipChain
      
      def get_children_with_timeline(parent, options = {}, finder = :all, *args)
        if parent.collection.at
          options.merge!(DataMapper::Timeline::Util.generation_timeline_conditions(parent.collection.at))
        end
        get_children_without_timeline(parent, options, finder, *args)
      end
      
      alias_method :get_children_without_timeline, :get_children
      alias_method :get_children, :get_children_with_timeline
    end
  end
end