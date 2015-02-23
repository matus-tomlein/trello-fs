module TrelloFs
  class Builder
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def build
      repository = Repository.new(@config, self)

      # remove old files from the repo
      RepositoryCleaner.new(repository).clean

      TrelloApi.new(repository).boards.each do |board|
        BoardBuilder.new(repository, board).build
      end

      # remove old attachments
      AttachmentCleaner.new(repository).remove_old_attachments
    end

    def trello_api_board(repository)
      Trello::Board.find(repository.board_id)
    end
  end
end
