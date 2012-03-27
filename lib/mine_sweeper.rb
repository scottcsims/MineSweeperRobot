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
    @types_to_int={"ones" => 1,
                   "twos" => 2,
                   "threes" => 3,
                   "fours" => 4,
                   "fives" => 5,
    }
  end

  attr_reader :columns, :mines, :marked_inspections, :all_clicked_around, :types_to_int
  attr_accessor :source
  element :center, {:id => " g1r8c15 "}

  def rows
    @rows =driver.find_elements(:css => " tr ").length
  end

  def cells
    @cells= driver.find_elements(:css => " td ").length
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

  def surrounding_type(type, coordinates)
    found_blocks=[]
    Coordinates.new(coordinates).surrounding.each_value do |location|
      next if out_of_bounds location
      location_class = nokogiri_elements("td[id='#{location}']")[0].get_attribute("class")
      if location_class == type
        found_blocks.push(location)
      end
    end
    return found_blocks
  end

  def mark(type)
    found=0
    Log.info "Marking #{type}"
    @source=driver.page_source
    blocks_to_mark=[]
    send(type).each do |selection|
      selection_coords=selection.get_attribute("id")
      unclicked_blocks=surrounding_type("unclicked", selection_coords)
      marked_blocks=surrounding_type("marked", selection_coords)
      allowed_marked=types_to_int[type]-1
      if (unclicked_blocks.length == 1 && marked_blocks.length == allowed_marked)
        blocks_to_mark.push(unclicked_blocks[0])
      end
      if ((unclicked_blocks.length + marked_blocks.length) == types_to_int[type])
        blocks_to_mark.push(unclicked_blocks[0])
      end

    end
    unless blocks_to_mark.uniq.empty?
      blocks_to_mark.uniq.each do |block|
        unless block.nil?
          mark_block(block)
          found=found+1

        end
      end
      Log.info "Marked #{found}"
      found
    end
  end

  def click_around selection_coords, type
    found=0
    #Log.info "Clicking Around #{selection_coords}"
    @source=driver.page_source
    blocks_to_click=[]
    unclicked_blocks=surrounding_type("unclicked", selection_coords)
    marked_blocks=surrounding_type("marked", selection_coords)
    if (unclicked_blocks.length > 0 && marked_blocks.length == types_to_int[type])
      blocks_to_click.push(unclicked_blocks[0])
    end
    unless blocks_to_click.uniq.empty?
      blocks_to_click.uniq.each do |block|
        unless block.nil?
          click_block(block)
          found=found+1
        end
      end
    end
    found
  end

  def expand_around_marked
    Log.info "Total Marked: #{marked.length}"
    @source=driver.page_source
    marked.each do |mark|
      value = mark.get_attribute("id")
      found_unclicked=surrounding_type("unclicked", value)
      if found_unclicked.length == 0
        all_clicked_around.push("value")
      end
      #If found unclicked
      if found_unclicked.length > 0
        surrounding_type("mines1", value).each do |one|
          click_around one, "ones"
        end
        surrounding_type("mines2", value).each do |two|
          click_around two, "twos"
        end
        surrounding_type("mines3", value).each do |three|
          click_around three, "threes"
        end
        surrounding_type("mines4", value).each do |four|
          click_around four, "fours"
        end

      end
    end
    if (unclicked_blocks.length > 0 && status !="won" && status != "dead")
      @marked_inspections= marked.length
      ["ones", "twos", "threes", "fours", "fives"].each do |type|
        mark(type)
      end
      Log.info "Marked #{marked.length - marked_inspections} this round"
      #should random click by a one
      random_click if marked.length == marked_inspections
      @source=driver.page_source
      expand_around_marked
    end
    return status
  end

end