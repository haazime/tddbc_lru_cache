class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @contained_key_order = []
  end

  def []=(key, value)
    @container[key] = value
    @contained_key_order << key
    @contained_key_order.shift if @capacity < @container.size
    shape_container
  end

  def [](key)
    @contained_key_order.tap {|x| x.delete(key) } << key
    @container[key]
  end

  def resize(new_capacity)
    delta = @capacity - new_capacity
    @capacity = new_capacity
    return if delta < 0
    @contained_key_order.slice!(0, delta)
    shape_container
  end

  def to_hash
    @container
  end

private

  def shape_container
    (@container.keys - @contained_key_order).each do |key|
      @container.delete(key)
    end
  end
end
