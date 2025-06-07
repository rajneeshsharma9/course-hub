require 'rails_helper'

RSpec.describe "Courses API", type: :request do
  describe "POST /courses" do
    let(:valid_attributes) do
      {
        course: {
          name: "Physics 101",
          description: "Intro to physics",
          tutors_attributes: [
            { name: "Alice", email: "alice@example.com" },
            { name: "Bob", email: "bob@example.com" }
          ]
        }
      }
    end

    let(:invalid_attributes) do
      {
        course: {
          name: "",   # invalid since blank name
          tutors_attributes: [
            { name: "", email: "invalid-email" } # invalid tutor
          ]
        }
      }
    end

    context "with valid parameters" do
      it "creates a new course with tutors" do
        expect {
          post "/courses", params: valid_attributes
        }.to change(Course, :count).by(1)
          .and change(Tutor, :count).by(2)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Physics 101")
        expect(json["tutors"].size).to eq(2)
        expect(json["tutors"].map { |t| t["name"] }).to include("Alice", "Bob")
      end
    end

    context "with invalid parameters" do
      it "does not create a course and returns errors" do
        expect {
          post "/courses", params: invalid_attributes
        }.to_not change(Course, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end
  end
end
