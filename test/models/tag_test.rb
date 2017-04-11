require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "tags require a name" do
    tag = tags(:foo)
    tag.name = nil
    assert !tag.valid?
  end
end
