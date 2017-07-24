module DecksHelper
  def current_deck
    current_user.current_deck
  end
end
