require "rails_helper"

RSpec.describe PlanRepository do
  subject(:repository) { described_class.new }

  describe "#create" do
    subject { repository.create name: name, description: description, yearly_price: yearly_price }

    let(:name) { Faker::Subscription.plan }
    let(:description) { Faker::Lorem.sentence }
    let(:yearly_price) { Faker::Number.decimal(l_digits: 2) }

    it { is_expected.to be_a Plan }
    it { is_expected.to be_persisted }
    its(:name) { is_expected.to eq name }
    its(:description) { is_expected.to eq description }
    its(:yearly_price) { is_expected.to eq yearly_price }

    context "when record is invalid" do
      let(:description) { nil }

      it { expect { subject }.to raise_error PlanRepository::CreateError }
    end
  end

  describe "#update" do
    subject { repository.update id: plan.id, **params }

    let!(:plan) { create :plan, name: "old name" }
    let(:new_name) { "new name" }

    let(:params) { { name: new_name } }

    its(:name) { is_expected.to eq(new_name) }

    context "when record is invalid" do
      let(:description) { nil }
      let(:params) { { description: description } }

      it { expect { subject }.to raise_error PlanRepository::UpdateError }
    end
  end

  describe "#find_by_id" do
    subject { repository.find_by_id id }

    let(:id) { plan.id }
    let(:plan) { create :plan }

    it { is_expected.to eq plan }

    context "when the plan does not exist" do
      let(:id) { 9999999999 }

      it { expect { subject }.to raise_error described_class::NotFoundError }
    end
  end

  describe "#destroy" do
    subject { repository.destroy id: id }

    let(:id) { plan.id }
    let!(:plan) { create :plan }

    it { is_expected.to eq plan }
    it { is_expected.to_not be_persisted }
  end

  describe "#list" do
    subject { repository.list }

    let!(:plan) { create :plan }

    it { is_expected.to eq [plan] }
  end
end
