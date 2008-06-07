class Cow
  include DataMapper::Resource
  include DataMapper::Timeline

  property :id,        Integer, :serial => true
  property :name,      String
  property :breed,     String

  is_on_timeline

  auto_migrate!(:default)
end
