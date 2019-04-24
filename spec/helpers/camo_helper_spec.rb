require 'rails_helper'

RSpec.describe CamoHelper, type: :helper do
  include described_class
  describe '#camo' do
    it do
      expect(camo('http://example.org/image.jpg')).to eq(
        'https://example.org/c7125941763fc18c9d8977ed19028ca5f9378070/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067'
      )
    end
  end
end
