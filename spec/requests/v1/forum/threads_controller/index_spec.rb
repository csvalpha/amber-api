require 'rails_helper'

describe V1::Forum::ThreadsController do
  before { Bullet.enable = false }

  after { Bullet.enable = true }

  describe 'GET /forum/threads', version: 1 do
    let(:records) { FactoryBot.create_list(:thread, 3) }
    let(:record_url) { '/v1/forum/threads' }
    let(:record_permission) { 'forum/thread.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[title]
  end
end
