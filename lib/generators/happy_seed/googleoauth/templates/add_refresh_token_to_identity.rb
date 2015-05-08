class AddRefreshTokenToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :refreshtoken, :string
  end
end