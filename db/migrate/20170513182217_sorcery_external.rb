class SorceryExternal < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string :provider, :uid, null: false

      t.timestamps null: false
    end

    add_index :authentications, [:provider, :uid]
  end
end
