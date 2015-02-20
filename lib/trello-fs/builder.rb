module TrelloFs
  class Builder
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def build
      repository = Repository.new config
      clean_repository repository

      board_builder = BoardBuilder.new(repository,
                                       trello_api_board(repository))
      board_builder.build
    end

    def trello_api_board(repository)
      Trello::Board.find(repository.board_id)
    end

    def clean_repository(repository)
      RepositoryCleaner.new(repository).clean
    end
  end
end
