require "test_helper"

class SourceTest < ActiveSupport::TestCase
  test "sources require a name" do
    source = sources(:manual)
    source.name = nil
    assert_not source.valid?
  end

  test "source names are unique" do
    source = Source.new(name: "Manual")
    assert_not source.valid?
  end
end
