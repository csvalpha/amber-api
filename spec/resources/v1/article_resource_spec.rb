require 'rails_helper'

RSpec.describe V1::ArticleResource, type: :resource do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }

  describe '#creatable_fields' do
    let(:article) { FactoryBot.create(:article) }
    let(:context) { { user: user, model: article } }
    let(:creatable_fields) { described_class.creatable_fields(context) }
    let(:basic_fields) { %i[title content publicly_visible group cover_photo] }
    let(:permissible_fields) { %i[pinned] }

    context 'when without permission' do
      it { expect(creatable_fields).to match_array(basic_fields) }
    end

    context 'when with update permisison' do
      let(:user) { FactoryBot.create(:user, user_permission_list: ['article.update']) }

      it { expect(creatable_fields).to match_array(basic_fields + permissible_fields) }
    end
  end
end
