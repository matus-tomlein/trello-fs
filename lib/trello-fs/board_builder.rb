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
        "# [#{board_name}](#{@board.url})",
        labels_content,
        "[#{repository_name}](../README.md)",
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

    def labels_content
      return '' unless @board.labels && @board.labels.any?

      @board.labels.sort {|a, b| a.name <=> b.name }.
        select {|lbl| lbl.cards.any? }.
        map do |label|
        label_builder = LabelBuilder.new(@repository, label)
        "[`#{label_builder.label_name}`](../#{label_builder.relative_path})"
      end.join(' ')
    end

    def path
      File.join(@repository.path, folder_name)
    end

    def folder_name
      StringToFileName.convert(board_name)
    end

    alias_method :relative_path, :folder_name

    def board_name
      @board.name
    end

    def repository_name
      @repository.title
    end
  end
end
