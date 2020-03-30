require "rails_helper"

RSpec.describe PlanService do
  subject(:service) { described_class.new(plan_repository: plan_repository) }

  let(:plan_repository) { instance_spy PlanRepository }

  its(:plan_repository) { is_expected.to eq plan_repository }

  describe "#create" do
    subject { service.create(name: name, description: description, yearly_price: yearly_price) }

    let(:name) { Faker::Subscription.plan }
    let(:description) { Faker::Lorem.sentence }
    let(:yearly_price) { Faker::Number.decimal(l_digits: 2) }
    let(:plan_model) { build(:plan, name: name, description: description, yearly_price: yearly_price) }

    before do
      allow(plan_repository).to receive(:create).with(
        name: name,
        description: description,
        yearly_price: yearly_price
      ).and_return(plan_model)
    end

    it { is_expected.to eq plan_model }

    context "when create plan failed" do
      before do
        allow(plan_repository).to receive(:create).with(
          name: name,
          description: description,
          yearly_price: yearly_price
        ).and_raise(PlanRepository::CreateError)
      end

      it { expect { subject }.to raise_error PlanService::CreateError }
    end
  end

  describe "#update" do
    subject { service.update(id: id, **params) }

    let(:id) { Faker::Number.digit }
    let(:params) do
      {
        name: Faker::JapaneseMedia::DragonBall.character,
      }
    end

    let(:plan_model) { build(:plan, name: params[:name]) }

    before do
      allow(plan_repository).to receive(:update).with(
        id: id, **params
      ).and_return(plan_model)
    end

    it { is_expected.to eq plan_model }

    context "when plan not found" do
      before do
        allow(plan_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(PlanRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error PlanService::NotFoundError }
    end

    context "when update plan failed" do
      before do
        allow(plan_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(PlanRepository::UpdateError)
      end

      it { expect { subject }.to raise_error PlanService::UpdateError }
    end
  end

  describe "#destroy" do
    subject { service.destroy(id: id) }

    let(:id) { Faker::Number.digit }

    before do
      allow(plan_repository).to receive(:destroy).with(id: id).and_return(true)
    end

    it { is_expected.to eq true }

    context "when plan not found" do
      before do
        allow(plan_repository).to receive(:destroy).with(id: id).and_raise(PlanRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error PlanService::NotFoundError }
    end
  end

  describe "#find" do
    subject { service.find(id: id) }

    let(:id) { Faker::Number.digit }
    let(:plan_model) { build :plan }

    before do
      allow(plan_repository).to receive(:find_by_id).with(id).and_return(plan_model)
    end

    it { is_expected.to eq plan_model }

    context "when plan not found" do
      before do
        allow(plan_repository).to receive(:find_by_id).with(id).and_raise(PlanRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error PlanService::NotFoundError }
    end
  end

  describe "#list" do
    subject { service.list }

    let(:plan_model) { build :plan }
    let(:all_plans) { [plan_model] }

    before do
      allow(plan_repository).to receive(:list).and_return(all_plans)
    end

    it { is_expected.to eq all_plans }
  end
end
