require "rails_helper"

describe NotificationsMailer do
  let(:user) { create(:user_with_cards) }
  let(:mail) { NotificationsMailer.pending_cards(user) }

  describe "pending_cards" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "sends email" do
      mail.deliver_now
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "mail header has subject" do
      expect(mail.subject).to match("Напоминание")
    end

    it "mail sent from noreply mailbox" do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "mail is sent to user" do
      expect(mail.to).to eq([user.email])
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
