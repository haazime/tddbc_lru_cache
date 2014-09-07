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
    @delete_key_order.tap {|x| x.delete(key) } << key
    @container[key]
  end

  def resize(new_capacity)
    return if @capacity <= new_capacity
    @delete_key_order.take(@capacity - new_capacity).each do |key|
      @container.delete(key)
    end
  end

  def to_hash
    @container
  end
end
