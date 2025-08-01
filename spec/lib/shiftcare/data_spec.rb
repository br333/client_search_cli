require 'json'

RSpec.describe Shiftcare::Data do
  let(:fixtures_path) { File.expand_path("../fixtures", __dir__) }
  subject(:data) { described_class.new(file_name) }
  let(:file_name) { "valid.json" }

  before do
    allow(Shiftcare::Utils::Base).to receive(:download_dir).and_return("#{fixtures_path}/")
    allow(Shiftcare::Utils::Base).to receive(:schema_dir).and_return("#{fixtures_path}/")
    allow(Shiftcare::Utils::Base).to receive(:metadata_dir).and_return("#{fixtures_path}/")
  end

  describe "#all" do
    context "with valid JSON" do
      it "parses the JSON file into an array of hashes" do
        result = data.all
        expect(result).to be_a(Array)
        expect(result.first).to include(id: 1, email: "john.doe@gmail.com", full_name: "John Doe")
      end
    end

    context "with empty JSON array" do
      let(:file_name) { "empty.json" }

      it "returns an empty array" do
        expect(data.all).to eq([])
      end
    end

    context "with invalid JSON format" do
      let(:file_name) { "invalid.json" }

      before do
        allow(Shiftcare::Utils::Base).to receive(:download_dir).and_return("#{fixtures_path}/")
      end

      it "raises a parse error" do
        expect { described_class.new(file_name).all }.to raise_error(Yajl::ParseError)
      end
    end
  end

  describe "#metadata" do
    it "returns a Metadata instance" do
      expect(data.metadata).to be_a(Shiftcare::Data::Metadata)
    end
  end

  describe "#schema" do
    it "returns a Schema instance" do
      expect(data.schema).to be_a(Shiftcare::Data::Schema)
    end
  end

  describe "#query" do
    it "returns a Query instance" do
      expect(data.query).to be_a(Shiftcare::Data::Query)
    end
  end
end