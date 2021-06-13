# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Onboarder, type: :model do
  it 'is valid with valid attributes' do
    expect(FactoryBot.build(:onboarder)).to be_valid
  end

  it 'is not valid without employee_id' do
    expect(FactoryBot.build(:onboarder, employee_id: nil)).not_to be_valid
  end

  it 'is not valid without company_id' do
    expect(FactoryBot.build(:onboarder, company_id: nil)).not_to be_valid
  end

  it 'does not allow employee_id per company_id' do
    FactoryBot.create(:onboarder, employee_id: 1, company_id: 1)
    expect(FactoryBot.build(:onboarder, employee_id: 1, company_id: 1)).not_to be_valid
  end
end
