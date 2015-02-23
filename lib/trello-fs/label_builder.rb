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
      @label.cards.sort {|a,b| a.name <=> b.name }.map do |card|
        card_builder = CardBuilder.new_by_card(@repository, card)
        path = '../' + card_builder.relative_path
        link = "[#{card_builder.card_name}](#{path})"
          "- #{link}"
      end.join("\n")
    end

    def label_name
      @label.name.empty? ? 'no name' : @label.name
    end
  end
end
