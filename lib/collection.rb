require 'jbundler'
require 'atomic'

# An in-memory collection of objects responding to :id and :id=, behaving like a simplified
# thread-safe Hash.

class Collection
  import com.google.common.cache.CacheBuilder

  def initialize
    @sequence = Enumerator.new do |yielder|
      number = Atomic.new(0)
      loop do
        number.update { |n| n + 1 }
        yielder.yield number
      end
    end

  end
end
