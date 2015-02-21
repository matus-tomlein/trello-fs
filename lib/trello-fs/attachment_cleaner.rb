require 'fileutils'
require 'set'

module TrelloFs
  class AttachmentCleaner
    def initialize(repository, board)
      @repository = repository
      @board = board
    end

    def set_of_attachment_paths
      @board.attachments.map do |attachment|
        AttachmentBuilder.new(
          CardBuilder.new(
            ListBuilder.new(
              BoardBuilder.new(@repository, @board),
              attachment.card.list
            ), attachment.card
          ), attachment).path
      end.to_set
    end

    def remove_old_attachments
      new_attachments = set_of_attachment_paths

      Dir.
        glob(File.join(@repository.path, "Attachments/**/*")).
        reject {|fn| File.directory?(fn) }.
        each do |file|
          next if new_attachments.include? file
          FileUtils.rm(file)

          # remove parent dir if empty
          dirname = File.dirname(file)
          FileUtils.rm_rf(dirname) if Dir[File.join(dirname, '*')].empty?
        end
    end
  end
end
