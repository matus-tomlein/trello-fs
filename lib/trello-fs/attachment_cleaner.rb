require 'fileutils'

module TrelloFs
  class AttachmentCleaner
    def initialize(repository)
      @repository = repository
      @attachments = []
    end

    def new_attachment(path)
      @attachments << path
    end

    def remove_old_attachments
      Dir.
        glob(File.join(@repository.path, "Attachments/**/*")).
        reject {|fn| File.directory?(fn) }.
        each do |file|
          next if @attachments.include? file
          FileUtils.rm(file)

          # remove parent dir if empty
          dirname = File.dirname(file)
          FileUtils.rm_rf(dirname) if Dir[File.join(dirname, '*')].empty?
        end
    end
  end
end
