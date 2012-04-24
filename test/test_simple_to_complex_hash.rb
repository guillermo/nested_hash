require 'nested_hash'
require 'test/unit'

class NestedHashTest < Test::Unit::TestCase

  def test_class
    nested_hash = NestedHash.new
    nested_hash.is_a?(Hash)
  end

  def test_true
    assert true
  end

  def test_subitem_conversion
    initial = { "properties.age" => 3 }
    final = { "properties" => { "age" => 3 }}
    hash = NestedHash.new(initial)
    assert_equal 1, hash.keys.size
    assert_equal ['properties'], hash.keys
    assert_equal ['age'], hash['properties'].keys
    assert_equal 3, hash['properties']['age']
  end

  def test_array_subitem
    initial = { 'child.1' => 'pepe', "child.2" => 'juan'}
    final = { 'child' => [ 'pepe', 'juan']}
    hash = NestedHash.new(initial)

    assert_equal 1, hash.keys.size
    assert_equal ['child'], hash.keys
    assert_equal ['pepe','juan'], hash["child"]
  end
end
