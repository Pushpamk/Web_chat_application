class AddConfirmedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirmed, :boolean, :default => 0
  end
end
