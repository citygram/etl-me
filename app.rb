require 'dotenv'
Dotenv.load

require 'json'
require 'sinatra'
require './collections'

ETL.registry.each do |path, collection|
  get(path) do
    content_type :json
    collection.cooked
  end

  get(path+'/raw') do
    content_type :json
    ETL.generator.(collection.raw)
  end
end
