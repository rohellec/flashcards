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

  context "decks and cards" do
    let(:deck)       { create(:deck_with_cards, user: user) }
    let(:other_deck) { create(:deck_with_cards, name: "Последнее", user: user) }

    before { user.save }

    describe "#cards_for_review" do
      it "contains cards from all of user's decks if no deck is selected" do
        (other_deck.cards + deck.cards).each do |deck_card|
          expect(user.cards_for_review).to include(deck_card)
        end
      end

      it "contains only cards from current_deck when it is selected" do
        user.switch_deck(deck)
        expect(user.cards_for_review - deck.cards).to be_empty
      end

      it "contains only cards with review_date less or equal to current" do
        user.cards_for_review.each do |card|
          expect(card.review_date).to be <= Date.current
        end
      end
    end

    describe "#switch_deck" do
      before { user.switch_deck(deck) }

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

  context "notification" do
    describe ".with_pending_cards" do
      let(:notified_user)    { create(:user_with_cards) }
      let(:un_notified_user) { create(:user_without_pending_cards, email: "foo@bar.com") }

      it "contains users that have pending cards" do
        expect(User.with_pending_cards).to include(notified_user)
      end

      it "doesn't contain users without pending cards" do
        expect(User.with_pending_cards).not_to include(un_notified_user)
      end
    end
  end
end
