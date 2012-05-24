require "nested_hash/version"

class NestedHash < Hash

  def initialize(hash = {})
    hash.each do |key,v|
      key = sanitize_long_key(key)

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

  def sanitize_long_key(key)
    key
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
    value = sanitize_value(value)
    if key =~ /\./
      process_nested(key,value)
    else
      self[sanitize_key(key)] = value
    end
  end

  def sanitize_value(v)
    v
  end

  def process_nested(key, value)
    keys = key.split(".")
    previous = sanitize_key(keys.shift)
    top = keys.inject(self) do |memo,key|
      if is_for_array?(key)
        memo[previous] ||= []
        key = key.to_i
      else
        key = sanitize_key(key)
        memo[previous] ||= {}
      end
      a = memo[previous]
      previous = key
      a
    end

    top[previous] = value
  rescue => e
    handle_exception(e, key, value)
  end

  def handle_exception(e, key, value)
    log_exception(e, key, value) if log_exceptions?
    raise e unless continue_on_exceptions?
  end

  def log_exception(e, key, value)
    $stderr.puts "Problem procesing the pair \"#{key}\" => \"#{value}\""
  end

  def continue_on_exceptions?
    true
  end

  def log_exceptions?
    true
  end

  def is_for_array?(key)
    key =~ /\A\d+\z/
  end


end
