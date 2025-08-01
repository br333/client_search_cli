RSpec.describe Shiftcare::Utils::Downloader do
  let(:tmp_dir) { Dir.mktmpdir }
  let(:file_name) { "clients.json" }
  let(:file_path) { File.join(tmp_dir, file_name) }
  let(:url) { "https://api.example.com/" }

  before do
    Shiftcare::Utils::Base.download_dir = "#{tmp_dir}/"
    Shiftcare::Utils::Base.url = url
  end

  after do
    FileUtils.remove_entry(tmp_dir) if File.directory?(tmp_dir)
  end

  describe "#call" do
    context "when file does not exist" do
      before do
        stub_request(:get, "#{url}#{file_name}")
          .to_return(status: 200, body: '{"id":1,"name":"Test"}')
      end

      it "downloads and saves the file" do
        described_class.new.call(file_name)
        expect(File.exist?(file_path)).to be true
        content = File.read(file_path)
        expect(content).to include('"id":1')
      end
    end

    context "when file already exists" do
      before do
        File.write(file_path, '{"cached":true}')
      end

      it "does not download again" do
        expect_any_instance_of(described_class).not_to receive(:download)
        described_class.new.call(file_name)
        expect(File.read(file_path)).to include('"cached":true')
      end
    end

    context "when HTTP response is not 200" do
      before do
        stub_request(:get, "#{url}#{file_name}")
          .to_return(status: 404, body: 'Not Found')
      end

      it "raises DownloadError" do
        expect {
          described_class.new.call(file_name)
        }.to raise_error(Shiftcare::Utils::DownloadError, /Non-success status code/)
      end
    end
  end
end