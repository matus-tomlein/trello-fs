module TrelloFs
  class LabelBuilder
    def initialize(repository, label)
      @repository = repository
      @label = label
    end

    def build
      FileUtils.mkpath(folder_path)

      File.open(path, 'w') do |f|
        f.write content
      end
    end

    def path
      File.join(folder_path, file_name)
    end

    def relative_path
      File.join('Labels', file_name)
    end

    def folder_path
      File.join(@repository.path, 'Labels')
    end

    def file_name
      "#{StringToFileName.convert(label_name)}.md"
    end

    def content
      [
        "# `#{label_name}`",
        "[#{@repository.title}](../README.md)",
        card_links
      ].join("\n\n")
    end

    def card_links
      card_structure.sort.map do |board_path, lists|
        list_paths = lists.sort.map do |list_path, cards|
          card_paths = cards.sort.map do |card_path|
            "- #{card_path}"
          end.join("\n")

          "## #{list_path}\n\n#{card_paths}"
        end.join("\n\n")

        "# #{board_path}\n\n#{list_paths}"
      end.join("\n\n")
      # links.sort {|a,b| a <=> b }.join("\n")
    end

    def card_structure
      structure = {}

      @label.cards.map do |card|
        card_builder = CardBuilder.new_by_card(@repository, card)
        board_builder = card_builder.board_builder
        list_builder = card_builder.list_builder

        board_path = "[#{board_builder.board_name}](../#{board_builder.relative_path}/README.md)"
        list_path = "[#{list_builder.list_name}](../#{list_builder.relative_path}/README.md)"
        card_path = "[#{card_builder.card_name}](../#{card_builder.relative_path})"

        ((structure[board_path] ||= {})[list_path] ||= []) << card_path
      end

      structure
    end

    def label_name
      @label.name.empty? ? 'no name' : @label.name
    end
  end
end
