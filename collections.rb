require './etl'

source = 'https://data.seattle.gov/resource/dk8m-pdjf?'+
           '$limit=100&'+
           '$order=date_case_created+DESC&'+
           '$where=longitude+IS+NOT+NULL+AND+'+
             'latitude+IS+NOT+NULL'
ETL.register('/seattle-code-violation-cases', source) do |collection|
  features = collection.map do |item|
    title = "[#{item['case_type']} - #{item['case_group']}] #{item['status']} @ #{item['address']}"
    {
      'id' => item['case_number'],
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['longitude'].to_f,
          item['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title)
    }
  end

  {'type' => 'FeatureCollection', 'features' => features}
end

source = 'https://data.seattle.gov/resource/mags-97de?'+
           '$limit=100&'+
           '$order=application_date+DESC&'+
           '$where=longitude+IS+NOT+NULL+AND+'+
             'latitude+IS+NOT+NULL+AND+'+
             'application_permit_number+IS+NOT+NULL'
ETL.register('/seattle-building-permits', source) do |collection|
  features = collection.map do |item|
    title = "[#{item['permit_type']} - #{item['category']}] #{item['status']} @ #{item['address']}"
    {
      'id' => item['application_permit_number'],
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['longitude'].to_f,
          item['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title)
    }
  end

  {'type' => 'FeatureCollection', 'features' => features}
end

source = 'https://data.seattle.gov/resource/kzjm-xkqj?'+
           '$limit=100&'+
           '$order=datetime+DESC&'+
           '$where=longitude+IS+NOT+NULL+AND+'+
             'latitude+IS+NOT+NULL+AND+'+
             'incident_number+IS+NOT+NULL+AND+'+
             'datetime+IS+NOT+NULL'
ETL.register('/seattle-911-fire-calls', source) do |collection|
  features = collection.map do |item|
    title = "[911 Fire Call] #{item['type']} @ #{item['address']}"
    {
      'id' => item['incident_number'],
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['longitude'].to_f,
          item['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title, 'datetime' => Time.at(item['datetime']).iso8601)
    }
  end

  {'type' => 'FeatureCollection', 'features' => features}
end

source = 'http://data.cityofnewyork.us/resource/jrsc-cabt?'+
           '$limit=100&$order=created_date+DESC&'+
           '$where=longitude+IS+NOT+NULL+AND+'+
             'incident_address+IS+NOT+NULL+AND+'+
             'descriptor+IS+NOT+NULL'
ETL.register('/nyc-311-restaurant-data', source) do |collection|
  features = collection.map do |item|
    title = "[#{item['incident_address']}] #{item['descriptor']}"
    {
      'id' => item['unique_key'],
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

source = 'https://data.cityofchicago.org/resource/r5kz-chrr?'+
           '$limit=100&'+
           '$order=date_issued+DESC&'+
           '$where=longitude+IS+NOT+NULL'
ETL.register('/chi-new-biz-licenses', source) do |collection|
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

source = 'https://data.sfgov.org/resource/vw6y-z8j6?'+
           '$limit=100&'+
           '$order=opened+DESC&'+
           '$where=opened+IS+NOT+NULL'
ETL.register('/sf-311-cases', source) do |collection|
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
