require 'spec_helper'

describe TrelloFs::BoardBuilder do
  let(:list) do
    list = OpenStruct.new
    list.name = 'List Name'
    card1 = OpenStruct.new
    card1.name = 'Card 1'
    list.cards = [card1]
    list
  end

  let(:board) do
    board = OpenStruct.new
    board.name = 'Board'
    board.lists = [list]
    board
  end

  let(:board_builder) { TrelloFs::BoardBuilder.new(TestRepository.new, board) }

  context '#readme_content' do
    subject { board_builder.readme_content }

    it { should include '(List_Name/README.md' }
    it { should include '(List_Name/Card_1.md' }
  end
end
