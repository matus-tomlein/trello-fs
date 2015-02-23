module TrelloFs
  class LabelsBuilder
    attr_reader :repository

    def initialize(repository)
      @repository = repository
    end

    def build
      @repository.labels.values.each do |label|
        LabelBuilder.new(@repository, label).build
      end
    end
  end
end
