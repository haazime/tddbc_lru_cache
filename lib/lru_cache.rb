class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @contained_keys = []
  end

  def []=(key, value)
    @container[key] = value
    @contained_keys << key
    @contained_keys.shift if @capacity < @contained_keys.size
    shape_container
  end

  def [](key)
    @contained_keys.tap {|x| x.delete(key) } << key
    @container[key]
  end

  def resize(new_capacity)
    delta = @capacity - new_capacity
    @capacity = new_capacity
    return if delta < 0
    @contained_keys.slice!(0, delta)
    shape_container
  end

  def to_hash
    @container
  end

private

  def shape_container
    (@container.keys - @contained_keys).each do |key|
      @container.delete(key)
    end
  end
end
