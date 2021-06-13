# frozen_string_literal: true

class AddUniqueIndexToOnboarder < ActiveRecord::Migration[6.1]
  def change
    add_index :onboarders, %i[employee_id company_id], unique: true
  end
end
