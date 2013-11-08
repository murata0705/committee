require_relative "test_helper"

describe Rack::Committee::Lint do
  include Rack::Test::Methods

  def app
    @app
  end

  it "detects an invalid response" do
    @app = new_rack_app("")
    get "/apps"
    assert_equal 500, last_response.status
    assert_match /valid JSON/i, last_response.body
  end

  it "detects missing keys in response" do
    data = valid_app
    data.delete("name")
    @app = new_rack_app(MultiJson.encode(data))
    get "/apps"
    assert_equal 500, last_response.status
    assert_match /missing keys/i, last_response.body
  end

  it "detects extra keys in response" do
    data = valid_app
    data.merge!("tier" => "important")
    @app = new_rack_app(MultiJson.encode(data))
    get "/apps"
    assert_equal 500, last_response.status
    assert_match /extra keys/i, last_response.body
  end

  def new_rack_app(response)
    Rack::Builder.new {
      use Rack::Committee::Lint, schema: File.read("./test/data/schema.json")
      run lambda { |_|
        [200, {}, [response]]
      }
    }
  end

  def valid_app
    {
      "archived_at"                    => "",
      "buildpack_provided_description" => "",
      "created_at"                     => "",
      "id"                             => "",
      "git_url"                        => "",
      "maintenance"                    => "",
      "name"                           => "",
      "owner"                          => {
        "email"                        => "",
        "id"                           => "",
      },
      "region"                         => {
        "id"                           => "",
        "name"                         => "",
      },
      "released_at"                    => "",
      "repo_size"                      => "",
      "slug_size"                      => "",
      "stack"                          => {
        "id"                           => "",
        "name"                         => "",
      },
      "updated_at"                     => "",
      "web_url"                        => "",
    }
  end
end