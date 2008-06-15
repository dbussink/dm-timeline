# Add the at accessor to a collection. This makes it possible
# to find all children objects for the same timeframe
module DataMapper
  class Collection
    attr_accessor :at
  end
end