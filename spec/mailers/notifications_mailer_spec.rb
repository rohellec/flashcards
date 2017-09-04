require "rails_helper"

describe NotificationsMailer do
  let(:user) { create(:user_with_cards) }
  let(:mail) { NotificationsMailer.pending_cards(user) }

  describe "pending_cards" do
    it "mail header has subject" do
      expect(mail.subject).to match("Напоминание")
    end

    it "mail body contains list of cards" do
      mail.parts.each do |part|
        user.cards.each do |card|
          expect(part.decoded).to match(card.translated_text)
        end
      end
    end
  end
end
