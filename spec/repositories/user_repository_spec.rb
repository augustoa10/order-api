require "rails_helper"

RSpec.describe UserRepository do
  subject(:repository) { described_class.new }

  describe "#create" do
    subject { repository.create name: name, email: email, cpf: cpf }

    let(:name) { Faker::Name.first_name }
    let(:email) { Faker::Internet.email }
    let(:cpf) { Faker::IDNumber.brazilian_citizen_number }

    it { is_expected.to be_a User }
    it { is_expected.to be_persisted }
    its(:name) { is_expected.to eq name }
    its(:cpf) { is_expected.to eq cpf }
    its(:email) { is_expected.to eq email }

    context "when record is invalid" do
      let(:name) { nil }

      it { expect { subject }.to raise_error UserRepository::CreateError }
    end
  end

  describe "#update" do
    subject { repository.update id: user.id, **params }

    let!(:user) { create :user, name: "old name" }
    let(:new_name) { "new name" }

    let(:params) { { name: new_name } }

    its(:name) { is_expected.to eq(new_name) }

    context "when record is invalid" do
      let(:new_name) { nil }

      it { expect { subject }.to raise_error UserRepository::UpdateError }
    end
  end

  describe "#find_by_id" do
    subject { repository.find_by_id id }

    let(:id) { user.id }
    let(:user) { create :user }

    it { is_expected.to eq user }

    context "when the user does not exist" do
      let(:id) { 9999999999 }

      it { expect { subject }.to raise_error described_class::NotFoundError }
    end
  end

  describe "#destroy" do
    subject { repository.destroy id: id }

    let(:id) { user.id }
    let!(:user) { create :user }

    it { is_expected.to eq user }
    it { is_expected.to_not be_persisted }
  end

  describe "#list" do
    subject { repository.list }

    let!(:user) { create :user }

    it { is_expected.to eq [user] }
  end
end
