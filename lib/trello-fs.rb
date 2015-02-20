Dir[File.dirname(__FILE__) + "/**/*.rb"].each { |file| require file }
require 'fileutils'

module TrelloFs
  def self.build(config)
    Builder.new(config).build
  end
end
