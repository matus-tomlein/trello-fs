module TrelloFs
  class BoardBuilder
    attr_reader :repository, :board

    def initialize(repository, board)
      @repository = repository
      @board = board
    end

    def build
      board.lists.each do |list|
        ListBuilder.new(self, list).build
      end

      build_readme
    end

    def build_readme
      readme_path = File.join(path, 'README.md')
      File.open(readme_path, 'w') do |file|
        file.write(readme_content)
      end
    end

    def readme_content
      [
        "# #{board_name}",
        board.lists.map do |list|
          list_builder = ListBuilder.new(self, list)
          list_link = "[#{list_builder.list_name}](#{list_builder.file_name}/README.md)"

          [
            "## #{list_link}",
            list_builder.content(true)
          ].join("\n\n")
        end.join("\n\n")
      ].join("\n\n")
    end

    def path
      @repository.path
    end

    def board_name
      @board.name
    end
  end
end
