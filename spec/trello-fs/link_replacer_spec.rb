require 'spec_helper'

describe TrelloFs::LinkReplacer do
  let(:repository) { TestRepository.new }
  let(:list) do
    OpenStruct.new(
      name: 'List Name',
      board: OpenStruct.new(name: 'Board Name')
    )
  end
  let(:card1) do
    OpenStruct.new(
      desc: 'https://trello.com/c/card2id/71-software-center-denmark-day-25-2-2015',
      name: 'Card 1',
      list: list
    )
  end
  let(:card2) do
    OpenStruct.new(
      desc: 'https://trello.com/c/card1id some text https://trello.com/c/card2id',
      name: 'Card 2',
      list: list
    )
  end

  before :each do
    repository.cards['card1id'] = card1
    repository.cards['card2id'] = card2
  end

  subject { TrelloFs::LinkReplacer.new(repository) }

  describe '#links_in_description' do
    it 'finds links with text at the end' do
      expect(subject.links_in_description(card1)).to eq [
        ['https://trello.com/c/card2id/71-software-center-denmark-day-25-2-2015', 'card2id']
      ]
    end

    it 'finds all the links' do
      expect(subject.links_in_description(card2)).to eq [
        ['https://trello.com/c/card1id', 'card1id'],
        ['https://trello.com/c/card2id', 'card2id']
      ]
    end
  end

  describe '#card_description' do
    it 'removes the links from the description' do
      expect(subject.card_description(card1)).not_to include 'https://trello.com'
      expect(subject.card_description(card2)).not_to include 'https://trello.com'
    end

    it 'keeps other text' do
      expect(subject.card_description(card2)).to include 'some text'
    end

    it 'creates links to local files' do
      expect(subject.card_description(card1)).to include 'Card 2'
      expect(subject.card_description(card1)).to include 'List_Name/Card_2'

      expect(subject.card_description(card2)).to include 'Card 1'
      expect(subject.card_description(card2)).to include 'List_Name/Card_1'
      expect(subject.card_description(card2)).to include 'Card 2'
      expect(subject.card_description(card2)).to include 'List_Name/Card_2'
    end
  end
end
