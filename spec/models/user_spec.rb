require 'rails_helper'

describe User do
  let(:user) { build(:user) }

  it "is invalid with incorrect email addresses" do
    invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.",
                         "foo@bar_baz.com", "foo@bar+baz.com"]
    invalid_addresses.each do |address|
      user.email = address
      expect(user).to be_invalid, "#{address} should be invalid"
    end
  end

  it "is valid with correct email addresses" do
    valid_addresses = ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org",
                       "first.last@foo.jp", "alice+bob@baz.cn"]
    valid_addresses.each do |address|
      user.email = address
      expect(user).to be_valid, "#{address} should be valid"
    end
  end
end
