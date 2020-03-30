require "rails_helper"

RSpec.describe OrderRepository do
  subject(:repository) { described_class.new }

  describe "#create" do
    subject do
      repository.create(
        device_imei: device_imei,
        device_model: device_model,
        installments: installments,
        plan_id: plan_id,
        user_id: user_id
      )
    end

    let!(:user) { create :user, id: user_id }
    let!(:plan) { create :plan, id: plan_id }

    let(:device_imei) { "985866088914190" }
    let(:device_model) { Faker::Device.model_name }
    let(:installments) { Faker::Number.digit }
    let(:plan_id) { 1 }
    let(:user_id) { 1 }

    it { is_expected.to be_a Order }
    it { is_expected.to be_persisted }
    its(:device_imei) { is_expected.to eq device_imei }
    its(:device_model) { is_expected.to eq device_model }
    its(:installments) { is_expected.to eq installments }
    its(:plan_id) { is_expected.to eq plan_id }
    its(:user_id) { is_expected.to eq user_id }

    context "when record is invalid" do
      let(:installments) { nil }

      it { expect { subject }.to raise_error OrderRepository::CreateError }
    end
  end

  describe "#update" do
    subject { repository.update id: order.id, **params }

    let!(:order) { create :order, installments: 11 }
    let(:new_installments) { 21 }

    let(:params) { { installments: new_installments } }

    its(:installments) { is_expected.to eq(new_installments) }

    context "when record is invalid" do
      let(:new_installments) { nil }

      it { expect { subject }.to raise_error OrderRepository::UpdateError }
    end
  end

  describe "#find_by_id" do
    subject { repository.find_by_id id }

    let(:order) { create :order }
    let(:id) { order.id }

    it { is_expected.to eq order }

    context "when the order does not exist" do
      let(:id) { 9999999999 }

      it { expect { subject }.to raise_error described_class::NotFoundError }
    end
  end

  describe "#destroy" do
    subject { repository.destroy id: id }

    let(:id) { order.id }
    let(:order) { create :order }

    it { is_expected.to eq order }
    it { is_expected.to_not be_persisted }
  end

  describe "#list" do
    subject { repository.list }

    let(:order) { create :order }

    it { is_expected.to eq [order] }
  end
end
