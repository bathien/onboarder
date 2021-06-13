# frozen_string_literal: true

class CreateOnboarders < ActiveRecord::Migration[6.1]
  def change
    create_table :onboarders do |t|
      t.bigint :employee_id
      t.bigint :company_id
      t.date :start_date
      t.string :department
      t.string :location
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
