# frozen_string_literal: true

RSpec.describe Shiftcare::Utils::Downloader do
  subject(:downloader) { described_class }
  let(:url) { 'https://appassets02.shiftcare.com/manual/clients.json' }
  let(:exchange_layer_path) { './exchange_layer' }

  before do
    stub_request(:get, url)
    downloader.new.call
  end

  describe '#call' do
    context 'when provided with valid configurations' do
      xit 'should create exchange layer path' do
      end

      xit 'should create a filename in json' do
      end
    end

    context 'when provided with invalid configurations' do
      xit 'should raise configuration error' do
      end
      xit '' do
      end
    end

    context 'when file that is being dowloaded failed' do
      xit 'should raise error providing error message' do
      end
      xit '' do
      end
    end
  end
end
