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

  context "#switch_deck" do
    let(:deck)       { create(:deck, user: user) }
    let(:other_deck) { create(:deck, name: "Последнее", user: user) }

    before do
      user.save
      user.switch_deck(deck)
    end

    context "for noncurrent deck" do
      it "makes deck current" do
        expect(deck).to eq(user.current_deck)
      end

      it "makes previous current deck noncurrent" do
        user.switch_deck(other_deck)
        expect(deck).not_to eq(user.current_deck)
      end
    end

    context "for current deck" do
      before { user.switch_deck(deck) }

      it "makes current deck nil" do
        expect(user.current_deck).to be_nil
      end
    end
  end
end
