class LRUCache

  def initialize(capacity, options={})
    @capacity = capacity
    @history = History.new(options[:timeout])
    @container = {}
  end

  def []=(key, value)
    @container[@history.record(key)] = value
    shape_container(@history.keys(@capacity))
  end

  def [](key)
    return nil unless @container.has_key?(key)
    shape_container(@history.keys(@capacity))
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
    class Line < Struct.new(:key)

      def initialize(key)
        super(key)
        @created_at = Time.now
      end

      def expired?(expire_at)
        @created_at <= expire_at
      end
    end

    def initialize(timeout)
      @lines = []
      @timeout = timeout
    end

    def record(key)
      line = Line.new(key)
      @lines.tap {|x| x.delete(line) } << line
      line.key
    end

    def keys(capacity)
      @lines.slice!(0, @lines.size - capacity)
      timeout
      @lines.map {|l| l.key }
    end

  private

    def timeout
      return unless @timeout
      @lines.reject! {|l| l.expired?(Time.now - @timeout) }
    end
  end
end
