class CoursesController < ApplicationController
  def create
    Course.create(course_params)
  end

  private

  def course_params
    params.require(:user).permit(:title, :description, :status, :user_id, :slack_channel_name)
  end
end
