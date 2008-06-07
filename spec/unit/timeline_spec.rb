require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "DataMapper::Timeline" do

  it "is included when DataMapper:Timeline is loaded" do
    Cow.new.should be_kind_of(DataMapper::Timeline)
  end

  it "adds three properties for a DataMapper::Timeline object" do
    c = Cow.new

    c.class.properties.map(&:name).should include(:revision)
    c.class.properties.map(&:name).should include(:valid_from)
    c.class.properties.map(&:name).should include(:valid_to)

    c.revision.should be(1)
    c.valid_from.class.should be(DateTime)
    c.valid_to.should be_nil
  end

  it "is able to save the object with a different time period" do
    c = Cow.new
    c.save(:at => [nil, nil])
    c.valid_from.should be_nil
    c.valid_to.should be_nil
  end

end
