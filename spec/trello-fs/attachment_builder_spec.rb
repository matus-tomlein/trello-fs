require 'spec_helper'

describe TrelloFs::AttachmentBuilder do
  let(:attachment) { OpenStruct.new(id: '1', name: 'Attachment Name') }
  let(:card) { OpenStruct.new(name: 'Card Name', attachments: [attachment]) }
  let(:list) { OpenStruct.new(name: 'List Name', cards: [card]) }
  let(:board) { OpenStruct.new(name: 'Board') }

  let(:board_builder) { TrelloFs::BoardBuilder.new(TestRepository.new, board) }
  let(:list_builder) { TrelloFs::ListBuilder.new(board_builder, list) }
  let(:card_builder) { TrelloFs::CardBuilder.new(list_builder, card) }
  let(:attachment_builder) { TrelloFs::AttachmentBuilder.new(card_builder, attachment) }

  subject { attachment_builder }

  before(:each) do
    allow(attachment_builder).to receive(:download) { 'data' }
  end

  describe '#path' do
    subject { attachment_builder.path }

    it { should include 'Card_Name' }
    it { should include 'Attachment Name' }
  end

  describe '#already_downloaded?' do
    subject { attachment_builder.already_downloaded? }

    it { should eq false }

    it 'returns true after download' do
      attachment_builder.build
      should eq true
    end
  end
end
