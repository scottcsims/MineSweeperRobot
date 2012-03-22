class Coordinates
  def initialize coordinates
    parse(coordinates)
  end

  attr_accessor :row, :column

  def parse coordinates
    coordinates.scan(/g.*r(.*)c(.*)/) { |r, c|
      @row=r.to_i
      @column=c.to_i
    }
  end

  def surrounding
    {:above => above,
     :below => below,
     :left => left,
     :right => right,
     :above_right => above_right,
     :above_left => above_left,
     :below_left => below_left,
     :below_right => below_right,
    }
  end

  def above
    "g1r#{row-1}c#{column}"
  end

  def below
    "g1r#{(row+1)}c#{column}"
  end

  def right
    "g1r#{(row)}c#{column+1}"
  end

  def left
    "g1r#{(row)}c#{column-1}"
  end

  def above_left
    "g1r#{(row-1)}c#{column-1}"
  end

  def above_right
    "g1r#{(row-1)}c#{column+1}"
  end

  def below_left
    "g1r#{(row+1)}c#{column-1}"
  end

  def below_right
    "g1r#{(row+1)}c#{column+1}"
  end


end