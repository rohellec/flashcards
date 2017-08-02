require 'rails_helper'

describe Card do
  let(:card) { create(:card) }

  describe "with :translated_text == :original_text" do
    let(:new_card) { Card.new }
    before { new_card.translated_text = new_card.original_text }

    it "was not saved to database" do
      new_card.save
      expect(new_card.persisted?).to be_falsey
    end
  end

  describe ":review_date after creation" do
    it "is set to 3 days from now" do
      expect(card.review_date).to eq(3.days.from_now.to_date)
    end
  end

  describe ".for_review" do
    it "contains only cards with review_date <= today" do
      card.update(review_date: Date.current)
      expect(Card.for_review).to include(card)
    end

    it "doesn't contain cards with review_date later then today" do
      card.update(review_date: Date.tomorrow)
      expect(Card.for_review).not_to include(card)
    end
  end

  describe "#right_translation?(arg)" do
    it "returns true if arg == :original_text" do
      arg = card.original_text
      expect(card.right_translation?(arg)).to be_truthy
    end

    it "returns false if arg != :original_text" do
      arg = card.original_text * 2
      expect(card.right_translation?(arg)).to be_falsey
    end
  end
end
