require 'grid_validator'
require 'fixtures/invalid_board'
require 'fixtures/valid_board'
require 'pry'

module BattleshipFieldValidator
  RSpec.describe GridValidator do

    context 'field validation' do
      let(:valid_grid) { Fixtures::ValidBoard.battlefield }
      let(:invalid_grid) { Fixtures::InvalidBoard.battlefield }

      it 'validates field as valid' do
        validator = GridValidator.new(valid_grid)
        expect(validator.valid?).to eq(true)
      end

      it 'validates field but field is not valid' do
        validator = GridValidator.new(invalid_grid)
        expect(validator.valid?).to eq(false)
      end
    end
  end
end