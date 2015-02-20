module TrelloFs
  class StringToFileName
    def self.convert(str)
      str.gsub('/', '-')
    end
  end
end
