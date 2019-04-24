shared_examples 'a model with conditionally updatable attributes' do |unrestricted_attrs, permissible_attrs, response| # rubocop:disable Metrics/LineLength
  let(:override_attrs) {}
  let(:new_attrs) do
    attrs = record.attributes.symbolize_keys.transform_values do |value|
      if value.is_a?(String)
        '_'
      elsif value.is_a?(Date)
        value + 1.day
      elsif value.is_a?(TrueClass) || value.is_a?(FalseClass)
        !value
      else
        value
      end
    end

    attrs.merge(override_attrs)
  end

  subject(:request) do
    put(record_url,
        data: {
          id: record.id,
          type: record_type(record),
          attributes: new_attrs
        })
  end

  describe 'when without permission' do
    before { request && record.reload }

    it_behaves_like response == :ok ? '200 OK' : '204 No Content'

    unrestricted_attrs.each do |attribute|
      it { expect(record[attribute]).to eq(new_attrs[attribute]) }
    end

    permissible_attrs.each do |attribute|
      it { expect(record[attribute]).not_to eq(new_attrs[attribute]) }
    end
  end

  describe 'when with permission' do
    before do
      user.update(user_permissions: [FactoryBot.create(:permission, name: record_permission)])
      request
      record.reload
    end

    it_behaves_like response == :ok ? '200 OK' : '204 No Content'

    (unrestricted_attrs + permissible_attrs).each do |attribute|
      it { expect(record[attribute]).to eq(new_attrs[attribute]) }
    end
  end
end
