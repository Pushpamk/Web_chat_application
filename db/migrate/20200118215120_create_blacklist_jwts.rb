class CreateBlacklistJwts < ActiveRecord::Migration[6.0]
  def change
    create_table :blacklist_jwts, id: :uuid do |t|
      t.string :token

      t.timestamps
    end
  end
end
