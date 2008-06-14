require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "DataMapper::Timeline" do

  class Stable
    include DataMapper::Resource
    include DataMapper::Timeline
  end

  class Cow
    include DataMapper::Resource
    include DataMapper::Timeline

    property :id,        Integer, :serial => true
    property :name,      String
    property :breed,     String
    property :stable_id, Integer
    belongs_to :stable

    is_on_timeline

    auto_migrate!(:default)
  end

  class Stable
    has n, :cows

    property :id,        Integer, :serial => true
    property :location,  String
    property :size,      Integer

    is_on_timeline

    auto_migrate!(:default)
  end

  it "is included when DataMapper:Timeline is loaded" do
    Cow.new.should be_kind_of(DataMapper::Timeline)
  end

  it "adds three properties for a DataMapper::Timeline object" do
    c = Cow.new

    c.class.properties.map {|p| p.name }.should include(:valid_from)
    c.class.properties.map {|p| p.name }.should include(:valid_to)

    c.valid_from.should be_instance_of(DateTime)
    c.valid_to.should be_instance_of(DateTime)
    c.valid_to.should eql(c.class.repository.adapter.class::END_OF_TIME)
  end

  it "sets the maximum and minimum DateTime for the different drivers" do
    DataMapper::Adapters::AbstractAdapter::START_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::AbstractAdapter::END_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::Sqlite3Adapter::START_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::Sqlite3Adapter::END_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::MysqlAdapter::START_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::MysqlAdapter::END_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::PostgresAdapter::START_OF_TIME.should be_instance_of(DateTime)
    DataMapper::Adapters::PostgresAdapter::END_OF_TIME.should be_instance_of(DateTime)
  end

  it "is able to save the object with a different time period" do
    c = Cow.new
    c.save(:at => [nil, nil])
    c.valid_from.should be_instance_of(DateTime)
    c.valid_from.should eql(c.class.repository.adapter.class::START_OF_TIME)
    c.valid_to.should be_instance_of(DateTime)
    c.valid_to.should eql(c.class.repository.adapter.class::END_OF_TIME)
  end

  it "should be able to find objects on timeline for this instant in time" do
    c1 = Cow.new(:name => "Bertha")
    c1.save(:at => [nil, DateTime.new(Date.today.year - 1)])
    c2 = Cow.new(:name => "Bertha")
    c2.save(:at => [DateTime.new(Date.today.year), nil])

    cows = Cow.all(:name => "Bertha")
    cows.length.should == 1
    cows.first.should eql(c2)
  end

  it "should be able to find related objects that are also on timeline" do
    stable = Stable.create(:location => "MacDonald's Farm")
    stable.cows << Cow.new(:name => "Cindy 1")
    stable.cows << Cow.new(:name => "Cindy 2")
    stable.save
    
    stable.cows.all(:at => [Date.today, Date.today + 100]).length.should == 2
    stable.cows.all(:at => [nil, Date.today]).length.should == 0
  end

end
