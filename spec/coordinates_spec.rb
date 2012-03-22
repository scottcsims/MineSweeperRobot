require 'spec_helper'
describe Coordinates do
  let(:coordinates) { Coordinates.new("g1r2c3") }
  it "should parse coordinates" do
    coordinates.row.should == 2
    coordinates.column.should == 3
  end
  it "above" do
    coordinates.above.should == "g1r1c3"
  end
  it "below" do
    coordinates.below.should == "g1r3c3"
  end
  it "left" do
    coordinates.left.should =="g1r2c2"
  end
  it "right" do
    coordinates.right.should =="g1r2c4"
  end
  it "above_left" do
    coordinates.above_left.should =="g1r1c2"
  end
  it "above_right" do
    coordinates.above_right.should =="g1r1c4"
  end
  it "below_left" do
    coordinates.below_left.should =="g1r3c2"
  end
  it "below_right" do
    coordinates.below_right.should =="g1r3c4"
  end

  it "should calculate surrounding" do
    expected_surrounding={:above => "g1r1c3",
                          :below => "g1r3c3",
                          :left => "g1r2c2",
                          :right => "g1r2c4",
                          :above_right => "g1r1c4",
                          :above_left => "g1r1c2",
                          :below_left => "g1r3c2",
                          :below_right => "g1r3c4",
    }
    coordinates.surrounding.should == expected_surrounding
  end
end