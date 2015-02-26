require 'fileutils'
require 'set'

module TrelloFs
  class AttachmentCleaner
    def initialize(repository)
      @repository = repository
    end

    def set_of_attachment_paths
      @repository.attachments.map do |attachment|
        AttachmentBuilder.new_by_attachment(@repository, attachment).path
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
