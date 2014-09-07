class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @container = {}
    @delete_key_order = []
  end

  def []=(key, value)
    @container[key] = value
    @delete_key_order << key
    shape_container(@capacity)
  end

  def [](key)
    @delete_key_order.tap {|x| x.delete(key) } << key
    @container[key]
  end

  def resize(new_capacity)
    shape_container(new_capacity)
  end

  def to_hash
    @container
  end

private

  def shape_container(capacity)
    return if @container.size <= capacity
    @delete_key_order.take(@container.size - capacity).each do |key|
      @container.delete(key)
    end
  end
end
