require 'rails_helper'

RSpec.describe UserArchiveJob, type: :job do
  describe '#perform' do
    let(:archive_user) { create(:user, id: 0) }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    subject(:job) { described_class.perform_now(user.id) }

    describe 'keep entities are migrated to archive user' do
      before do
        create(:article_comment, author: user)
        create(:photo_comment, author: user)
        create(:article, author: user)
        create(:activity, author: user)
        create(:photo_tag, author: user, tagged_user: other_user)
        create(:photo, uploader: user)
        create(:photo_album, author: user)
        create(:poll, author: user)
        create(:quickpost_message, author: user)
        create(:response, user: user)
        create(:form, author: user)
        create(:post, author: user)
        create(:thread, author: user)
        create(:collection, author: user)
      end

      it { expect { job }.to change { ArticleComment.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { PhotoComment.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Article.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { Activity.last.author }.from(user).to(archive_user) }
      it { expect { job }.to change { PhotoTag.last.author }.from(user).to(archive_user) }
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
        create(:board_room_presence, user: user)
        create(:mandate, user: user)
        create(:transaction, user: user)
        create(:mail_alias, user: user)
        create(:membership, user: user)
        create(:permissions_users, user: user)
        create(:photo_tag, tagged_user: user)
      end

      it { expect { job }.to change(BoardRoomPresence, :count).by(-1) }
      it { expect { job }.to change(Debit::Mandate, :count).by(-1) }
      it { expect { job }.to change(Debit::Transaction, :count).by(-1) }
      it { expect { job }.to change(MailAlias, :count).by(-1) }
      it { expect { job }.to change(Membership, :count).by(-1) }
      it { expect { job }.to change(PermissionsUsers, :count).by(-1) }
      it { expect { job }.to change(PhotoTag, :count).by(-1) }
      it { expect { job }.to change { User.exists?(user.id) }.from(true).to(false) }
    end
  end
end
