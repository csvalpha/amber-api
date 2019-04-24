require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do
  include described_class
  describe '#camofy' do
    it { expect(camofy(nil)).to eq nil }

    it do
      expect(camofy("plain text \n ![alt text](http://example.org/image.jpg)")).to eq(
        "plain text \n ![alt text](https://example.org/c7125941763fc18c9d8977ed19028ca5f9378070/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067)"
      )
    end

    it do
      expect(camofy('plain text ![](http://example.org/image.jpg)')).to eq(
        'plain text ![](https://example.org/c7125941763fc18c9d8977ed19028ca5f9378070/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067)'
      )
    end

    # rubocop:disable Metrics/LineLength
    it do
      expect(camofy('![](http://example.org/image.jpg "Image title")')).to eq(
        '![](https://example.org/c7125941763fc18c9d8977ed19028ca5f9378070/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067 "Image title")'
      )
    end

    it do
      expect(camofy('![](http://example.org/image.jpg =100x* "Image title")')).to eq(
        '![](https://example.org/c7125941763fc18c9d8977ed19028ca5f9378070/687474703a2f2f6578616d706c652e6f72672f696d6167652e6a7067 =100x* "Image title")'
      )
    end
    # rubocop:enable Metrics/LineLength
  end
end
