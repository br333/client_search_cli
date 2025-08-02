# frozen_string_literal: true

RSpec.describe Shiftcare::Utils::Base do
  before do
    described_class.url = 'https://api.example.com'
    described_class.exchange_layer_dir = '/tmp/exchange'
    described_class.download_dir = '/tmp/downloads'
    described_class.metadata_dir = '/tmp/metadata'
    described_class.schema_dir = '/tmp/schema'
  end

  describe '.url=' do
    it 'sets the URL when valid' do
      expect(described_class.url).to eq('https://api.example.com')
    end

    it 'raises ConfigError for nil' do
      expect { described_class.url = nil }.to raise_error(Shiftcare::Utils::Base::ConfigError)
    end

    it 'raises ConfigError for empty string' do
      expect { described_class.url = '  ' }.to raise_error(Shiftcare::Utils::Base::ConfigError)
    end
  end

  describe '.download_dir=' do
    it 'sets the download directory' do
      expect(described_class.download_dir).to eq('/tmp/downloads')
    end

    it 'raises ConfigError if path is nil' do
      expect { described_class.download_dir = nil }.to raise_error(Shiftcare::Utils::Base::ConfigError)
    end
  end

  describe '.metadata_dir=' do
    it 'sets the metadata directory' do
      expect(described_class.metadata_dir).to eq('/tmp/metadata')
    end
  end

  describe '.schema_dir=' do
    it 'sets the schema directory' do
      expect(described_class.schema_dir).to eq('/tmp/schema')
    end
  end

  describe '.exchange_layer_dir=' do
    it 'sets the exchange layer directory' do
      expect(described_class.exchange_layer_dir).to eq('/tmp/exchange')
    end
  end

  describe '.configs' do
    it 'returns a hash of current configurations' do
      configs = described_class.configs
      expect(configs[:url]).to eq('https://api.example.com')
      expect(configs[:paths][:download_dir]).to eq('/tmp/downloads')
      expect(configs[:paths][:metadata_dir]).to eq('/tmp/metadata')
      expect(configs[:paths][:schema_dir]).to eq('/tmp/schema')
    end
  end

  describe '.configure' do
    it 'yields self' do
      described_class.configure do |config|
        config.url = 'https://api.test.com'
        config.download_dir = '/tmp/block_download'
      end
      expect(described_class.url).to eq('https://api.test.com')
      expect(described_class.download_dir).to eq('/tmp/block_download')
    end
  end
end
