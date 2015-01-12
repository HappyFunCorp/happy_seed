class MakeEmailNullable < ActiveRecord::Migration
  def change
    change_column_null :users, :email, true
    remove_index :users, :email
    add_index :users, :email
  end
end