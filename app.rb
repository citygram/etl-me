require 'dotenv'
Dotenv.load

require 'json'
require 'sinatra'
require './collections'

ETL.collections.each do |collection|
  get(collection.path) do
    content_type :json
    collection.cooked
  end

  get(collection.raw_path) do
    content_type :json
    ETL.generator.(collection.raw)
  end
end

get '/' do
  @collections = ETL.collections
  erb :index
end
