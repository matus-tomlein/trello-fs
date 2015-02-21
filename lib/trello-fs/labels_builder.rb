module TrelloFs
  class LabelsBuilder
    def initialize(repository, board)
      @repository = repository
      @board = board
    end

    def build
      @board.labels.each do |label|
        LabelBuilder.new(@repository, label).build
      end
    end
  end
end
