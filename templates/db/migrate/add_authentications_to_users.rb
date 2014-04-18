class AddAuthenticationsToUsers < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider, :null=>false
      t.string :uid, :null=>false
    end

    add_index :authentications, [:provider,:uid], :unique=>true
  end
end
