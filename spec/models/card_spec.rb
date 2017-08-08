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

  describe "#review(arg)" do
    let(:review_tries) do
      {
        1 => 12.hours.from_now.to_date,
        2 => 3.days.from_now.to_date,
        3 => 1.week.from_now.to_date,
        4 => 2.weeks.from_now.to_date,
        5 => 1.month.from_now.to_date
      }
    end
    let(:right) { card.original_text }
    let(:wrong) { card.original_text * 2 }

    it "returns true if arg == :original_text" do
      expect(card.review(right)).to be_truthy
    end

    it "returns false if arg != :original_text" do
      expect(card.review(wrong)).to be_falsey
    end

    describe ":review_date" do
      context "after creation" do
        it "is set to current date" do
          expect(card.review_date).to eq(Date.current)
        end
      end

      context "after successful reviews" do
        it "is set according to a number of review tries" do
          review_tries.each do |_num, date|
            card.review(card.original_text)
            expect(card.review_date).to eq(date)
          end
        end
      end

      context "after 3 failed reviews in a row" do
        context "before any successful review" do
          it "is set to current date" do
            3.times { card.review(wrong) }
            expect(card.review_date).to eq(Date.current)
          end
        end

        context "if there was a number of successful reviews before" do
          before do
            5.times { card.review(card.original_text) }
          end

          it "is set according to a previous number of review tries" do
            (1..4).reverse_each do |num|
              3.times { card.review(wrong) }
              expect(card.review_date).to eq(review_tries[num])
            end
          end
        end
      end
    end

    describe ":success_reviews" do
      it "is increased after successful review" do
        expect { card.review(card.original_text) }.to change(card, :success_reviews).by(1)
      end

      it "is decreased after 3 failed reviews in a row" do
        card.success_reviews = 1
        3.times { card.review(wrong) }
        expect(card.success_reviews).to be_zero
      end

      it "is not decreased after less than 3 failed reviews in a row" do
        card.success_reviews = 1
        2.times { card.review(wrong) }
        expect(card.success_reviews).to eq(1)
      end

      it "can't be less than zero" do
        card.success_reviews = 0
        expect { card.review(wrong) }.not_to change(card, :success_reviews)
      end
    end

    describe ":fail_reviews" do
      it "is increased after failed review" do
        expect { card.review(wrong) }.to change(card, :fail_reviews).by(1)
      end

      it "is set to 0 after successful review" do
        card.review(card.original_text)
        expect(card.fail_reviews).to be_zero
      end
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
end
