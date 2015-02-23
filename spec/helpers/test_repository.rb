require 'fileutils'

class TestRepository < TrelloFs::Repository
  def initialize
    super({
      path: TestRepository.path,
      developer_public_key: '',
      member_token: '',
      board_ids: ['']
    })
  end

  def self.path
    p = 'tmp/test_repo'
    FileUtils.mkpath p
    p
  end

  def self.remove
    FileUtils.rm_rf path
  end
end
