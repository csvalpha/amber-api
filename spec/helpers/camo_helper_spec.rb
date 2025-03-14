require 'rails_helper'

RSpec.describe CamoHelper do
  include described_class
  describe '#camo' do
    it do
      expect(camo('http://example.org/image.jpg')).to eq(
        'https://example.org/d87bfef52ecbfda9b5319a1d7818fd53c4d119f2b0205cb7f8538860ac357cb0/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067'
      )
    end
  end
end
