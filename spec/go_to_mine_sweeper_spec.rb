require 'spec_helper'
describe MineSweeper do
  before(:each) do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html?preset=beginner"
  end
  let(:mine_sweeper) { MineSweeper.new(driver) }
  let(:center_coords) { "g1r5c5" }
  #Classes
  #unclicked
  #mines #
  #marked
  #id is location and class attribute is state
  #columns and rows start at 0
  it "should find the rows and columns" do
    mine_sweeper.rows.should == 9
    mine_sweeper.columns.should == 9
    mine_sweeper.cells.should == 81
  end
  it "should click a block" do
    cell=driver.find_element(:id => "g1r1c8")
    cell.click
    puts cell.attribute("class")
    cell.attribute("class").should(include 'mines')
  end
  it "should store the coords and the mines" do
    mine_sweeper.click_block center_coords
    mine_sweeper.mines[center_coords].should_not be_nil
    center_mine_count =driver.find_element(:id => center_coords).attribute("class").gsub!("mines", "").to_i
    mine_sweeper.mines[center_coords].should == center_mine_count
  end
  it "should flag a block" do
    mine_sweeper.mark_block center_coords
    driver.find_element(:id => center_coords).attribute("class").should == "marked"
  end
  it "should find clicked blocks" do
    3.times do
      mine_sweeper.click_block "g1r#{rand(9)}c#{rand(9)}"
    end
    mine_sweeper.clicked_blocks.should_not be_nil
  end
  it "should get status" do
    mine_sweeper.status.should == "alive"
  end
  it "should check alive" do
    mine_sweeper.check_alive
  end
  it "should fail if not alive" do
    mine_sweeper.should_receive(:status).and_return(nil)
    lambda { mine_sweeper.check_alive }.should(raise_exception("not alive"))
  end
  it "should have 1s" do
    mine_sweeper.click_block("g1r0c0")
    mine_sweeper.click_block("g1r8c0")
    mine_sweeper.click_block("g1r0c8")
    mine_sweeper.click_block("g1r8c8")
    ones=mine_sweeper.ones
    ones.should_not be_nil
    ones[0].attribute("class").should == "mines1"
    ones[0].attribute("id").should(include("g"))
    ones[0].attribute("id").should(include("r"))
    ones[0].attribute("id").should(include("c"))
  end
  it "should find a 1 touching one unclicked block" do
    mine_sweeper.click_block("g1r0c0")
    mine_sweeper.click_block("g1r8c0")
    mine_sweeper.click_block("g1r0c8")
    mine_sweeper.click_block("g1r8c8")
    mine_sweeper.mark_ones.should_not be_nil
  end
  it "should find 1 touching marked" do
    mine_sweeper.click_block("g1r0c0")
    mine_sweeper.click_block("g1r8c0")
    mine_sweeper.click_block("g1r0c8")
    mine_sweeper.click_block("g1r8c8")
    mine_sweeper.mark_ones.should_not be_nil
    mine_sweeper.expand_around_marked.should == "won"
  end

end