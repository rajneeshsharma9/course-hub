# frozen_string_literal: true

class CreateTutors < ActiveRecord::Migration[8.0]
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :email
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
