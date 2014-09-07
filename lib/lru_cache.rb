class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @contained_key_order = []
  end

  def []=(key, value)
    @container[key] = value
    @contained_key_order << key
    if @capacity < @container.size
      shape_container(reduce_contained_keys(1))
    end
  end

  def [](key)
    @contained_key_order.tap {|x| x.delete(key) } << key
    @container[key]
  end

  def resize(new_capacity)
    delta = @capacity - new_capacity
    @capacity = new_capacity
    return if delta < 0
    shape_container(reduce_contained_keys(delta))
  end

  def to_hash
    @container
  end

private

  def reduce_contained_keys(num)
    @contained_key_order.slice!(0, num)
  end

  def shape_container(keep_keys)
    keep_keys.each {|key| @container.delete(key) }
  end
end
