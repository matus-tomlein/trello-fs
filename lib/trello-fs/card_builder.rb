module TrelloFs
  class CardBuilder
    attr_reader :list_builder

    def self.new_by_card(repository, card)
      self.new(ListBuilder.new_by_list(repository, card.list), card)
    end

    def initialize(list_builder, card)
      @card = card
      @list_builder = list_builder
    end

    def build
      @list_builder.build_path

      attachment_paths = @card.attachments.map do |attachment|
        attachment_builder = AttachmentBuilder.new(self, attachment)
        attachment_builder.build
        if attachment_builder.is_trello_attachment?
          attachment_builder.relative_path
        else
          attachment_builder.url
        end
      end

      File.open(path, 'w') do |file|
        file.write(content(attachment_paths))
      end
    end

    def path
      File.join(@list_builder.path, file_name)
    end

    def relative_path
      File.join(@list_builder.relative_path, file_name)
    end

    def file_name
      "#{StringToFileName.convert(@card.name)}.md"
    end

    def content(attachment_paths = [])
      labels = card_labels.map do |lbl|
        label_builder = LabelBuilder.new(repository, lbl)
        "[`#{label_builder.label_name}`](../../#{label_builder.relative_path})"
      end.sort.join(' ')

      [
        "# [#{card_name}](#{@card.url})",
        [
          "[#{repository_name}](../../README.md)",
          "[#{board_name}](../README.md)",
          "[#{list_name}](README.md)"
        ].join(' > '),
        labels,
        card_description,
        attachments_content(attachment_paths)
      ].join("\n\n")
    end

    def attachments_content(attachment_paths = [])
      return '' unless attachment_paths.any?

      links = attachment_paths.map do |path|
        if is_url?(path)
          name = path
        else
          name = path.split('/').last
          path = "../../#{path}"
        end

        link = "[#{name}](#{path})"
        if path.end_with?('.png') || path.end_with?('.jpg') || path.end_with?('gif') || path.end_with?('.jpeg')
          "!#{link}"
        else
          link
        end
      end.join("\n\n")

      "\n\n## Attachments\n\n#{links}"
    end

    def card_name
      @card.name
    end

    def card_description
      LinkReplacer.new(repository).card_description(@card)
    end

    def repository
      @list_builder.repository
    end

    def card_labels
      @card_labels ||= @card.labels
    end

    def board_builder
      @list_builder.board_builder
    end

    def board
      board_builder.board
    end

    def board_name
      board_builder.board_name
    end

    def list_name
      @list_builder.list_name
    end

    def repository_name
      repository.title
    end

    private

    def is_url?(path)
      path.start_with?('http://') || path.start_with?('https://')
    end
  end
end
