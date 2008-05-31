class Cow
  include DataMapper::Resource
  include DataMapper::Timeline

  property :id,        Integer, :key => true
  property :composite, Integer, :key => true
  property :name,      String
  property :breed,     String
end
