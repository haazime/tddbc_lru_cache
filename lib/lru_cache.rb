class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @stored_key_order = []
  end

  def []=(key, value)
    @container[key] = value
    @stored_key_order << key
    if @stored_key_order.size > @capacity
      @container.delete(@stored_key_order.shift)
    end
  end

  def [](key)
    @stored_key_order.delete(key)
    @stored_key_order << key
    @container[key]
  end
end
