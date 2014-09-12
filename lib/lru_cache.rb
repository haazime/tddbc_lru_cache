class LRUCache

  def initialize(capacity, options={})
    @capacity = capacity
    @history = History.new
    @container = {}
    @timeout = options[:timeout]
  end

  def put(key, value)
    @container[@history.record(key)] = value
    shape_container(@history.keys(@capacity))
  end

  def get(key)
    if @timeout
      @history.timeout(Time.now - @timeout)
      shape_container(@history.keys(@capacity))
    end
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
    class Line < Struct.new(:key, :created_at)

      def initialize(key)
        super(key, Time.now)
      end

      def expired?(expire_at)
        self.created_at <= expire_at
      end
    end

    def initialize
      @lines = []
    end

    def record(key)
      line = Line.new(key)
      @lines.tap {|x| x.delete(line) } << line
      line.key
    end

    def keys(capacity)
      @lines.slice!(0, @lines.size - capacity)
      @lines.map {|l| l.key }
    end

    def timeout(expire_at)
      @lines.reject! {|l| l.expired?(expire_at) }
    end
  end
end
