shared_examples 'a model with dependent destroy relationship' do |relationship|
  let(:model_name) { described_class.to_s.underscore.split('/').last }
  let(:model) { FactoryBot.create(model_name) }
  let(:relation) { FactoryBot.create(relationship, model_name => model) }

  before do
    model
    relation
  end

  it { expect { model.destroy }.to(change { relation.class.count }.by(-1)) }
end
