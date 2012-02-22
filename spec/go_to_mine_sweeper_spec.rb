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
    cell=driver.find_element(:id =>"g1r8c15")
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
    center_mine_count =driver.find_element(:id =>center_coords).attribute("class").gsub!("mines","").to_i
    mine_sweeper.mines[center_coords].should == center_mine_count
  end
  it "should flag a block" do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html"
    center_coords = "g1r8c15"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.mark_block "g1r8c15"
    driver.find_element(:id =>center_coords).attribute("class").should == "marked"
  end
end