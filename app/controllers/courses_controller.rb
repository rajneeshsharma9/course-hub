# frozen_string_literal: true

class CoursesController < ApplicationController
  def create
    course = Course.new(course_params)

    if course.save
      render_success(course, status: :created, include: :tutors)
    else
      render_error(course)
    end
  end

  def index
    courses = Course.includes(:tutors).all
    render_success(courses, include: :tutors)
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      :description,
      tutors_attributes: [:name, :email]
    )
  end
end
