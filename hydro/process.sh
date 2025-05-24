# Standardizes field names, builds up hierarchy for datasets, create Canada and Geographic Regions of Canada
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/country.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/geographic_regions_of_canada.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/provinces_and_territories.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_divisions.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/economic_regions.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_agricultural_regions.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/forward_sortation_areas.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/federal_electoral_districts.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_consolidated_subdivisions.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_metropolitan_areas.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_subdivisions.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/population_centres.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/designated_places.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/census_tracts.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/aggregate_dissemination_areas.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/dissemination_areas.sql
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -f boundaries/dissemination_blocks.sql