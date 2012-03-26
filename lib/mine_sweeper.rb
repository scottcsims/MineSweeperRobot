class MineSweeper <PageObject
  def initialize driver
    super driver
    @rows =driver.find_elements(:css => "tr").length
    @cells= driver.find_elements(:css => "td").length
    @columns=cells/rows
    @mines ={}
    @marked_inspections = 0
    @all_clicked_around =[]
    @source = driver.page_source
  end

  attr_reader :columns, :mines, :marked_inspections, :all_clicked_around
  attr_accessor :source
  element :center, {:id => "g1r8c15"}

  def rows
    @rows =driver.find_elements(:css => "tr").length
  end

  def cells
    @cells= driver.find_elements(:css => "td").length
  end

  def nokogiri_elements selector
    nokogiri_elements=[]
    doc = Nokogiri::HTML(source)
    doc.css(selector).each do |nokogiri_element|
      nokogiri_elements.push(nokogiri_element)
    end
    return nokogiri_elements
  end

  def click_top_left_cell
    click_block("g1r0c0")
  end

  def click_top_right_cell
    click_block("g1r0c#{columns-1}")
  end

  def click_bottom_right_cell
    click_block("g1r#{rows-1}c#{columns-1}")
  end

  def click_bottom_left_cell
    click_block("g1r#{rows-1}c0")
  end

  def click_block id
    check_alive
    block = driver.find_element(:id => id)
    block.click
    number_of_mines = block.attribute("class").gsub!("mines", "").to_i
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
    driver.find_element(:id => "g1indicator").attribute("class").gsub("status", "").strip
  end

  def check_alive
    #raise "not alive" unless status == "alive"
    #raise "not alive" unless status == "alive"
  end

  def unclicked_blocks
    driver.find_elements(:class => "unclicked")
  end

  def random_click
    Log.info "Clicking Random"
    unclicked_blocks[rand(unclicked_blocks.length)].click
  end

  def ones
    nokogiri_elements(".mines1")
  end

  def twos
    nokogiri_elements(".mines2")
  end

  def threes
    nokogiri_elements(".mines3")
  end

  def fours
    nokogiri_elements(".mines4")
  end

  def fives
    nokogiri_elements(".mines5")
  end


  def marked
    nokogiri_elements(".marked")
  end

  def out_of_bounds coord
    coord.include?("-") || coord.include?("c#{columns}") || coord.include?("r#{rows}")
  end

  def mark_ones
    found=0
    Log.info "Marking ones"

    ones.each do |one|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(one.get_attribute("id"))
      coordinates.surrounding.each_value do |value|
        #Check Surrounding blocks and if one is unclicked mark it
        next if out_of_bounds value

        block=driver.find_element(:id => value)

        if block.attribute("class")=="unclicked"
          unclicked_blocks.push(value)
        end
        if block.attribute("class")=="marked"
          marked_blocks.push(value)
        end
      end
      if (unclicked_blocks.length == 1 && marked_blocks.length == 0)
        mark_block unclicked_blocks[0]
        found=found+1
      end

    end
    Log.info "Marked #{found}"
    found
  end

  def mark_twos
    found=0
    Log.info "Marking twos"
    twos.each do |two|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(two.get_attribute("id"))
      coordinates.surrounding.each_value do |value|
        #Check Surrounding blocks and if one is unclicked mark it
        next if out_of_bounds value

        block=driver.find_element(:id => value)

        if block.attribute("class")=="unclicked"
          unclicked_blocks.push(value)
        end
        if block.attribute("class")=="marked"
          marked_blocks.push(value)
        end
      end
      if (unclicked_blocks.length == 1 && marked_blocks.length == 1)
        mark_block unclicked_blocks[0]
        found=found + 1
      end
    end
    Log.info "Marked #{found}"
    found
  end

  def mark_threes
    found=0
    Log.info "Marking threes"
    threes.each do |three|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(three.get_attribute("id"))
      coordinates.surrounding.each_value do |value|
        #Check Surrounding blocks and if one is unclicked mark it
        next if out_of_bounds value

        block=driver.find_element(:id => value)

        if block.attribute("class")=="unclicked"
          unclicked_blocks.push(value)
        end
        if block.attribute("class")=="marked"
          marked_blocks.push(value)
        end
      end
      if (unclicked_blocks.length == 1 && marked_blocks.length == 2)
        mark_block unclicked_blocks[0]
        unclicked_blocks.pop
        found=found + 1
      end
      if ((unclicked_blocks.length + marked_blocks.length) == 3)
        found=found+unclicked_blocks.length
        unclicked_blocks.each do |block_id|
          mark_block(block_id)
        end
      end
    end
    Log.info "Marked #{found}"
    found
  end

  def mark_fours
    found=0
    Log.info "Marking fours"
    fours.each do |four|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(four.get_attribute("id"))
      coordinates.surrounding.each_value do |value|
        #Check Surrounding blocks and if one is unclicked mark it
        next if out_of_bounds value

        block=driver.find_element(:id => value)

        if block.attribute("class")=="unclicked"
          unclicked_blocks.push(value)
        end
        if block.attribute("class")=="marked"
          marked_blocks.push(value)
        end
      end
      if (unclicked_blocks.length == 1 && marked_blocks.length == 3)
        mark_block unclicked_blocks[0]
        unclicked_blocks.pop
        found=found + 1
      end
      if ((unclicked_blocks.length + marked_blocks.length) == 4)
        found=found+unclicked_blocks.length
        unclicked_blocks.each do |block_id|
          mark_block(block_id)
        end
      end
    end
    Log.info "Marked #{found}"
    found
  end


  def click_around_one one
    Log.debug "Clicking around ones"
    unclicked_blocks=[]
    marked_blocks=[]
    surrounding_blocks=Coordinates.new(one).surrounding
    surrounding_blocks.each_value do |value|
      next if out_of_bounds value

      block=driver.find_element(:id => value)
      if block.attribute("class")=="unclicked"
        unclicked_blocks.push(value)
      end
      if block.attribute("class")=="marked"
        marked_blocks.push(value)
      end
    end
    if (unclicked_blocks.length && marked_blocks.length == 1)
      unclicked_blocks.each do |block_id|
        click_block(block_id)
      end
    end
  end

  def click_around_two two
    Log.debug "Clicking around twos"
    unclicked_blocks=[]
    marked_blocks=[]
    surrounding_blocks=Coordinates.new(two).surrounding
    surrounding_blocks.each_value do |value|
      next if out_of_bounds value

      block=driver.find_element(:id => value)
      if block.attribute("class")=="unclicked"
        unclicked_blocks.push(value)
      end
      if block.attribute("class")=="marked"
        marked_blocks.push(value)
      end
    end
    if (unclicked_blocks.length > 0 && marked_blocks.length == 2)
      unclicked_blocks.each do |block_id|
        click_block(block_id)
      end
    end
  end

  def click_around_three three
    Log.debug "Clicking around threes"
    unclicked_blocks=[]
    marked_blocks=[]
    surrounding_blocks=Coordinates.new(three).surrounding
    surrounding_blocks.each_value do |value|
      next if out_of_bounds value

      block=driver.find_element(:id => value)
      if block.attribute("class")=="unclicked"
        unclicked_blocks.push(value)
      end
      if block.attribute("class")=="marked"
        marked_blocks.push(value)
      end
    end
    if (unclicked_blocks.length > 0 && marked_blocks.length == 3)
      unclicked_blocks.each do |block_id|
        click_block(block_id)
      end
    end
  end

  def click_around_four four
    Log.debug "Clicking around fours"
    unclicked_blocks=[]
    marked_blocks=[]
    surrounding_blocks=Coordinates.new(four).surrounding
    surrounding_blocks.each_value do |value|
      next if out_of_bounds value

      block=driver.find_element(:id => value)
      if block.attribute("class")=="unclicked"
        unclicked_blocks.push(value)
      end
      if block.attribute("class")=="marked"
        marked_blocks.push(value)
      end
    end
    if (unclicked_blocks.length > 0 && marked_blocks.length == 4)
      unclicked_blocks.each do |block_id|
        click_block(block_id)
      end
    end
  end


  def expand_around_marked
    Log.info "Total Marked: #{marked.length}"
    marked.each do |mark|
      #Log.info "Inspecting Marked '#{mark.attribute("id")}'"
      found_ones=[]
      found_twos=[]
      found_threes=[]
      found_fours=[]
      found_unclicked=[]
      surrounding_blocks=Coordinates.new(mark.get_attribute("id")).surrounding
      surrounding_blocks.each_value do |value|
        next if all_clicked_around.include?(value)
        next if out_of_bounds value
        block=driver.find_element(:id => value)
        if block.attribute("class")=="unclicked"
          found_unclicked.push(value)
        end
        if block.attribute("class")=="mines1"
          found_ones.push(value)
        end
        if block.attribute("class")=="mines2"
          found_twos.push(value)
        end
        if block.attribute("class")=="mines3"
          found_threes.push(value)
        end
        if block.attribute("class")=="mines4"
          found_fours.push(value)
        end
      end
      #don't check again if no sourrounding unclicked
      if found_unclicked.length == 0
        all_clicked_around.push("value")
      end
      #If found unclicked
      if found_unclicked.length > 0
        found_ones.each do |one|
          click_around_one one
        end
        found_twos.each do |two|
          click_around_two two
        end
        found_threes.each do |three|
          click_around_three three
        end
        found_fours.each do |four|
          click_around_four four
        end
      end
    end
    if (unclicked_blocks.length > 0 && status !="won" && status != "dead")
      @marked_inspections= marked.length
      mark_ones
      mark_twos
      mark_threes
      mark_fours
      Log.info "Marked #{marked.length - marked_inspections} this round"
      #should random click by a one
      random_click if marked.length == marked_inspections
      @source=driver.page_source
      expand_around_marked
    end
    return status
  end

end