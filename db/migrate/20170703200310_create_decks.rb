class CreateDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :decks do |t|
      t.references :user, foreign_key: true, index: true
      t.string :name

      t.timestamps
    end

    add_column :cards, :deck_id, :integer, foreign_key: true, index: true
    add_column :users, :current_deck_id, :integer, index: true
    remove_column :cards, :user_id, :integer
  end
end
