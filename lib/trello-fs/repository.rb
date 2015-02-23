module TrelloFs
  class Repository
    attr_reader :config, :cards, :labels, :attachments

    def initialize(config, builder = nil)
      raise 'Wrong arguments' unless has_required_configuration?(config)

      @config = config
      @builder = builder
      @cards = {}
      @attachments = []
      @labels = {}
    end

    def path
      @config[:path]
    end

    def board_ids
      @config[:board_ids]
    end

    def developer_public_key
      config[:developer_public_key]
    end

    def member_token
      config[:member_token]
    end

    def title
      config[:title]
    end

    def description
      config[:description]
    end

    private

    def has_required_configuration?(config)
      config.has_key?(:path) &&
        config.has_key?(:board_ids) &&
        config.has_key?(:developer_public_key) &&
        config.has_key?(:title) &&
        config.has_key?(:member_token)
    end
  end
end
