require 'open-uri'
require 'json'

module TrelloFs
  class TrelloApi
    def initialize(repository)
      @repository = repository
      @boards = {}
    end

    def boards
      @repository.board_ids.map do |board_id|
        board(board_id)
      end
    end

    def board(board_id)
      @boards[board_id] ||= new_board(board_id)
    end

    def new_board(board_id)
      json = download_board_json(board_id)
      board = OpenStruct.new(name: json['name'],
                             desc: json['desc'],
                             id: json['id'],
                             url: json['url'])
      lists = {}

      board.organization_name = json['organization']['displayName'] if json['organization']

      board.labels = json['labels'].map do |label|
        @repository.labels[label['name']] ||= OpenStruct.new name: label['name'], id: label['id'], cards: []
      end

      json['lists'].each do |list|
        lists[list['id']] = OpenStruct.new(name: list['name'],
                                           id: list['id'],
                                           board: board,
                                           cards: [])
      end

      cards = json['cards'].
        select {|card| lists[card['idList']] }.
        map do |card|
        list = lists[card['idList']]
        c = OpenStruct.new(id: card['id'],
                           name: card['name'],
                           desc: card['desc'],
                           url: card['url'],
                           short_link: card['shortLink'],
                           list: list)
        list.cards << c

        c.labels = card['labels'].map do |label|
          label = @repository.labels[label['name']]
          label.cards << c
          label
        end

        c.checklists = card['checklists'].map do |checklist|
          OpenStruct.new(
            name: checklist['name'],
            items: checklist['checkItems'].map do |item|
              OpenStruct.new(name: item['name'], state: item['state'])
            end
          )
        end

        c.attachments = card['attachments'].map do |attachment|
          a = OpenStruct.new(name: attachment['name'],
                             url: attachment['url'],
                             id: attachment['id'],
                             card: c)
          @repository.attachments << a
          a
        end

        @repository.cards[card['shortLink']] = card
        c
      end

      board.lists = lists.values

      board
    end

    def download_board_json(board_id)
      url = "https://api.trello.com/1/boards/#{board_id}?key=#{@repository.developer_public_key}&token=#{@repository.member_token}&cards=open&lists=open&labels=all&card_checklists=all&card_attachments=true&organization=true&labels_limit=999"
      JSON.parse(open(url).read)
    end
  end
end
