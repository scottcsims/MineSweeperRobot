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
    driver.find_element(:id => "g1indicator").attribute("class").gsub("status", "").strip
  end

  def check_alive
    raise "not alive" unless status == "alive"
  end

  def ones
    driver.find_elements(:class => "mines1")
  end
  def twos
    driver.find_elements(:class => "mines2")
  end
  def threes
    driver.find_elements(:class => "mines3")
  end


  def marked
    driver.find_elements(:class => "marked")
  end

  def out_of_bounds coord
    coord.include?("-") || coord.include?("c9") || coord.include?("r9")
  end

  def mark_ones
    Log.info "Marking ones"
    ones.each do |one|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(one.attribute("id"))
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
      end
    end
  end

  def mark_twos
    Log.info "Marking twos"
    twos.each do |one|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(one.attribute("id"))
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
      end
    end
  end
  def mark_threes
    Log.info "Marking threes"

    threes.each do |one|
      unclicked_blocks=[]
      marked_blocks=[]
      coordinates=Coordinates.new(one.attribute("id"))
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
      end
    end
  end


  def click_around_one one
    Log.info "Clicking around ones"
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
    Log.info "Clicking around twos"
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
    Log.info "Clicking around threes"
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


  def expand_around_marked
    marked.each do |mark|
      found_ones=[]
      found_twos=[]
      found_threes=[]
      surrounding_blocks=Coordinates.new(mark.attribute("id")).surrounding
      surrounding_blocks.each_value do |value|
        next if out_of_bounds value

        block=driver.find_element(:id => value)
        if block.attribute("class")=="mines1"
          found_ones.push(value)
        end
        if block.attribute("class")=="mines2"
          found_twos.push(value)
        end
        if block.attribute("class")=="mines3"
          found_threes.push(value)
        end

      end
      found_ones.each do |one|
        click_around_one one
      end
      found_twos.each do |two|
        click_around_two two
      end
      found_threes.each do |two|
        click_around_three two
      end

    end
    if (driver.find_elements(:class => "unclicked").length > 0 && status !="won")
      mark_ones
      mark_twos
      mark_threes
      expand_around_marked
    end
    return status
  end

end