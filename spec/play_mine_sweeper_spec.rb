require 'spec_helper'
describe MineSweeper do
  it "should play a game"do
    launch_web_driver "file://localhost/Users/ssims/RubymineProjects/minesweeper.github.com/index.html?preset=beginner"
    mine_sweeper =MineSweeper.new(driver)
    mine_sweeper.click_block("g1r0c0")
    mine_sweeper.click_block("g1r8c0")
    mine_sweeper.click_block("g1r0c8")
    mine_sweeper.click_block("g1r8c8")


  end
end