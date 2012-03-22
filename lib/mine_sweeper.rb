class MineSweeper <PageObject
  def initialize driver
    super driver
    @rows =driver.find_elements(:css => "tr").length
    @cells= driver.find_elements(:css => "td").length
    @columns=cells/rows
    @mines ={}
  end

  attr_reader :columns, :mines

  element :center, {:id => "g1r8c15"}

  def rows
    @rows =driver.find_elements(:css => "tr").length
  end

  def cells
    @cells= driver.find_elements(:css => "td").length
  end

  def click_block id
    check_alive
    block = driver.find_element(:id => id)
    block.click
    number_of_mines = block.attribute("class").gsub!("mines", "").to_i
    puts "number of mines"+number_of_mines.to_s
    mines.store(id, number_of_mines)
  end

  def mark_block id
    block = driver.find_element(:id => id)
    driver.action.context_click(block).perform
  end
  def clicked_blocks
    driver.find_elements :css => "td unclicked"
  end
  def status
    driver.find_element(:id => "g1indicator").attribute("class").gsub("status","").strip
  end
  def check_alive
    raise "not alive" unless status == "alive"
  end
  def ones
    driver.find_elements(:class=>"mines1")
  end
end