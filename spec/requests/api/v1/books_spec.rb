require 'rails_helper'

RSpec.describe "API::V1::Books", type: :request do
  let(:user)      { create(:user) }
  let(:moderator) { create(:user, role: "moderator") }

  let(:user_token) { create(:access_token, resource_owner_id: user.id) }
  let(:mod_token)  { create(:access_token, resource_owner_id: moderator.id) }

  let(:user_headers) { { Authorization: "Bearer #{user_token.token}" } }
  let(:mod_headers)  { { Authorization: "Bearer #{mod_token.token}" } }

  def json_response
    JSON.parse(response.body)
  end

  describe "GET /api/v1/books" do
    before { create_list(:book, 3) }

    it "returns all books" do
      get "/api/v1/books", headers: user_headers

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
  end

  describe "GET /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "returns the book details" do
      get "/api/v1/books/#{book.id}", headers: user_headers

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(book.id)
    end

    it "returns 404 if book not found" do
      get "/api/v1/books/99999", headers: user_headers

      expect(response).to have_http_status(:not_found)
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

    it "forbids regular user from creating a book" do
      post "/api/v1/books", params: valid_params, headers: user_headers

      expect(response).to have_http_status(:forbidden)
    end

    it "allows moderator to create a book" do
      post "/api/v1/books", params: valid_params, headers: mod_headers

      expect(response).to have_http_status(:created)
      expect(json_response["title"]).to eq("Test Book")
    end
  end

  describe "PATCH /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "forbids regular user from updating a book" do
      patch "/api/v1/books/#{book.id}", params: { book: { title: "New" } }, headers: user_headers

      expect(response).to have_http_status(:forbidden)
    end

    it "allows moderator to update a book" do
      patch "/api/v1/books/#{book.id}", params: { book: { title: "Updated Title" } }, headers: mod_headers

      expect(response).to have_http_status(:ok)
      expect(json_response["title"]).to eq("Updated Title")
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "forbids regular user from deleting a book" do
      delete "/api/v1/books/#{book.id}", headers: user_headers

      expect(response).to have_http_status(:forbidden)
    end

    it "allows moderator to delete a book" do
      delete "/api/v1/books/#{book.id}", headers: mod_headers

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /api/v1/books/most_viewed" do
    before do
      create_list(:book, 5, view_count: 5)
      create(:book, view_count: 0)
    end

    it "returns only books with view_count > 0" do
      get "/api/v1/books/most_viewed", headers: user_headers

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(5)
    end
  end
describe "POST /api/v1/books" do
  let(:invalid_params) do
    {
      book: {
        title: "",  
        author: "Test Author"
        # description and published missing
      }
    }
  end

  it "returns 422 if data is invalid" do
    post "/api/v1/books", params: invalid_params, headers: mod_headers

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response["errors"]).to be_present
  end
end


  describe "Unauthorized requests" do
  let(:book) { create(:book) }

  it "returns 401 if no token is provided" do
    get "/api/v1/books"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns 401 with invalid token" do
    get "/api/v1/books", headers: { Authorization: "Bearer invalidtoken" }
    expect(response).to have_http_status(:unauthorized)
  end
end

end
