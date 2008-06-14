require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "DataMapper::Timeline" do

  it "is included when DataMapper:Timeline is loaded" do
    Cow.new.should be_kind_of(DataMapper::Timeline)
  end

  it "adds three properties for a DataMapper::Timeline object" do
    c = Cow.new

    c.class.properties.map {|p| p.name }.should include(:valid_from)
    c.class.properties.map {|p| p.name }.should include(:valid_to)

    c.valid_from.class.should be(DateTime)
    c.valid_to.should be_nil
  end

  it "is able to save the object with a different time period" do
    c = Cow.new
    c.save(:at => [nil, nil])
    c.valid_from.should be_nil
    c.valid_to.should be_nil
  end

  it "should be able to find objects on timeline for this instant in time" do
    c1 = Cow.create(:valid_from => DateTime.new(Date.today.year - 2), :valid_to => DateTime.new(Date.today.year))
    c2 = Cow.create(:valid_from => DateTime.new(Date.today.year), :valid_to => DateTime.new(Date.today.year + 1))

    cows = Cow.all
    cows.length.should == 1
    cows.first.should eql(c2)
    
  end

end
