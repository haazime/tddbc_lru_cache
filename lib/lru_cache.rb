class LRUCache

  def initialize(capacity)
    @history = History.new(capacity)
    @container = {}
  end

  def []=(key, value)
    @container[@history.record(key)] = value
    shape_container(@history.to_a)
  end

  def [](key)
    @container[@history.record(key)]
  end

  def resize(capacity)
    @history.resize(capacity)
    shape_container(@history.to_a)
  end

  def to_hash
    @container
  end

private

  def shape_container(keys)
    (@container.keys - keys).each {|k| @container.delete(k) }
  end

  class History

    def initialize(capacity)
      @capacity = capacity
      @keys = []
    end

    def record(key)
      @keys.tap {|x| x.delete(key) } << key
      resize(@capacity)
      key
    end

    def resize(new_capacity)
      @capacity = new_capacity
      return self unless (delta = @keys.size - new_capacity) > 0
      @keys.slice!(0, delta)
    end

    def to_a
      @keys
    end
  end
end
