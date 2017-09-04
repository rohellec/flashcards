set :output, error:    File.expand_path("log/error.log"),
             standard: File.expand_path("log/cron.log")
set :chronic_options, hours24: true

every 1.day, at: "12:00" do
  runner "User.send_pending_cards_notification"
end
