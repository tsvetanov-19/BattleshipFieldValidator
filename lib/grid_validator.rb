require_relative '../config/constants'

module BattleshipFieldValidator

  class GridValidator
    include Constants
    attr :board
    attr :values
    attr :neighbours

    def initialize(board)
      @board = board
      @values = []
      @neighbours = []
      @occupied_cells = []
      occupied_cells
    end

    def valid?
      binding.pry
      points_match? && ship_shapes_match? && ship_numbers_match?
    end

    private

    def diagonal_neighbour(cell)
      eight_neighbours(cell).any?
    end

    def occupied_cells
      # cells to flat array of 0 .. 99
      i = 0
      @board.each do |row|
        row.each do |cell|
          i += 1
          @occupied_cells.push(i) if cell == 1
        end
      end
    end

    def points_match?
      @occupied_cells.length == SHIP_POINTS_SUM
    end
    
    # verify that not a single pair of ships occupy adjacent coordinates, no ships on two rows/columns etc
    def ship_shapes_match?
      true
    end
    
    def inner(cell)
      false if cell < MAX_X
      false if cell > (MAX_X - 1) * MAX_Y
      false if (cell % MAX_Y).zero
      false if (cell % MAX_X - 1).zero
      true
    end

    def find_neighbours(cell)
      find_inner_neighbours(cell) if inner(cell)
      find_border_neighbours(cell) unless inner(cell)
    end

    def four_neighbours(cell)
      n = []
      n.push(cell - 1) if @occupied_cells.include?(cell - 1)
      n.push(cell + 1) if @occupied_cells.include?(cell + 1)
      n.push(cell - 10) if @occupied_cells.include?(cell - 10)
      n.push(cell + 10) if @occupied_cells.include?(cell + 10)
      n
    end

    def eight_neighbours(cell)
      n = []
      if inner(cell)
        n.push(cell - 11) if @occupied_cells.include?(cell - 11)
        n.push(cell + 9) if @occupied_cells.include?(cell + 9)
        n.push(cell - 9) if @occupied_cells.include?(cell - 9)
        n.push(cell + 11) if @occupied_cells.include?(cell + 11)
      end
      n
    end

    def find_horisontal_neighbours(cell)
      horisontal_neighbours = []
      horisontal_neighbours.push(cell - 1) if @occupied_cells.include?(cell - 1)
      horisontal_neighbours.push(cell + 1) if @occupied_cells.include?(cell + 1)
      horisontal_neighbours
    end

    def find_vertical_neighbours(cell)
      vertical_neighbours = []
      vertical_neighbours.push(cell - 10) if @occupied_cells.include?(cell - 10)
      vertical_neighbours.push(cell + 10) if @occupied_cells.include?(cell + 10)
      vertical_neighbours
    end

    def find_inner_neighbours(cell)
      horisontal_neighbours = []
      horisontal_neighbours.push(cell - 1) if @occupied_cells.include?(cell - 1)
      horisontal_neighbours.push(cell + 1) if @occupied_cells.include?(cell + 1)
      vertical_neighbours = []
      vertical_neighbours.push(cell - 10) if @occupied_cells.include?(cell - 10)
      vertical_neighbours.push(cell + 10) if @occupied_cells.include?(cell + 10)
      if horisontal_neighbours.any? && vertical_neighbours.any?
        ['fail']
      else
        ['h', horisontal_neighbours] if horisontal_neighbours.any?
        ['v', vertical_neighbours] if vertical_neighbours.any?
      end
      ['none']
    end

    def find_in(values, list)
      found = []
      values.each do |value|
        found.push(value) if list.include?(value)
      end
      found
    end

    def find_border_neighbours(cell)
      neighbours = []
      case cell
      # top left corner of battlefield
      when 0
        [1, 10].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # top right corner of battlefield
      when 9
        [8, 19].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # bottom left corner of battlefield
      when 90
        [80, 91].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # bottom right corner of battlefield
      when 99
        [89, 98].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # top border of battlefield
      when 1..8
        [cell - 1, cell + 1, cell + 10].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # bottom border of battlefield
      when 91..98
        [cell - 1, cell + 1, cell - 10].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # right border of battlefield
      when cell > 9 && (cell % 10) == 9
        '19 29 .. 80 '
        [cell - 10, cell + 10, cell - 1].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
        # left border of battlefield
      when cell > 10 && (cell % 10).zero
        '10 20 .. 80 '
        [cell - 10, cell + 10, cell + 1].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      end
      neighbours
    end

    def find_diagonal_border_neighbours(cell)
      neighbours = []
      case cell
      # top left corner of battlefield
      when 0
        neighbours.push(11) if @occupied_cells.include?(11)
      # top right corner of battlefield
      when 9
        neighbours.push(18) if @occupied_cells.include?(18)
      # bottom left corner of battlefield
      when 90
        neighbours.push(81) if @occupied_cells.include?(81)
      # bottom right corner of battlefield
      when 99
        neighbours.push(88) if @occupied_cells.include?(88)
      # top border of battlefield
      when 1..8
        [cell + 9, cell + 11].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # bottom border of battlefield
      when 91..98
        [cell - 9, cell - 11].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      # right border of battlefield
      when cell > 9 && (cell % 10) == 9
        '19 29 .. 80 '
        [cell - 11, cell + 9].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
        # left border of battlefield
      when cell > 10 && (cell % 10).zero
        '10 20 .. 80 '
        [cell - 9, cell + 11].each do |i|
          neighbours.push(i) if @occupied_cells.include?(i)
        end
      end
      neighbours
    end


    # verify that ship type and number matches with initial requirements
    def ship_numbers_match?
      single_ship_count == SINGLE_SHIP[:count] &&
        cruiser_count   == CRUISER[:count]     &&
        destroyer_count == DESTROYER[:count]   &&
        submarine_count == SUBMARINE[:count]
    end

    def single_ship_count
      1
    end

    def cruiser_count
      2
    end

    def destroyer_count
      3
    end

    def submarine_count
      4
    end

  end
end
