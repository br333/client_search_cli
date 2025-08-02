# frozen_string_literal: true

RSpec.describe Shiftcare::Data::Metadata do
  let(:fixtures_dir) { File.expand_path('../../fixtures', __dir__) }
  let(:file_name) { 'valid.json' }
  let(:data_instance) { Shiftcare::Data.new(file_name) }

  before do
    Shiftcare::Utils::Base.download_dir = "#{fixtures_dir}/"
    Shiftcare::Utils::Base.metadata_dir = "#{fixtures_dir}/"
    Shiftcare::Utils::Base.schema_dir = "#{fixtures_dir}/"
  end

  describe '#initialize' do
    it 'raises InvalidInstance for wrong class' do
      expect { described_class.new(Object.new) }
        .to raise_error(Shiftcare::Data::Metadata::InvalidInstance)
    end
  end

  describe '#generate' do
    it 'builds metadata with correct values' do
      metadata = described_class.new(data_instance)
      metadata.generate

      expect(metadata.metadata_values[:filename])
        .to include('valid.json')
      expect(metadata.metadata_values[:record_length]).to eq(34)
      expect(metadata.metadata_values[:keys]).to include(:id, :email, :full_name)
    end
    context 'with duplicate values' do
      let(:file_name) { 'with_duplicates.json' }
      it 'captures duplicates with indexes' do
        metadata = described_class.new(data_instance)
        metadata.generate
        dups = metadata.metadata_values[:duplicates]

        expect(dups.keys).to include('jane.smith@yahoo.com')
      end
    end
  end

  describe '#to_h' do
    it 'parses an existing metadata file' do
      metadata = described_class.new(data_instance)
      metadata.generate
      parsed = metadata.to_h

      expect(parsed).to be_a(Hash)
      expect(parsed).to have_key(:filename)
      expect(parsed).to have_key(:keys)
    end
  end

  context 'with empty dataset' do
    let(:file_name) { 'empty.json' }
    let(:data_instance) { Shiftcare::Data.new(file_name) }

    it 'handles zero records gracefully' do
      metadata = described_class.new(data_instance)
      metadata.generate

      expect(metadata.metadata_values[:record_length]).to eq(0)
      expect(metadata.metadata_values[:duplicates_count]).to eq(0)
    end
  end
end
