require 'rails_helper'

describe Card do
  let(:card) { build(:card) }

  describe "validations" do
    context "for presence" do
      context "with filled attributes" do
        it { expect(card).to be_valid }
      end

      context "with empty attributes" do
        let(:empty_card) { Card.new }
        before { empty_card.validate }

        it { expect(empty_card).to be_invalid }

        it "contains error message for :original_text" do
          expect(empty_card.errors[:original_text]).not_to be_empty
        end

        it "contains error message for :translated_text" do
          expect(empty_card.errors[:original_text]).not_to be_empty
        end

        it "contains error message for :review_date" do
          expect(empty_card.errors[:original_text]).not_to be_empty
        end
      end
    end

    context " for :translated_text != :original_text" do
      before do
        card.translated_text = card.original_text
        card.validate
      end

      it { expect(card).to be_invalid }

      it "contains error message for :translated_text" do
        expect(card.errors[:translated_text]).not_to be_empty
      end
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

  describe "#update_next_review_date" do
    before do
      card.save
      card.update_next_review_date
    end

    it "updates :review_date to 3 days from today" do
      expect(card.review_date).to eq(3.days.from_now.to_date)
    end
  end
end
