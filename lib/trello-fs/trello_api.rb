require 'open-uri'
require 'json'

module TrelloFs
  class TrelloApi
    def initialize(repository)
      @repository = repository
    end

    def board
      @board ||= new_board
    end

    def new_board
      json = download_board_json
      board = OpenStruct.new name: json['name'], desc: json['desc'], id: json['id']
      labels, lists = {}, {}
      board.attachments = []

      board.organization_name = json['organization']['displayName'] if json['organization']

      json['labels'].each do |label|
        labels[label['id']] = OpenStruct.new name: label['name'], id: label['id'], cards: []
      end

      json['lists'].each do |list|
        lists[list['id']] = OpenStruct.new(name: list['name'],
                                           id: list['id'],
                                           board: board,
                                           cards: [])
      end

      cards = json['cards'].map do |card|
        list = lists[card['idList']]
        c = OpenStruct.new(id: card['id'],
                           name: card['name'],
                           desc: card['desc'],
                           list: list)
        list.cards << c

        c.labels = card['idLabels'].map do |label_id|
          label = labels[label_id]
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
          board.attachments << a
          a
        end

        c
      end

      board.labels = labels.values
      board.lists = lists.values

      board
    end

    def download_board_json
      url = "https://api.trello.com/1/boards/#{@repository.board_id}?key=#{@repository.developer_public_key}&token=#{@repository.member_token}&cards=all&lists=all&labels=all&card_checklists=all&card_attachments=true&organization=true"
      JSON.parse(open(url).read)
    end
  end
end
