require 'spec_helper'
describe MineSweeper do
  #Classes
  #unclicked
  #mines #
  #marked
  #id is location and class attribute is state
  #columns and rows start at 0
  it "should find the rows and columns" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.rows.should == 16
    mine_sweeper.columns.should == 30
    mine_sweeper.cells.should == 480
  end
  it "should click a block" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    cell=driver.find_element(:id => "g1r8c15")
    cell.click
    puts cell.attribute("class")
    cell.attribute("class").should(include 'mines')
  end
  it "should store the coords and the mines" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    center_coords = "g1r8c15"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.click_block center_coords
    mine_sweeper.mines[center_coords].should_not be_nil
    center_mine_count =driver.find_element(:id => center_coords).attribute("class").gsub!("mines", "").to_i
    mine_sweeper.mines[center_coords].should == center_mine_count
  end
  it "should flag a block" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    center_coords = "g1r8c15"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.mark_block "g1r8c15"
    driver.find_element(:id => center_coords).attribute("class").should == "marked"
  end
  it "should find clicked blocks" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    mine_sweeper =MineSweeper.new(driver)
    3.times do
      mine_sweeper.click_block "g1r#{rand(16)}c#{rand(30)}"
    end
    mine_sweeper.clicked_blocks.should_not be_nil
  end
  it "should get status" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.status.should == "alive"
  end
  it "should check alive" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.check_alive
  end
  it "should fail if not alive" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.should_receive(:status).and_return(nil)
    lambda { mine_sweeper.check_alive }.should(raise_exception("not alive"))
  end
  it "should have 1s" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html?preset=beginner"
    mine_sweeper =MineSweeper.new(driver)
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
  it "should find a clicked block with 1 mine and one unclicked block" do
    #ahead and behind
    #above below
    #forward diagonal
    #backward diagonal
  end
end