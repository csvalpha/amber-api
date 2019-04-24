require 'rails_helper'

describe V1::ApplicationController do
  subject(:application_controller) { described_class.new }

  describe '#permitted_serializable_attributes' do
    before do
      allow(application_controller).to receive(:current_user) { User.new }
      allow(application_controller).to receive(:current_application).and_return(nil)
      allow(application_controller).to receive(:model_class).and_return(Article)
      allow(application_controller).to receive(:authorize).and_return(true)
    end

    describe 'with params[:attrs] nil' do
      before { allow(application_controller).to receive(:params).and_return({}) }

      it do
        expect(application_controller.__send__(:permitted_serializable_attributes)).to eq [:id]
      end
    end

    describe 'with params[:attrs] empty string' do
      before { allow(application_controller).to receive(:params).and_return(attrs: '') }

      it do
        expect(application_controller.__send__(:permitted_serializable_attributes)).to eq [:id]
      end
    end

    describe 'when passing params[:attrs]' do
      before do
        allow(application_controller).to receive(:params).and_return(
          attrs: 'created_at,updated_at,not_permitted'
        )
      end

      it do
        expect(application_controller.__send__(:permitted_serializable_attributes)).to(
          contain_exactly(:created_at, :updated_at)
        )
      end
    end
  end

  describe '#set_model' do
    before do
      model_class = Article
      allow(model_class).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      allow(application_controller).to receive(:model_class) { model_class }
      allow(application_controller).to receive(:params).and_return({})
      allow(application_controller).to receive(:authorize).and_return(true)
      allow(application_controller).to receive(:head)
    end

    it 'returns 404 on RangeError' do
      application_controller.__send__(:set_model)
      expect(application_controller).to have_received(:head).with(:not_found)
    end
  end

  describe '#current_user' do
    let(:my_app) do
      Doorkeeper::Application.create(name: 'MyApp', redirect_uri: 'https://testhost:1338/users/auth/amber_oauth2/callback')
    end
    let(:access_token) { Doorkeeper::AccessToken.create!(application_id: my_app.id) }

    before do
      allow(application_controller).to receive(:doorkeeper_token).and_return(access_token)
    end

    it { expect(application_controller.current_user).to eq nil }
    it { expect(application_controller.current_application).to eq my_app }
  end
end
