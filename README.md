## ETL micro-service

### Setup

Register with [Socrata](https://opendata.socrata.com/profile) and create an application.

```console
git clone https://github.com/invisiblefunnel/etl-me.git
cd etl-me
bundle install
cp .env.sample .env 
# Add your APP_TOKEN from Socrata to .env
bundle exec rackup
```

### Deploy (Heroku)

```console
heroku create <app-name>
heroku config:set APP_TOKEN=yourtoken
heroku config:set CACHE_TTL=600 # seconds
git push heroku master
heroku open
```
