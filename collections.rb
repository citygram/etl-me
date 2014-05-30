require './etl'

ETL.register('/chi-new-biz-licenses', 'https://data.cityofchicago.org/resource/r5kz-chrr?$limit=100&$order=date_issued+DESC&$where=longitude+IS+NOT+NULL') do |collection|
  features = collection.map do |item|
    title = "[#{item['license_description']}] #{item['legal_name']}"
    {
      'id' => item['id'],
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['location']['longitude'].to_f,
          item['location']['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title)
    }
  end

  {'type' => 'FeatureCollection', 'features' => features}
end

ETL.register('/sf-311-cases', 'https://data.sfgov.org/resource/vw6y-z8j6?$limit=100&$order=opened+DESC&$where=opened+IS+NOT+NULL') do |collection|
  features = collection.map do |item|
    title = "[#{item['request_type']}] #{item['request_details']}"
    {
      'id' => item['case_id'],
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['point']['longitude'].to_f,
          item['point']['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title)
    }
  end

  {'type' => 'FeatureCollection', 'features' => features}
end
