# frozen_string_literal: true

module RenderHelper
  extend ActiveSupport::Concern

  included do
    def render_resourses(resources, status: :ok, include: nil)
      render json: resources.as_json(include: include), status: status
    end

    def render_error(resource, status: :unprocessable_entity)
      render json: { errors: resource.errors.full_messages }, status: status
    end
  end
end
