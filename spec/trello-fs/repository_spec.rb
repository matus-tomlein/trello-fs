require 'spec_helper'

describe TrelloFs::Repository do
  describe '#initialize' do
    it 'raises an error if there are wrong arguments' do
      expect { subject.new({}) }.to raise_error
    end
  end
end
