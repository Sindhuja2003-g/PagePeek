require 'rails_helper'

RSpec.describe "API::V1::Books", type: :request do
  let(:user)        { create(:user) }
  let(:moderator)   { create(:user, role: "moderator") }
  let(:user_token)  { create(:access_token, resource_owner_id: user.id) }
  let(:mod_token)   { create(:access_token, resource_owner_id: moderator.id) }

  let(:invalid_headers) { { Authorization: "Bearer invalid.token" } }
  let(:user_headers) { { Authorization: "Bearer #{user_token.token}" } }
  let(:mod_headers)  { { Authorization: "Bearer #{mod_token.token}" } }
  let(:json_response) { JSON.parse(response.body) }

  describe "GET /api/v1/books" do
    before { create_list(:book, 3) }

    context "when using user bearer token" do
      subject(:api_response) { get "/api/v1/books", headers: user_headers }

      it "returns status ok" do
        api_response
        expect(response).to have_http_status(:ok)
      end

      it "returns all books" do
        api_response
        expect(json_response.size).to eq(3)
      end
    end

    context "when using moderator bearer token" do
      subject(:api_response) { get "/api/v1/books", headers: mod_headers }

      it "returns status ok" do
        api_response
        expect(response).to have_http_status(:ok)
      end

      it "returns all books" do
        api_response
        expect(json_response.size).to eq(3)
      end
    end

    context "when no token is provided" do
      subject(:api_response) { get "/api/v1/books" }

      it "returns unauthorized status" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when token is invalid" do
      subject(:api_response) { get "/api/v1/books", headers: invalid_headers }

      it "returns unauthorized status" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end




  describe "GET /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context "as moderator" do
      subject(:api_response) { get "/api/v1/books/#{book.id}", headers: mod_headers }

      it "returns status ok" do
        api_response
        expect(response).to have_http_status(:ok)
      end
    end

    context "as regular user" do
      subject(:api_response) { get "/api/v1/books/#{book.id}", headers: user_headers }

      it "returns status ok" do
        api_response
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid token" do
      subject(:api_response) { get "/api/v1/books/#{book.id}", headers: invalid_headers }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "without token" do
      subject(:api_response) { get "/api/v1/books/#{book.id}" }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when book does not exist" do
      subject(:api_response) { get "/api/v1/books/99999", headers: mod_headers }

      it "returns not found" do
        api_response
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
        description: "A test book",
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

  context "as moderator" do
    subject(:api_response) { post "/api/v1/books", params: params, headers: mod_headers }

    context "with valid data" do
      let(:params) { valid_params }

      it "creates the book", :aggregate_failures do
        api_response
        expect(response).to have_http_status(:created)
        expect(json_response["title"]).to eq("Test Book")
      end
    end

    context "with invalid data" do
      let(:params) { invalid_params }

      it "returns unprocessable entity with errors", :aggregate_failures do
        api_response
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to be_present
      end
    end
  end

  context "as user" do
    subject(:api_response) { post "/api/v1/books", params: valid_params, headers: user_headers }

    it "returns forbidden" do
      api_response
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "with invalid token" do
    subject(:api_response) { post "/api/v1/books", params: valid_params, headers: invalid_headers }

    it "returns unauthorized" do
      api_response
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "without token" do
    subject(:api_response) { post "/api/v1/books", params: valid_params }

    it "returns unauthorized" do
      api_response
      expect(response).to have_http_status(:unauthorized)
    end
  end
end



describe "PATCH /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context "as moderator" do
      context "with valid data" do
        let(:params) { { book: { title: "Updated" } } }
        subject(:api_response) { patch "/api/v1/books/#{book.id}", params: params, headers: mod_headers }

        it "updates the book", :aggregate_failures do
          api_response
          expect(response).to have_http_status(:ok)
          expect(json_response["title"]).to eq("Updated")
        end
      end

      context "with invalid data" do
        let(:params) { { book: { title: "" } } }
        subject(:api_response) { patch "/api/v1/books/#{book.id}", params: params, headers: mod_headers }

        it "returns unprocessable entity with errors", :aggregate_failures do
          api_response
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"]).to be_present
        end
      end
    end

    context "as user" do
      let(:params) { { book: { title: "User Update Attempt" } } }
      subject(:api_response) { patch "/api/v1/books/#{book.id}", params: params, headers: user_headers }

      it "returns forbidden" do
        api_response
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "with invalid token" do
      let(:params) { { book: { title: "Invalid Token" } } }
      subject(:api_response) { patch "/api/v1/books/#{book.id}", params: params, headers: invalid_headers }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "without token" do
      let(:params) { { book: { title: "No Token" } } }
      subject(:api_response) { patch "/api/v1/books/#{book.id}", params: params }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

  context "when the book does not exist" do
    let(:non_existent_id) { 999999 }
    let(:params) { { book: { title: "Update Attempt" } } }

    subject(:api_response) { patch "/api/v1/books/#{non_existent_id}", params: params, headers: mod_headers }

    it "returns not found" do
      api_response
      expect(response).to have_http_status(:not_found)
    end
  end
end


  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

     context "as moderator" do
        subject(:api_response) { delete "/api/v1/books/#{book.id}", headers: mod_headers }

        it "deletes the book", :aggregate_failures do
          api_response
          expect(response).to have_http_status(:no_content)
          expect(Book.exists?(book.id)).to be_falsey
        end
      end

      context "as user" do
        subject(:api_response) { delete "/api/v1/books/#{book.id}", headers: user_headers }

        it "returns forbidden" do
          api_response
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with invalid token" do
        subject(:api_response) { delete "/api/v1/books/#{book.id}", headers: invalid_headers }

        it "returns unauthorized" do
          api_response
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "without token" do
        subject(:api_response) { delete "/api/v1/books/#{book.id}" }

        it "returns unauthorized" do
          api_response
          expect(response).to have_http_status(:unauthorized)
        end
      end
    context "when the book does not exist" do
       let(:non_existent_id) { 999999 }
       let(:params) { { book: { title: "Update Attempt" } } }

        subject(:api_response) { delete "/api/v1/books/#{non_existent_id}", params: params, headers: mod_headers }

        it "returns not found" do
           api_response
           expect(response).to have_http_status(:not_found)
    end
  end
end


    describe "GET /api/v1/books/most_viewed" do
      before do
        create_list(:book, 5, view_count: 5)
      create(:book, view_count: 0)
    end

    context "as moderator" do
      subject(:api_response) { get "/api/v1/books/most_viewed", headers: mod_headers }

      it "returns top viewed books" , :aggregate_failures do
        api_response
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(5)
      end
    end

    context "as user" do
      subject(:api_response) { get "/api/v1/books/most_viewed", headers: user_headers }

       it "returns top viewed books", :aggregate_failures do
          api_response
          expect(response).to have_http_status(:ok)
          expect(json_response.size).to eq(5)
       end
    end

    context "with invalid token" do
      subject(:api_response) { get "/api/v1/books/most_viewed", headers: invalid_headers }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "without token" do
      subject(:api_response) { get "/api/v1/books/most_viewed" }

      it "returns unauthorized" do
        api_response
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
