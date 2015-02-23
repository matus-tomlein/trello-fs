require 'spec_helper'

describe TrelloFs::LabelBuilder do

  let(:board) { OpenStruct.new(name: 'Board Name') }
  let(:label) do
    cards = [
      OpenStruct.new(
        name: 'Card 1',
        list: OpenStruct.new(
          name: 'List Name',
          board: board
        )
      )
    ]
    OpenStruct.new name: 'Label Name', cards: cards
  end

  let(:builder) { TrelloFs::LabelBuilder.new(TestRepository.new, label) }

  describe '#path' do
    subject { builder.path }

    it { should include 'Labels' }
    it { should include 'Label_Name.md' }
  end

  describe '#content' do
    subject { builder.content }

    it { should include 'Label Name' }
    it { should include 'Card 1' }
  end
end
