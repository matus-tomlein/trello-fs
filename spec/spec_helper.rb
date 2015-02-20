require File.expand_path("../../lib/trello-fs", __FILE__)
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each { |file| require file }
require 'ostruct'

RSpec.configure do |config|
  config.after :each do
    TestRepository.remove
  end
end
