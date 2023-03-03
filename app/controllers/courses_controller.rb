# frozen_string_literal: true

class CoursesController < ApplicationController
  def create
    @course = Course.create(course_params)
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :status, :user_id, :slack_channel_name)
  end
end
