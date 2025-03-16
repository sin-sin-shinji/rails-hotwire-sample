class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.integer :status, default: 0
      t.integer :position, null: false

      t.timestamps
    end
  end
end
