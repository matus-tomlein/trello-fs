require 'spec_helper'

describe TrelloFs::AttachmentCleaner do
  describe '#remove_old_attachments' do
    let(:repository) { TestRepository.new }

    let(:old_attachment) { File.join(repository.path, 'Attachments/Board/old/old_attachment.jpg') }
    let(:new_attachment) { File.join(repository.path, 'Attachments/Board/new/new_attachment.jpg') }

    subject { TrelloFs::AttachmentCleaner.new(repository) }

    let(:board) { OpenStruct.new name: 'Board' }
    let(:list) { OpenStruct.new name: 'l', board: board }
    let(:card) { OpenStruct.new name: 'new', list: list }

    before :each do
      repository.attachments << OpenStruct.new(
        name: 'new_attachment.jpg',
        card: card
      )

      [new_attachment, old_attachment].each do |attachment|
        FileUtils.mkpath(File.dirname(attachment))
        File.open(attachment, 'w') {|f| f.write('a') }
      end
      subject.remove_old_attachments
    end

    it 'should remove the old file' do
      expect(File.exist?(old_attachment)).to eq false
    end

    it 'should keep the new file' do
      expect(File.exist?(new_attachment)).to eq true
    end

    it 'should remove the old folder' do
      expect(File.exist?(File.dirname(old_attachment))).to eq false
    end
  end
end
