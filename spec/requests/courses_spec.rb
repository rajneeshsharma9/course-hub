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

  describe "GET /courses" do
    before do
      @course1 = create(:course, name: "Physics 101")
      create(:tutor, name: "Alice", email: "alice@example.com", course: @course1)
      create(:tutor, name: "Bob", email: "bob@example.com", course: @course1)

      @course2 = create(:course, name: "Math 101")
      @course3 = create(:course, name: "History 101")
    end

    it "returns paginated courses with their tutors" do
      get "/courses", params: { page: 1, per_page: 2 }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(2)

      physics_course = json["data"].find { |c| c["name"] == "Physics 101" }
      expect(physics_course["tutors"].size).to eq(2)

      math_course = json["data"].find { |c| c["name"] == "Math 101" }
      expect(math_course).to be_present

      expect(json["meta"]).to include(
        "current_page" => 1,
        "total_pages" => 2,
        "total_count" => 3
      )
    end

    it "filters courses by search param" do
      get "/courses", params: { search: "Phys" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(1)
      expect(json["data"].first["name"]).to eq("Physics 101")
    end

    it "returns empty data when no matches for search" do
      get "/courses", params: { search: "Biology" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["data"]).to eq([])
      expect(json["meta"]["total_count"]).to eq(0)
    end
  end
end
