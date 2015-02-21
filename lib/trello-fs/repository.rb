module TrelloFs
  class Repository
    attr_reader :config

    def initialize(config, builder = nil)
      raise 'Wrong arguments' unless has_required_configuration?(config)

      @config = config
      @builder = builder
    end

    def path
      @config[:path]
    end

    def board_id
      @config[:board_id]
    end

    def developer_public_key
      config[:developer_public_key]
    end

    def member_token
      config[:member_token]
    end

    private

    def has_required_configuration?(config)
      config.has_key?(:path) &&
        config.has_key?(:developer_public_key) &&
        config.has_key?(:member_token)
    end
  end
end
