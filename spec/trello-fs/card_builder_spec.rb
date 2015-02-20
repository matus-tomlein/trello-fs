require 'spec_helper'

describe TrelloFs::CardBuilder do

  let(:card) do
    card = OpenStruct.new(name: 'Card Name', desc: 'Card Description',
                          labels: [], attachments: [])

    3.times do |i|
      card.labels << OpenStruct.new(name: "Label #{i}")
    end
    card
  end

  let(:list) do
    list = OpenStruct.new
    list.name = 'List Name'
    list
  end

  let(:board) do
    board = OpenStruct.new
    board.name = 'Board'
    board
  end

  let(:board_builder) { TrelloFs::BoardBuilder.new(TestRepository.new, board) }
  let(:list_builder) { TrelloFs::ListBuilder.new(board_builder, list) }
  let(:card_builder) { TrelloFs::CardBuilder.new(list_builder, card) }

  subject { card_builder }

  describe '#content' do
    subject { card_builder.content(['Attachments/file.pdf', 'Attachments/picture.png']) }

    it { should include 'Card Name' }
    it { should include 'Card Description' }
    it { should include 'Label 1' }
    it { should include 'Label 2' }
    it { should include 'List Name' }
    it { should include '[file.pdf' }
    it { should include '![picture.png]' }
  end

  describe '#path' do
    it 'returns the correct path' do
      expected_path = File.join(TestRepository.path, 'List_Name/Card_Name.md')
      expect(subject.path).to eq expected_path
    end
  end

  describe '#build' do
    it 'creates a file with the content' do
      subject.build

      expect(File).to exist subject.path
      expect(File.read(subject.path)).to eq subject.content
    end
  end
end
