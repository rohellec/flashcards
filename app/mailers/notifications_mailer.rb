class NotificationsMailer < ApplicationMailer
  def pending_cards(user)
    @cards = user.cards_for_review
    mail(to: user.email, subject: "Напоминание об оставшихся карточках")
  end
end
