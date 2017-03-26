require 'rails_helper'

describe Card do
  let(:card) { build(:card) }

  describe "with :translated_text == :original_text" do
    before { card.translated_text = card.original_text }

    it { expect(card).to be_invalid }

    it "was not saved to database" do
      card.save
      expect(card.persisted?).to be_falsey
    end
  end

  describe ":review_date after creation" do
    before { card.save }

    it "is set to 3 days from now" do
      card.save
      expect(card.review_date).to eq(3.days.from_now.to_date)
    end
  end

  describe ".for_review" do
    before { card. save }

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
