class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :start
      t.datetime :end
      t.string :location
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
