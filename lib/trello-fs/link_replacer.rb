module TrelloFs
  class LinkReplacer
    def initialize(repository)
      @repository = repository
    end

    def card_description(card)
      links = links_in_description(card)
      description = card.desc.dup

      links.each do |link|
        url = link.first
        short_link = link.last

        linked_card = @repository.cards[short_link]
        next unless linked_card

        card_builder = CardBuilder.new_by_card(@repository, linked_card)
        link_to_card = "[#{card_builder.card_name}](../../#{card_builder.relative_path})"
        description.gsub!(url, link_to_card)
      end

      description
    end

    def links_in_description(card)
      card.desc.scan(/(https:\/\/trello.com\/c\/[\w]*(?:\/[\w_=+-]*)?)/).map do |match|
        url = match.first
        url.match(/https:\/\/trello.com\/c\/([\w]*)/)
        short_id = $1
        [url, short_id]
      end
    end
  end
end
