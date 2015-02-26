module TrelloFs
  class StringToFileName
    def self.convert(str)
      str.gsub(/[^\w\s_-]+/, '').
        gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2').
        gsub(/\s+/, '_')
    end
  end
end
