require "rails_helper"

RSpec.describe OrderService do
  subject(:service) do
    described_class.new(
      order_repository: order_repository,
      plan_repository: plan_repository,
      user_repository: user_repository
    )
  end

  let(:order_repository) { instance_spy OrderRepository }
  let(:plan_repository) { instance_spy PlanRepository }
  let(:user_repository) { instance_spy OrderRepository }

  its(:order_repository) { is_expected.to eq order_repository }
  its(:plan_repository) { is_expected.to eq plan_repository }
  its(:user_repository) { is_expected.to eq user_repository }

  describe "#create" do
    subject do
      service.create(
        device_imei: device_imei,
        device_model: device_model,
        installments: installments,
        plan_id: plan_id,
        user_id: user_id
      )
    end

    let(:device_imei) { Faker::Device.serial }
    let(:device_model) { Faker::Device.model_name }
    let(:installments) { Faker::Number.digit }
    let(:plan_id) { Faker::Number.digit }
    let(:user_id) { Faker::Number.digit }
    let(:user_model) { build_stubbed :user, id: user_id }
    let(:plan_model) { build_stubbed :plan, id: plan_id }

    let(:order_model) do
      build(:order,
        device_imei: device_imei,
        device_model: device_model,
        installments: installments,
        plan: plan_model,
        user: user_model
      )
    end

    before do
      allow(user_repository).to receive(:find_by_id).with(user_id).and_return(user_model)
      allow(plan_repository).to receive(:find_by_id).with(plan_id).and_return(plan_model)
      allow(order_repository).to receive(:create).with(
        device_imei: device_imei,
        device_model: device_model,
        installments: installments,
        plan_id: plan_model.id,
        user_id: user_model.id
      ).and_return(order_model)
    end

    it { is_expected.to eq order_model }

    context "when user not found error" do
      before do
        allow(user_repository).to receive(:find_by_id).with(user_id).and_raise(UserRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::CreateError }
    end

    context "when create order failed" do
      before do
        allow(order_repository).to receive(:create).with(
          device_imei: device_imei,
          device_model: device_model,
          installments: installments,
          plan_id: plan_model.id,
          user_id: user_model.id
        ).and_raise(OrderRepository::CreateError)
      end

      it { expect { subject }.to raise_error OrderService::CreateError }
    end
  end

  describe "#update" do
    subject { service.update(id: id, **params) }

    let(:id) { Faker::Number.digit }
    let(:params) do
      {
        device_model: Faker::Device.model_name
      }
    end
    let(:order_model) { build(:order, device_model: params[:device_model]) }

    before do
      allow(order_repository).to receive(:update).with(
        id: id, **params
      ).and_return(order_model)
    end

    it { is_expected.to eq order_model }

    context "when User not found" do
      let(:params) do
        {
          device_model: Faker::Device.model_name,
          user_id: 2
        }
      end

      before do
        allow(user_repository).to receive(:find_by_id).with(
          params[:user_id]
        ).and_raise(UserRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::UpdateError }
    end

    context "when Plan not found" do
      let(:params) do
        {
          device_model: Faker::Device.model_name,
          plan_id: 2
        }
      end

      before do
        allow(plan_repository).to receive(:find_by_id).with(
          params[:plan_id]
        ).and_raise(PlanRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::UpdateError }
    end

    context "when Order not found" do
      before do
        allow(order_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(OrderRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::NotFoundError }
    end

    context "when update order failed" do
      before do
        allow(order_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(OrderRepository::UpdateError)
      end

      it { expect { subject }.to raise_error OrderService::UpdateError }
    end
  end

  describe "#destroy" do
    subject { service.destroy(id: id) }

    let(:id) { Faker::Number.digit }

    before do
      allow(order_repository).to receive(:destroy).with(id: id).and_return(true)
    end

    it { is_expected.to eq true }

    context "when order not found" do
      before do
        allow(order_repository).to receive(:destroy).with(id: id).and_raise(OrderRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::NotFoundError }
    end
  end

  describe "#find" do
    subject { service.find(id: id) }

    let(:id) { Faker::Number.digit }
    let(:order_model) { build :order }

    before do
      allow(order_repository).to receive(:find_by_id).with(id).and_return(order_model)
    end

    it { is_expected.to eq order_model }

    context "when order not found" do
      before do
        allow(order_repository).to receive(:find_by_id).with(id).and_raise(OrderRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error OrderService::NotFoundError }
    end
  end

  describe "#list" do
    subject { service.list }

    let(:order_model) { build :order }
    let(:all_orders) { [order_model] }

    before do
      allow(order_repository).to receive(:list).and_return(all_orders)
    end

    it { is_expected.to eq all_orders }
  end
end
