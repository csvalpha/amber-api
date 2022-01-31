require 'rails_helper'

RSpec.describe UserArchiveJob, type: :job do
  describe '#perform' do
    let(:archive_user) { FactoryBot.create(:user, id: 0) }
    let(:user) { FactoryBot.create(:user) }

    subject(:job) { described_class.perform_now(user.id) }

    describe 'keep entities are migrated to archive user' do
      before do
        FactoryBot.create(:article_comment, author: user)
        FactoryBot.create(:photo_comment, author: user)
        FactoryBot.create(:article, author: user)
        FactoryBot.create(:activity, author: user)
        FactoryBot.create(:photo, uploader: user)
        FactoryBot.create(:photo_album, author: user)
        FactoryBot.create(:poll, author: user)
        FactoryBot.create(:quickpost_message, author: user)
        FactoryBot.create(:response, user: user)
        FactoryBot.create(:form, author: user)
        FactoryBot.create(:post, author: user)
        FactoryBot.create(:thread, author: user)
        FactoryBot.create(:collection, author: user)
      end

      it { expect { job }.to change { ArticleComment.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { PhotoComment.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Article.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Activity.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Photo.last.uploader }.from(user).to(archive_user) }
      it { expect { job }.to change { PhotoAlbum.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Poll.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { QuickpostMessage.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Form::Response.last.user }.from(user).to(archive_user) }
      it { expect { job }.to change { Form::Form.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Forum::Post.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Forum::Thread.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Debit::Collection.last.author }.from(user).to(archive_user) }
    end

    describe 'other entities are destroyed' do
      before do
        FactoryBot.create(:board_room_presence, user: user)
        FactoryBot.create(:mandate, user: user)
        FactoryBot.create(:transaction, user: user)
        FactoryBot.create(:mail_alias, user: user)
        FactoryBot.create(:membership, user: user)
        FactoryBot.create(:permissions_users, user: user)
      end

      it { expect { job }.to change(BoardRoomPresence, :count).by(-1) }
      it { expect { job }.to change(Debit::Mandate, :count).by(-1) }
      it { expect { job }.to change(Debit::Transaction, :count).by(-1) }
      it { expect { job }.to change(MailAlias, :count).by(-1) }
      it { expect { job }.to change(Membership, :count).by(-1) }
      it { expect { job }.to change(PermissionsUsers, :count).by(-1) }
      it { expect { job }.to change { User.exists?(user.id) }.from(true).to(false) }
    end
  end
end
