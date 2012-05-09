require "nested_hash/version"

class NestedHash < Hash

  def initialize(hash = {})
    hash.each do |key,v|
      key = sanitize_key(key)

      if is_valid_key?(key)
        process(key,v)
      elsif copy_invalid_keys?
        copy(key,v)
      end
    end
    post_process
  end

  protected

  def post_process
    compact_arrays
  end

  def compact_arrays(element = self)
    element.each do |item|
      item.compact! if item.is_a?(Array)
      compact_arrays(item) if item.is_a?(Array) || item.is_a?(Hash)
    end
  end

  def copy_invalid_keys?
    true
  end

  def sanitize_key(key)
    key
  end

  def is_valid_key?(key)
    key.is_a?(String) && key =~ /\A[\.\w]+\z/
  end

  def copy(key,value)
    self[key] = value
  end

  def process(key,value)
    if key =~ /\./
      process_nested(key,value)
    else
      self[key] = value
    end
  end


  def sanitize_value(v)
    v
  end

  def process_nested(key, value)
    keys = key.split(".")
    previous = keys.shift
    top = keys.inject(self) do |memo,key|
      if is_for_array?(key)
        memo[previous] ||= []
        key = key.to_i
      else
        memo[previous] ||= {}
      end
      a = memo[previous]
      previous = key
      a
    end

    if top.is_a?(Array)
      top << value
    else
      top[previous] = value
    end
  end

  def is_for_array?(key)
    key =~ /\A\d+\z/
  end


end
