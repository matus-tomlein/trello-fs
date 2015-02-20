require 'open-uri'

module TrelloFs
  class AttachmentBuilder
    attr_reader :card_builder, :attachment

    def initialize(card_builder, attachment)
      @card_builder = card_builder
      @attachment = attachment
    end

    def build
      return if already_downloaded?

      download_and_save
    end

    def download_and_save
      data = download
      return unless data

      FileUtils.mkpath(full_folder_path) unless File.exist? full_folder_path
      File.open(path, 'wb') do |file|
        file.write data
      end
    end

    def path
      File.join(full_folder_path, file_name)
    end

    def relative_path
      File.join(folder_path, file_name)
    end

    def folder_path
      File.join('Attachments', StringToFileName.convert(@card_builder.card_name))
    end

    def full_folder_path
      File.join(repository.path, folder_path)
    end

    def file_name
      StringToFileName.convert("#{@attachment.id}-#{@attachment.name}")
    end

    def already_downloaded?
      File.exist? path
    end

    def download
      open(@attachment.url).read
    end

    def repository
      @card_builder.repository
    end
  end
end
