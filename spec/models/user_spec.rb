require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with an email, name and password, and password_confirmation" do
    user = User.new(
      email: "tester@example.com",
      name: "たかあき",
      password: "aaaaaaaa",
      password_confirmation: "aaaaaaaa"
    )
    expect(user).to be_valid
  end

  it "is invalid wothout an email" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid wothout a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "is invalid wothout a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end
end
