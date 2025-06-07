require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe "POST #create" do
    let(:valid_params) do
      {
        course: {
          name: "Chemistry 101",
          description: "Basics of Chemistry",
          tutors_attributes: [
            { name: "Dr. Smith", email: "smith@example.com" }
          ]
        }
      }
    end

    let(:invalid_params) do
      {
        course: {
          name: "", # invalid blank name
          tutors_attributes: [
            { name: "", email: "" }
          ]
        }
      }
    end

    context "with valid params" do
      it "creates a new course with tutors" do
        expect {
          post :create, params: valid_params
        }.to change(Course, :count).by(1)
          .and change(Tutor, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Chemistry 101")
        expect(json["tutors"].first["name"]).to eq("Dr. Smith")
      end
    end

    context "with invalid params" do
      it "does not create course and returns errors" do
        expect {
          post :create, params: invalid_params
        }.to_not change(Course, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end
  end

  describe "GET #index" do
    before do
      @course = create(:course, name: "Biology 101")
      create(:tutor, name: "Dr. Jane", email: "jane@example.com", course: @course)
    end

    it "returns all courses with tutors" do
      get :index

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first["name"]).to eq("Biology 101")
      expect(json.first["tutors"].first["name"]).to eq("Dr. Jane")
    end
  end
end
