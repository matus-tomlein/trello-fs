module TrelloFs
  class LabelsBuilder
    attr_reader :repository, :board

    def initialize(repository, board)
      @repository = repository
      @board = board
    end

    def build
      @board.labels.each do |label|
        LabelBuilder.new(self, label).build
      end
    end
  end
end
