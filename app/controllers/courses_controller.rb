# frozen_string_literal: true

class CoursesController < ApplicationController
  def create
    course = Course.new(course_params)

    if course.save
      render_resourses(course, status: :created, include: :tutors)
    else
      render_error(course)
    end
  end

  def index
    courses = Course.includes(:tutors)
    if params[:search].present?
      courses = courses.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    end
    paginated = courses.page(params[:page]).per(params[:per_page] || PER_PAGE_DEFAULT)

    versioned_key = "v1/courses_with_tutors/#{courses_cache_key(paginated)}"
    cached_courses = Rails.cache.fetch(versioned_key, expires_in: LONG_CACHE_TIME) do
      paginated.as_json(include: [ :tutors ])
    end

    render json: {
      data: cached_courses,
      meta: {
        current_page: paginated.current_page,
        total_pages: paginated.total_pages,
        total_count: paginated.total_count
      }
    }
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      :description,
      tutors_attributes: [ :name, :email ]
    )
  end

  def courses_cache_key(courses)
    key_base = courses.map(&:cache_key_with_version).join("/")
    Digest::MD5.hexdigest("#{key_base}/page#{courses.current_page}/per#{courses.limit_value}")
  end
end
