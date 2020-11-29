require_relative '../config/constants'

module BattleshipFieldValidator

  class GridValidator
    attr :board
    attr :points

    def initialize(board)
      @board = board
      @points = board_points_total
    end

    def valid?
      points_match? && ships_keep_distance? && ship_fleet_match?
    end

    private

    #todo move points to board class that wraps the two dimensional cells array
    def board_points_total
      points = 0
      @board.each do |x|
        x.each do |y|
          points += y if y == 1
        end
      end
      points
    end

    def points_match?
      @points == Constants::TWENTY
    end

    # verify that not a single pair of ships occupy adjacent coordinates
    def ships_keep_distance?
      true
    end

    # verify that ship type and number matches with initial requirements
    def ship_fleet_match?
      true
    end

  end
end
