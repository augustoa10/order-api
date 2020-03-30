require "rails_helper"

RSpec.describe UserService do
  subject(:service) { described_class.new(user_repository: user_repository) }

  let(:user_repository) { instance_spy UserRepository }

  its(:user_repository) { is_expected.to eq user_repository }

  describe "#create" do
    subject { service.create(name: name, cpf: cpf, email: email) }

    let(:name) { Faker::JapaneseMedia::DragonBall.character }
    let(:cpf) { Faker::IDNumber.brazilian_citizen_number }
    let(:email) { Faker::Internet.email }
    let(:user_model) { build(:user, name: name, cpf: cpf, email: email) }

    before do
      allow(user_repository).to receive(:create).with(
        name: name,
        cpf: cpf,
        email: email
      ).and_return(user_model)
    end

    it { is_expected.to eq user_model }

    context "when create user failed" do
      before do
        allow(user_repository).to receive(:create).with(
          name: name,
          cpf: cpf,
          email: email
        ).and_raise(UserRepository::CreateError)
      end

      it { expect { subject }.to raise_error UserService::CreateError }
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

    let(:user_model) { build(:user, name: params[:name]) }

    before do
      allow(user_repository).to receive(:update).with(
        id: id, **params
      ).and_return(user_model)
    end

    it { is_expected.to eq user_model }

    context "when user not found" do
      before do
        allow(user_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(UserRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error UserService::NotFoundError }
    end

    context "when update user failed" do
      before do
        allow(user_repository).to receive(:update).with(
          id: id, **params
        ).and_raise(UserRepository::UpdateError)
      end

      it { expect { subject }.to raise_error UserService::UpdateError }
    end
  end

  describe "#destroy" do
    subject { service.destroy(id: id) }

    let(:id) { Faker::Number.digit }

    before do
      allow(user_repository).to receive(:destroy).with(id: id).and_return(true)
    end

    it { is_expected.to eq true }

    context "when user not found" do
      before do
        allow(user_repository).to receive(:destroy).with(id: id).and_raise(UserRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error UserService::NotFoundError }
    end
  end

  describe "#find" do
    subject { service.find(id: id) }

    let(:id) { Faker::Number.digit }
    let(:user_model) { build :user }

    before do
      allow(user_repository).to receive(:find_by_id).with(id).and_return(user_model)
    end

    it { is_expected.to eq user_model }

    context "when user not found" do
      before do
        allow(user_repository).to receive(:find_by_id).with(id).and_raise(UserRepository::NotFoundError)
      end

      it { expect { subject }.to raise_error UserService::NotFoundError }
    end
  end

  describe "#list" do
    subject { service.list }

    let(:user_model) { build :user }
    let(:all_users) { [user_model] }

    before do
      allow(user_repository).to receive(:list).and_return(all_users)
    end

    it { is_expected.to eq all_users }
  end
end
