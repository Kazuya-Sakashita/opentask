RSpec.shared_examples "unauthorized response" do
  it "401エラーを返す" do
    expect(response).to have_http_status(:unauthorized)

    assert_response_schema_confirm(401)

    body = response.parsed_body

    expect(body["title"]).to eq("Unauthorized")
    expect(body["reason"]).to eq("unauthorized")
    expect(body["status"]).to eq(401)
  end
end

RSpec.shared_examples "forbidden response" do
  it "403エラーを返す" do
    expect(response).to have_http_status(:forbidden)

    assert_response_schema_confirm(403)

    body = response.parsed_body

    expect(body["title"]).to eq("Forbidden")
    expect(body["reason"]).to eq("forbidden")
    expect(body["status"]).to eq(403)
  end
end

RSpec.shared_examples "not found response" do
  it "404エラーを返す" do
    expect(response).to have_http_status(:not_found)

    assert_response_schema_confirm(404)

    body = response.parsed_body

    expect(body["title"]).to eq("Not Found")
    expect(body["reason"]).to eq("not_found")
    expect(body["status"]).to eq(404)
  end
end

RSpec.shared_examples "validation error response" do
  it "422エラーを返す" do
    expect(response).to have_http_status(:unprocessable_content)

    assert_response_schema_confirm(422)

    body = response.parsed_body

    expect(body["title"]).to eq("Validation Error")
    expect(body["reason"]).to eq("validation_error")
    expect(body["status"]).to eq(422)
    expect(body["errors"]).to have_key("title")
  end
end
