# frozen_string_literal: true

module Api
  # OnboardersController
  class OnboardersController < ApplicationController
    def create
      onboarder = Onboarder.find_or_initialize_by(onboarder_key_params)
      if onboarder_params[:submitted_at] && onboarder.submitted_at.to_i < DateTime.parse(onboarder_params[:submitted_at]).to_i
        onboarder.assign_attributes(onboarder_params)
      end
      if onboarder.save
        render json: onboarder, status: :ok
      else
        render json: onboarder.errors, status: :unprocessable_entity
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def onboarder_params
      params.require(:onboarder).permit(:start_date, :department, :location, :submitted_at)
    end

    def onboarder_key_params
      params.require(:onboarder).permit(:employee_id, :company_id)
    end
  end
end
