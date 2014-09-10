class LRUCache

  def initialize(capacity)
    @capacity = capacity
    @history = History.new
    @container = {}
  end

  def []=(key, value)
    @container[@history.record(key)] = value
    shape_container(@history.keys(@capacity))
  end

  def [](key)
    @container[@history.record(key)]
  end

  def resize(new_capacity)
    if new_capacity < @capacity
      shape_container(@history.keys(new_capacity))
    end
    @capacity = new_capacity
  end

  def to_hash
    @container
  end

private

  def shape_container(keys)
    (@container.keys - keys).each {|k| @container.delete(k) }
  end

  class History

    def initialize
      @keys = []
    end

    def record(key)
      @keys.tap {|x| x.delete(key) } << key
      key
    end

    def keys(capacity)
      @keys.tap {|x| x.slice!(0, x.size - capacity) }
    end
  end
end
