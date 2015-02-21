module TrelloFs
  class Builder
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def build
      repository = Repository.new config, self
      board = TrelloApi.new(repository).board

      # remove old files from the repo
      RepositoryCleaner.new(repository).clean

      BoardBuilder.new(repository, board).build

      # remove old attachments
      AttachmentCleaner.new(repository, board).remove_old_attachments
    end

    def trello_api_board(repository)
      Trello::Board.find(repository.board_id)
    end
  end
end
