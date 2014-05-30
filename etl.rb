require 'active_support/cache'
require 'faraday'
require 'faraday_middleware'

class ETL
  REGISTRY = {}

  CACHE = ActiveSupport::Cache::MemoryStore.new(
    expires_in: Integer(ENV['CACHE_TTL'] || 300)
  )

  def self.registry
    REGISTRY
  end

  def self.register(*args, &block)
    new(*args, &block)
  end

  def initialize(path, source, &transform)
    @path = path
    @source = source
    @transform = transform
    @cache = CACHE
    @connection = Faraday.new(url: @source) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.headers['X-App-Token'] = ENV.fetch('APP_TOKEN')
      conn.response :json
      conn.adapter Faraday.default_adapter
    end

    REGISTRY[@path] = self
  end

  def raw
    @cache.fetch(@source) do
      @connection.get.body
    end
  end

  def cooked
    @cache.fetch(@path) do
      @transform.call(raw)
    end
  end
end
