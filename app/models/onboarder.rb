# frozen_string_literal: true

class Onboarder < ApplicationRecord
  validates :employee_id, uniqueness: { scope: :company_id }
  validates :employee_id, :company_id, :submitted_at, presence: true
end
