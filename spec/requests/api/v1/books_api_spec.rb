require 'rails_helper'

RSpec.describe "API::V1::Books", type: :request do
  subject(:json_response) { JSON.parse(response.body) }

  let(:user)       { create(:user) }
  let(:moderator)  { create(:user, role: "moderator") }

  let(:user_token) { create(:access_token, resource_owner_id: user.id) }
  let(:mod_token)  { create(:access_token, resource_owner_id: moderator.id) }

  let(:user_headers) { { Authorization: "Bearer #{user_token.token}" } }
  let(:mod_headers)  { { Authorization: "Bearer #{mod_token.token}" } }

 # describe "GET /api/v1/books" do
   # before do
     # create_list(:book, 3)
     # get "/api/v1/books", headers: user_headers
   # end

    it "returns status ok" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all books" do
      expect(json_response.size).to eq(3)
    end
  end

  describe "GET /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context "when book exists" do
      before { get "/api/v1/books/#{book.id}", headers: user_headers }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the book details" do
        expect(json_response["id"]).to eq(book.id)
      end
    end

    context "when book does not exist" do
      before { get "/api/v1/books/99999", headers: user_headers }

      it "returns status not found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/books" do
    let(:valid_params) do
      {
        book: {
          title: "Test Book",
          author: "Test Author",
          description: "Sample description",
          published: Date.today
        }
      }
    end

    let(:invalid_params) do
      {
        book: {
          title: "",
          author: "Test Author"
        }
      }
    end

    context "as regular user" do
      before { post "/api/v1/books", params: valid_params, headers: user_headers }

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as moderator" do
      context "with valid data" do
        before { post "/api/v1/books", params: valid_params, headers: mod_headers }

        it "returns created status" do
          expect(response).to have_http_status(:created)
        end

        it "creates the book with correct title" do
          expect(json_response["title"]).to eq("Test Book")
        end
      end

      context "with invalid data" do
        before { post "/api/v1/books", params: invalid_params, headers: mod_headers }

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns errors in response" do
          expect(json_response["errors"]).to be_present
        end
      end
    end
  end

  describe "PATCH /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context "as regular user" do
      before do
        patch "/api/v1/books/#{book.id}", params: { book: { title: "New" } }, headers: user_headers
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as moderator" do
      context "with valid data" do
        before do
          patch "/api/v1/books/#{book.id}", params: { book: { title: "Updated Title" } }, headers: mod_headers
        end

        it "returns ok status" do
          expect(response).to have_http_status(:ok)
        end

        it "updates the book title" do
          expect(json_response["title"]).to eq("Updated Title")
        end
      end

      context "with invalid data" do
        before do
          patch "/api/v1/books/#{book.id}", params: { book: { title: "" } }, headers: mod_headers
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns errors in the response" do
          expect(json_response["errors"]).to be_present
        end
      end
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context "as regular user" do
      before { delete "/api/v1/books/#{book.id}", headers: user_headers }

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as moderator" do
      before { delete "/api/v1/books/#{book.id}", headers: mod_headers }

      it "returns no content status" do
        expect(response).to have_http_status(:no_content)
      end

 
      after do
        expect(Book.exists?(book.id)).to be_falsey
      end
    end
  end

  describe "GET /api/v1/books/most_viewed" do
    before do
      create_list(:book, 5, view_count: 5)
      create(:book, view_count: 0)
      get "/api/v1/books/most_viewed", headers: user_headers
    end

    it "returns ok status" do
      expect(response).to have_http_status(:ok)
    end

    it "returns only books with view_count > 0" do
      expect(json_response.size).to eq(5)
    end
  end

  describe "Unauthorized requests" do
    let!(:book) { create(:book) }

    context "without token" do
      before { get "/api/v1/books" }

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      before { get "/api/v1/books", headers: { Authorization: "Bearer invalidtoken" } }

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
