module TrelloFs
  class ListBuilder
    attr_reader :board_builder, :list

    def initialize(board_builder, list)
      @board_builder = board_builder
      @list = list
    end

    def build
      list.cards.each do |card|
        CardBuilder.new(self, card).build
      end

      build_readme
    end

    def build_readme
      build_path
      readme_path = File.join(path, 'README.md')
      File.open(readme_path, 'w') do |file|
        file.write(readme_content)
      end
    end

    def readme_content
      [
        "# #{list_name}",
        "[#{board_name}](../README.md)",
        content
      ].join("\n\n")
    end

    def content(full_path = false)
      @list.cards.map do |card|
        cb = CardBuilder.new(self, card)
        card_path = cb.file_name
        card_path = File.join(file_name, card_path) if full_path

        "- [#{cb.card_name}](#{card_path})#{card_labels(card)}"
      end.join("\n")
    end

    def card_labels(card)
      labels = card.labels.sort {|a, b| a.name <=> b.name }.
        map do |label|
        "`#{label.name}`"
      end

      if labels.any?
        ' ' + labels.join(' ')
      else
        ''
      end
    end

    def path
      File.join(@board_builder.path, file_name)
    end

    def file_name
      StringToFileName.convert(@list.name)
    end

    def build_path
      FileUtils.mkpath(path) unless File.exist? path
    end

    def list_name
      @list.name
    end

    def board_name
      @board_builder.board_name
    end

    def repository
      @board_builder.repository
    end
  end
end
