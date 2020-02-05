class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :text
      t.references :conversation,type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
