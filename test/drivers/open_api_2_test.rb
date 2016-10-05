require_relative "../test_helper"

describe Committee::Drivers::OpenAPI2 do
  before do
    @driver = Committee::Drivers::OpenAPI2.new
  end

  it "builds a routing table" do
  end

  it "parses an OpenAPI 2 spec" do
    spec = @driver.parse(open_api_2_data)
    assert_kind_of Committee::Drivers::OpenAPI2::Spec, spec
    assert_kind_of JsonSchema::Schema, spec.definitions
  end

  it "refuses to parse other version of OpenAPI" do
    data = open_api_2_data
    data['swagger'] = '3.0'
    e = assert_raises(ArgumentError) do
      @driver.parse(data)
    end
    assert_equal "Committee: driver requires OpenAPI 2.0.", e.message
  end

  it "refuses to parse a spec without mandatory fields" do
    data = open_api_2_data
    data['definitions'] = nil
    e = assert_raises(ArgumentError) do
      @driver.parse(data)
    end
    assert_equal "Committee: no definitions section in spec data.", e.message
  end
end

describe Committee::Drivers::OpenAPI2::Link do
  before do
    @link = Committee::Drivers::OpenAPI2::Link.new
    @link.enc_type = "application/x-www-form-urlencoded"
    @link.href = "/apps"
    @link.media_type = "application/json"
    @link.method = "GET"
    @link.status_success = 200
    @link.schema = { "title": "input" }
    @link.target_schema = { "title": "target" }
  end

  it "uses set #enc_type" do
    assert_equal "application/x-www-form-urlencoded", @link.enc_type
  end

  it "uses set #href" do
    assert_equal "/apps", @link.href
  end

  it "uses set #media_type" do
    assert_equal "application/json", @link.media_type
  end

  it "uses set #method" do
    assert_equal "GET", @link.method
  end

  it "proxies #rel" do
    e = assert_raises do
      @link.rel
    end
    assert_equal "Committee: rel not implemented for OpenAPI", e.message
  end

  it "uses set #schema" do
    assert_equal({ "title": "input" }, @link.schema)
  end

  it "uses set #status_success" do
    assert_equal 200, @link.status_success
  end

  it "uses set #target_schema" do
    assert_equal({ "title": "target" }, @link.target_schema)
  end
end