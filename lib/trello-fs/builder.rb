module TrelloFs
  class Builder
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def build
      repository = Repository.new config, self
      # remove old files from the repo
      RepositoryCleaner.new(repository).clean
      # tracks new attachments
      @attachment_cleaner = AttachmentCleaner.new repository

      BoardBuilder.new(repository,
                       trello_api_board(repository)).build

      # remove old attachments
      @attachment_cleaner.remove_old_attachments
      @attachment_cleaner = nil
    end

    def new_attachment(path)
      @attachment_cleaner.new_attachment path if @attachment_cleaner
    end

    def trello_api_board(repository)
      Trello::Board.find(repository.board_id)
    end
  end
end
