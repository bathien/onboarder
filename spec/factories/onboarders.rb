# frozen_string_literal: true

FactoryBot.define do
  factory :onboarder do
    employee_id { 1 }
    company_id { 1 }
    start_date { '2021-06-12' }
    department { 'MyString' }
    location { 'MyString' }
    submitted_at { '2021-06-12' }
  end
end
