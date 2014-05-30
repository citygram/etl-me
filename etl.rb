require 'active_support/cache'
require 'faraday'
require 'faraday_middleware'

class ETL
  @cache = ActiveSupport::Cache::MemoryStore.new(expires_in: Integer(ENV['CACHE_TTL'] || 300))
  @parser = ->(data) { JSON.parse(data) }
  @generator = ->(data){ JSON.pretty_generate(data) }
  @collections = []

  class << self
    attr_reader :cache, :generator, :parser, :collections
  end

  def self.register(path, *args, &block)
    collections << new(path, *args, &block)
  end

  attr_reader :path, :raw_path

  def initialize(path, source, &transform)
    @path = path
    @raw_path = @path+'/raw'
    @source = source
    @transform = transform
    @connection = Faraday.new(url: @source) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.headers['X-App-Token'] = ENV.fetch('APP_TOKEN')
      conn.adapter Faraday.default_adapter
    end
  end

  def raw
    ETL.cache.fetch(@source) do
      ETL.parser.(@connection.get.body)
    end
  end

  def cooked
    ETL.cache.fetch(@path) do
      ETL.generator.(@transform.(raw))
    end
  end
end
