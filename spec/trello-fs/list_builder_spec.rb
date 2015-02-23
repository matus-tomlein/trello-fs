require 'spec_helper'

describe TrelloFs::ListBuilder do

  let(:list) do
    list = OpenStruct.new
    list.name = 'List Name'
    card1 = OpenStruct.new name: 'Card 1', labels: []
    card2 = OpenStruct.new name: 'Card 2', labels: []
    list.cards = [card1, card2]
    list
  end

  let(:board) do
    board = OpenStruct.new
    board.name = 'Board'
    board
  end

  let(:board_builder) { TrelloFs::BoardBuilder.new(TestRepository.new, board) }
  let(:list_builder) { TrelloFs::ListBuilder.new(board_builder, list) }

  subject { list_builder }

  describe '#readme_content' do
    subject { list_builder.readme_content }

    it { should include 'List Name' }
    it { should include '(Card_1.md' }
    it { should include '(Card_2.md' }
  end
end
