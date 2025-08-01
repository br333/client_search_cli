RSpec.describe Shiftcare::Data::Query do
  let(:fixtures_dir) { File.expand_path("../../fixtures", __dir__) }
  let(:file_name) { "valid.json" }
  let(:data_instance) { Shiftcare::Data.new(file_name) }
  let(:query) { described_class.new(data_instance) }

  before do
    Shiftcare::Utils::Base.download_dir = "#{fixtures_dir}/"
    Shiftcare::Utils::Base.metadata_dir = "#{fixtures_dir}/"
    Shiftcare::Utils::Base.schema_dir = "#{fixtures_dir}/"
  end

  describe "#initialize" do
    it "raises InvalidInstance for wrong class" do
      expect { described_class.new(Object.new) }
        .to raise_error(Shiftcare::Data::Query::InvalidInstance)
    end

    it "sets available filters based on metadata keys" do
      expect(query.available_filters).to include(:id, :email, :full_name)
    end
  end

  describe "#where" do
    context "with valid integer criteria" do
      it "returns matching record" do
        results = query.where(id: 1)
        expect(results.size).to eq(1)
        expect(results.first[:full_name]).to eq("John Doe")
      end
    end

    context "with valid string substring criteria" do
      let(:file_name) { "with_duplicates.json" }

      it "returns partial matches" do
        results = query.where(full_name: "jane")
        expect(results.map { |r| r[:full_name] }).to include("Jane Smith", "Another Jane Smith")
      end
    end

    context "with invalid key" do
      it "raises ValidationError" do
        expect { query.where(unknown: "test") }
          .to raise_error(Shiftcare::Data::Query::ValidationError, /Invalid key/)
      end
    end

    context "with invalid type" do
      it "raises ValidationError" do
        expect { query.where(id: "not_integer") }
          .to raise_error(Shiftcare::Data::Query::ValidationError, /Invalid content type/)
      end
    end
  end

  describe "#duplicates" do
    context "when duplicates" do
      let(:file_name) { "with_duplicates.json" }

      it "returns duplicate entries with index" do
        dups = query.duplicates
        expect(dups).not_to be_empty
      end
    end

    context "when no duplicates" do
      it "returns empty array" do
        expect(query.duplicates).to eq([])
      end
    end
  end

  context "when schema file is missing" do
    before do
      allow_any_instance_of(Shiftcare::Data::Schema)
        .to receive(:parser)
        .and_return(double(check_file: false))
    end

    it "prints warning and returns nil" do
      expect { query.where(id: 1) }.to output(/Schema not found/).to_stdout
    end
  end
end