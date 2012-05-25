require "nested_hash/version"

class NestedHash < Hash

  def initialize(hash = {})
    hash.each do |key,value|
      set(key,value)
    end
    post_process
  end

  def set(key,value)
    key = sanitize_long_key(key)

    if is_valid_key?(key)
      look_for(key,value)
    elsif copy_invalid_keys?
      copy(key,value)
    end
  end

  def compact_arrays!(element = self)
    element.each do |item|
      item.compact! if item.is_a?(Array)
      compact_arrays!(item) if item.is_a?(Array) || item.is_a?(Hash)
    end
  end

  def delete(key)
    look_for(key,nil, :delete)
  end


  def look_for(key,value, op  = :set)
    keys = key.split(".").map{|k| sanitize_key(k)}

    previous = keys.shift
    top = (keys.inject(self) do |memo,key|
      memo[previous] ||= ( is_for_array?(key) ? [] : {} )
      memo = memo[previous]
      previous = key
      memo
    end)

    case op
    when :set
      top[previous] = value
    when :get
      top[previous]
    when :delete
      top.delete(previous)
    end
  rescue => e
    handle_exception(e, key, value)
  end

  def get(key)
    look_for(key,nil, :get)
  end

  protected

  def post_process
    compact_arrays!
  end


  def copy_invalid_keys?
    true
  end

  def sanitize_long_key(key)
    key
  end

  def sanitize_key(key)
    ( key =~ /^\d+$/ ) ? key.to_i : key
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
    key.is_a?(Numeric)
  end


end
