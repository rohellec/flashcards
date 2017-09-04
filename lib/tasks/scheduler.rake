desc "Notify users with pending cards"
task send_notification: :environment do
  puts "Sending emails..."
  User.send_pending_cards_notification
  puts "done."
end
