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

  def test_hash_in_array
    initial = { "game.1.name" => 'Guillermo',
      "game.1.lives" => 3,
      "game.2.lives" => 5 }
    hash = NestedHash.new(initial)
    assert_equal( {"name" => "Guillermo", "lives" => 3} , hash["game"][0], 'should merge elements')
    assert_equal( {"lives" => 5}, hash["game"][1])
  end
end
