require "rails_helper"

RSpec.describe DeviceService do
  subject(:service) { described_class.new(device_client: device_client) }

  let(:device_client) { instance_spy Pitzi::Client }

  describe "#find" do
    subject { service.list(name: name) }

    let(:name) { Faker::Device.model_name }
    let(:device_model) { build :device }

    before do
      allow(device_client).to receive(:devices).with(name: name).and_return(device_model)
    end

    it { is_expected.to eq device_model }

    context "when communication error" do
      before do
        allow(device_client).to receive(:devices).with(name: name).and_raise(Pitzi::Client::CommunicationError)
      end

      it { expect { subject }.to raise_error DeviceService::ListError }
    end
  end
end
