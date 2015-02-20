require 'spec_helper'

describe TrelloFs::StringToFileName do
  subject { TrelloFs::StringToFileName }

  describe '.convert' do
    it 'is unique for different strings' do
      expect(subject.convert('one')).not_to eq subject.convert('two')
    end

    it 'is the same for the same strings' do
      expect(subject.convert('one')).to eq subject.convert('one')
    end

    it 'replaces slashes with dashes' do
      expect(subject.convert('a file/path')).to eq 'a file-path'
    end
  end
end
