# Security Force Monitor: CSV Proxy

    bundle
    mongo sfm --eval "db.dropDatabase()"
    bundle exec rake import
    bundle exec rake import novalidate=true
    bundle exec rake topojson input=shapefiles/NGA_adm/NGA_adm0.shp output=adm0/ng

Download shapefiles from [GADM](http://www.gadm.org/country).

## API

* [Country list and detail](/docs/countries.md)
* [Event map and detail](/docs/events.md)
* [Organization map, chart and detail](/docs/organizations.md)
* [Person chart and detail](/docs/people.md)
* [Search organizations, peopl and events](/docs/search.md)
* [Base layers and sessions](/docs/miscellaneous.md)

## Deployment

    heroku create
    heroku addons:create mongolab
    git push heroku master
    heroku run rake import novalidate=true

Copyright (c) 2015 Open North Inc., released under the MIT license
