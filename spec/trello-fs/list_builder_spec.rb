require 'spec_helper'

describe TrelloFs::ListBuilder do

  let(:list) do
    list = OpenStruct.new
    list.name = 'List Name'
    card1, card2 = OpenStruct.new, OpenStruct.new
    card1.name, card2.name = 'Card 1', 'Card 2'
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
    it { should include '(Card 1.md' }
    it { should include '(Card 2.md' }
  end
end
