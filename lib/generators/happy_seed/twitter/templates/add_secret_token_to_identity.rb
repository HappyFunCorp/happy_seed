class AddSecretTokenToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :secrettoken, :string
  end
end