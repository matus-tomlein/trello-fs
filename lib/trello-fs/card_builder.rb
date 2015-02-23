module TrelloFs
  class CardBuilder
    def initialize(list_builder, card)
      @card = card
      @list_builder = list_builder
    end

    def build
      @list_builder.build_path

      attachment_paths = @card.attachments.map do |attachment|
        attachment_builder = AttachmentBuilder.new(self, attachment)
        attachment_builder.build
        attachment_builder.relative_path
      end

      File.open(path, 'w') do |file|
        file.write(content(attachment_paths))
      end
    end

    def path
      File.join(@list_builder.path, file_name)
    end

    def relative_path
      File.join(@list_builder.file_name, file_name)
    end

    def file_name
      "#{StringToFileName.convert(@card.name)}.md"
    end

    def content(attachment_paths = [])
      labels = card_labels.map do |lbl|
        label_builder = LabelBuilder.new(LabelsBuilder.new(repository, board), lbl)
        "[`#{label_builder.label_name}`](../#{label_builder.relative_path})"
      end.sort.join(' ')
      list_name = @list_builder.list_name
      board_name = @list_builder.board_name

      [
        "# [#{card_name}](#{@card.url})",
        [
          "[#{board_name}](../README.md)",
          "[#{list_name}](README.md)"
        ].join(' > '),
        labels,
        @card.desc,
        attachments_content(attachment_paths)
      ].join("\n\n")
    end

    def attachments_content(attachment_paths = [])
      return '' unless attachment_paths.any?

      links = attachment_paths.map do |path|
        name = path.split('/').last
        path = "../#{path}"
        link = "[#{name}](#{path})"
        if path.end_with?('.png') || path.end_with?('.jpg') || path.end_with?('gif') || path.end_with?('.jpeg')
          "!#{link}"
        else
          link
        end
      end.join("  \n")

      "\n\n## Attachments\n\n#{links}"
    end

    def card_name
      @card.name
    end

    def repository
      @list_builder.repository
    end

    def card_labels
      @card_labels ||= @card.labels
    end

    def board
      @list_builder.board_builder.board
    end
  end
end
