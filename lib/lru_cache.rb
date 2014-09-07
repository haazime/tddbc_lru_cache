class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @delete_key_order = []
  end

  def []=(key, value)
    @container[key] = value
    @delete_key_order << key
    if @delete_key_order.size > @capacity
      @container.delete(@delete_key_order.shift)
    end
  end

  def [](key)
    @delete_key_order.delete(key)
    @delete_key_order << key
    @container[key]
  end

  def to_hash
    @container
  end
end
