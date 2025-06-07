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
      @course1 = create(:course, name: "Physics 101")
      create(:tutor, name: "Alice", email: "alice@example.com", course: @course1)
      create(:tutor, name: "Bob", email: "bob@example.com", course: @course1)

      @course2 = create(:course, name: "Math 101")
      @course3 = create(:course, name: "History 101")
    end

    context "without params" do
      it "returns first page of courses with tutors" do
        get :index

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"].length).to eq(3) # default per_page = 10, so all 3 returned
        expect(json["meta"]["total_count"]).to eq(3)
      end
    end

    context "with pagination params" do
      it "returns paginated courses with tutors" do
        get :index, params: { page: 1, per_page: 2 }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"].length).to eq(2)
        expect(json["meta"]["current_page"]).to eq(1)
        expect(json["meta"]["total_pages"]).to eq(2)
        expect(json["meta"]["total_count"]).to eq(3)
      end
    end

    context "with search param" do
      it "filters courses by name" do
        get :index, params: { search: "Phys" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"].length).to eq(1)
        expect(json["data"].first["name"]).to eq("Physics 101")
      end

      it "returns empty when no matches found" do
        get :index, params: { search: "Biology" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"]).to eq([])
        expect(json["meta"]["total_count"]).to eq(0)
      end
    end
  end
end
