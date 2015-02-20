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
      "# #{list_name}\n\n#{content}"
    end

    def content(full_path = false)
      @list.cards.map do |card|
        cb = CardBuilder.new(self, card)
        card_path = cb.file_name
        card_path = File.join(list_name, card_path) if full_path

        "- [#{cb.card_name}](#{card_path})"
      end.join("\n")
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

    def repository
      @board_builder.repository
    end
  end
end
