require 'lib/play_mine_sweeper'


module PlayMineSweeper
  driver = Selenium::WebDriver.for :firefox
  driver.navigate.to "http://minesweeper.github.com/index.html?preset=beginner"
  @local_base="http://minesweeper.github.com/"
  @test_url =@local_base+"?rows=3&cols=4&mines=[[0,0],[0,1],[0,2]]"
  mine_sweeper=MineSweeper.new(driver)
#center_coords="g1r5c5"
  wins=0
  tries=0
  while wins < 100
    puts "Wins:#{wins} out of #{tries} tries"
    mine_sweeper.click_top_left_cell
    mine_sweeper.click_top_right_cell
    mine_sweeper.click_bottom_left_cell
    mine_sweeper.click_bottom_right_cell
    #mine_sweeper.click_block "g1r8c14"
    #if mine_sweeper.status == "alive"
    #  4.times do
    #    mine_sweeper.random_click
    #  end
    #end
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
include PlayMinesweeper
play