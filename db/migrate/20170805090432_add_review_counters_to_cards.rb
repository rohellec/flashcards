class AddReviewCountersToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :success_reviews, :integer, default: 0
    add_column :cards, :fail_reviews, :integer, default: 0
  end
end
