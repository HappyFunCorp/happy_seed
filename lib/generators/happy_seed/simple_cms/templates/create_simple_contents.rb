class CreateSimpleContents < ActiveRecord::Migration[5.0]
  def change
    create_table :simple_contents do |t|
      t.string :key
      t.string :title
      t.text :body
      t.integer :priority

      t.timestamps
    end

    add_index :simple_contents, :key
  end
end
