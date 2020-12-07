# frozen_string_literal: true

module Constants
  MIN_X = 0
  MIN_Y = 0
  MAX_X = 10
  MAX_Y = 10

  SINGLE_SHIP = {
    size: 4,
    count: 1
  }.freeze
  CRUISER = {
    size: 3,
    count: 2
  }.freeze
  DESTROYER = {
    size: 2,
    count: 3
  }.freeze
  SUBMARINE = {
    size: 1,
    count: 4
  }.freeze

  BATTLESHIPS = [SINGLE_SHIP, CRUISER, DESTROYER, SUBMARINE].freeze

  # 20 squares
  SHIP_POINTS_SUM =
    SINGLE_SHIP[:size] * SINGLE_SHIP[:count] +
    CRUISER[:size] * CRUISER[:count] +
    DESTROYER[:size] * DESTROYER[:count] +
    SUBMARINE[:size] * SUBMARINE[:count]

end
