require "rails_helper"

RSpec.describe HttpClient::FaradayDriver do
  subject(:driver) { described_class.new url: url }

  let(:url) { "http://example.com" }

  its(:url) { is_expected.to eq url }

  describe "#get" do
    subject { driver.get path, params: params, headers: headers }

    let(:path) { "some-path" }
    let(:params) { { a: 1 } }
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:response_body) { "something" }

    before do
      stub_request(:get, File.join(url, path))
        .with(query: params, headers: headers)
        .to_return(status: 200, body: response_body)
    end

    it { is_expected.to be_a Http::Response }
    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq response_body }

    context "when Faraday raises a ConnectionError" do
      before do
        stub_request(:get, File.join(url, path))
          .with(query: params, headers: headers)
          .and_raise(Faraday::ConnectionFailed)
      end

      it { expect { subject }.to raise_error HttpClient::Driver::ConnectionFailed }
    end
  end

  describe "#post" do
    subject { driver.post path, body: body, headers: {} }

    let(:path) { "some-path" }
    let(:body) { { a: 1 } }
    let(:response_body) { "something" }

    before do
      stub_request(:post, File.join(url, path))
        .with(
          body: body,
          headers: { "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: response_body)
    end

    it { is_expected.to be_a Http::Response }
    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq response_body }

    context "when Faraday raises a ConnectionError" do
      before do
        stub_request(:post, File.join(url, path))
          .with(body: body, headers: { "Content-Type" => "application/json" })
          .and_raise(Faraday::ConnectionFailed)
      end

      it { expect { subject }.to raise_error HttpClient::Driver::ConnectionFailed }
    end
  end

  describe "#put" do
    subject { driver.put path, body: body, headers: headers }

    let(:path) { "some-path" }
    let(:body) { { a: 1 } }
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:response_body) { "something" }

    before do
      stub_request(:put, File.join(url, path))
      .with(
        body: body,
        headers: headers
      )
      .to_return(status: 200, body: response_body)
    end

    it { is_expected.to be_a Http::Response }
    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq response_body }

    context "when Faraday raises a ConnectionError" do
      before do
        stub_request(:put, File.join(url, path))
          .with(body: body, headers: headers)
          .and_raise(Faraday::ConnectionFailed)
      end

      it { expect { subject }.to raise_error HttpClient::Driver::ConnectionFailed }
    end
  end

  describe "#patch" do
    subject { driver.patch path, body: body, headers: headers }

    let(:path) { "some-path" }
    let(:body) { { a: 1 } }
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:response_body) { "something" }

    before do
      stub_request(:patch, File.join(url, path))
      .with(
        body: body,
        headers: headers
      )
      .to_return(status: 200, body: response_body)
    end

    it { is_expected.to be_a Http::Response }
    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq response_body }

    context "when Faraday raises a ConnectionError" do
      before do
        stub_request(:patch, File.join(url, path))
          .with(body: body, headers: headers)
          .and_raise(Faraday::ConnectionFailed)
      end

      it { expect { subject }.to raise_error HttpClient::Driver::ConnectionFailed }
    end
  end

  describe "#delete" do
    subject { driver.delete path, body: body, headers: headers }

    let(:path) { "some-path/1" }
    let(:body) { { a: 1 } }
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:response_body) { "something" }

    before do
      stub_request(:delete, File.join(url, path))
        .with(body: body, headers: headers)
        .to_return(status: 200, body: response_body)
    end

    it { is_expected.to be_a Http::Response }
    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq response_body }

    context "when Faraday raises a ConnectionError" do
      before do
        stub_request(:delete, File.join(url, path))
          .with(body: body, headers: headers)
          .and_raise(Faraday::ConnectionFailed)
      end

      it { expect { subject }.to raise_error HttpClient::Driver::ConnectionFailed }
    end
  end
end
