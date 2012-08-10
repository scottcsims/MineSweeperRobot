require 'spec_helper'
describe MineSweeper do
  before(:each) do
    launch_web_driver "http://minesweeper.github.com/index.html?preset=beginner"
    @local_base="http://minesweeper.github.com/"
    @test_url =@local_base+"?rows=3&cols=4&mines=[[0,0],[0,1],[0,2]]"

    #http://minesweeper.github.com/?rows=3&cols=4&mines=[[0,0],[0,1],[0,2]] intermediate
    #launch_web_driver "http://minesweeper.github.com/?preset=expert"
  end
  let(:mine_sweeper) { MineSweeper.new(driver) }
  let(:center_coords) { "g1r5c5" }
  #Classes
  #unclicked
  #mines #
  #marked
  #id is location and class attribute is state
  #columns and rows start at 0
  it "should get the table source" do
    mine_sweeper.source.should_not be_nil
  end

  it "should get ones" do
    driver.navigate.to @test_url
    mine_sweeper=MineSweeper.new(driver)
    mine_sweeper.click_block("g1r2c0")
    mine_sweeper.source=driver.page_source
    ones=mine_sweeper.nokogiri_elements(".mines1")
    ones.should have(1).element
    ones[0].get_attribute("id").should == "g1r1c3"
  end
  it "should get unclicked surrounding a cell" do
    driver.navigate.to @test_url
    mine_sweeper=MineSweeper.new(driver)
    mine_sweeper.click_block("g1r2c0")
    mine_sweeper.source=driver.page_source
    mine_sweeper_surrounding_unclicked = mine_sweeper.surrounding_type("unclicked", "g1r1c3")
    mine_sweeper_surrounding_unclicked.should(have(2).blocks)
    mine_sweeper_surrounding_unclicked.should include("g1r0c3")
    mine_sweeper_surrounding_unclicked.should include("g1r0c2")
  end
  it "should get marked surrounding a cell" do
    driver.navigate.to @test_url
    mine_sweeper=MineSweeper.new(driver)
    mine_sweeper.click_block("g1r2c0")
    mine_sweeper.mark_block("g1r0c2")
    mine_sweeper.source=driver.page_source
    mine_sweeper_surrounding_marked = mine_sweeper.surrounding_type("marked", "g1r1c3")
    mine_sweeper_surrounding_marked.should(have(1).blocks)
    mine_sweeper_surrounding_marked.should include("g1r0c2")
  end
  it "should mark" do
    driver.navigate.to @local_base+"?rows=4&cols=4&mines=[[0,0],[3,2]]"
    mine_sweeper=MineSweeper.new(driver)
    mine_sweeper.click_block("g1r3c0")
    mine_sweeper.click_block("g1r0c1")
    mine_sweeper.click_block("g1r0c2")
    mine_sweeper.source=driver.page_source
    mine_sweeper.mark("ones")
    mine_sweeper.source=driver.page_source
    mine_sweeper_surrounding_marked = mine_sweeper.surrounding_type("marked", "g1r1c1")
    mine_sweeper_surrounding_marked.should(have(1).blocks)
    mine_sweeper_surrounding_marked.should include("g1r0c0")
  end
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
  xit "should fail if not alive" do
    mine_sweeper.should_receive(:status).and_return(nil)
    lambda { mine_sweeper.check_alive }.should(raise_exception("not alive"))
  end
  it "should win" do
    wins=0
    tries=0
    while wins < 1
      puts "Wins:#{wins} out of #{tries} tries"
      mine_sweeper.click_top_left_cell
      mine_sweeper.click_top_right_cell
      mine_sweeper.click_bottom_left_cell
      mine_sweeper.click_bottom_right_cell
      result = mine_sweeper.expand_around_marked
      if result == "won"
        wins =wins+1
        time_to_win=driver.find_element(:css => "div.timer").attribute("title")
        Log.info "Won in #{time_to_win} seconds"
      end
      tries=tries+1 #unless mine_sweeper.status == "dead"
      driver.find_element(:class => "status").click
      mine_sweeper=MineSweeper.new(driver)

    end
  end
end