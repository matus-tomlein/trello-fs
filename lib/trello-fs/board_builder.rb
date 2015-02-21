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
      LabelsBuilder.new(@repository, @board).build

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
        label_builder = LabelBuilder.new(LabelsBuilder.new(@repository, @board), label)
        "[`#{label_builder.label_name}`](#{label_builder.relative_path})"
      end.join(' ')
    end

    def path
      @repository.path
    end

    def board_name
      @board.name
    end
  end
end
