class RemoveAuthtokenToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :auth_token
  end
end
