require 'fileutils'

module TrelloFs
  class RepositoryCleaner
    def initialize(repository)
      @repository = repository
    end

    def clean
      Dir.entries(@repository.path).each do |path|
        next if path.start_with? '.'
        next if path == 'Attachments'

        FileUtils.rm_rf File.join(@repository.path, path)
      end
    end
  end
end
