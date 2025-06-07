# frozen_string_literal: true

Rails.application.routes.draw do
  resources :courses, only: [ :create, :index ]
end
