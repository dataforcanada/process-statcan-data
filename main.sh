#!/bin/bash
export SCRIPT_DIR=$(pwd)

psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -c 'CREATE SCHEMA IF NOT EXISTS bronze;'
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -c 'CREATE SCHEMA IF NOT EXISTS silver;'
psql "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@db/$POSTGRES_DB" -c 'CREATE SCHEMA IF NOT EXISTS gold;'

#### 1.0 Dissemination Geographies Relationship File ####
## 1.1 Download Dissemination Geographies Relationship File ##
dissemination_geographies_relationship_file/download.sh
## 1.2 Load Dissemination Geographies Relationship File to PostgreSQL ##
dissemination_geographies_relationship_file/load.sh
#### 2.0 Geographic Attribute File ####
## 2.1 Download Geographic Attribute File ##
geographic_attribute_file/download.sh
## 2.2 Load Geographic Attribute File to PostgreSQL ##
geographic_attribute_file/load.sh
#### 3.0 Hydro ####
## 3.1 Download Hydro ##
hydro/download.sh
## 3.2 Load Hydro ##
hydro/load.sh
#### 3.0 Boundaries ####
## 3.1 Download Boundaries ##
boundaries/download.sh
## 3.2 Load Boundaries ##
boundaries/load.sh
## 3.3 Process Boundaries ##
boundaries/process.sh
#### 4.0 Road Network Files ####
## 4.1 Download Road Network Files ##
road_network_files/download.sh
## 4.2 Load Road Network Files to PostgreSQL ##
road_network_files/load.sh
road_network_files/process.sh
#### 5.0 GeoSuite ####
## 5.1 Download GeoSuite Files ##
geosuite/download.sh
## 5.2 Load Placename layer to PostgreSQL ##
geosuite/load.sh
#### 6.0 Census of Population ####
## 6.1 Download Census of Population ##
census_of_population/download.sh
## 6.2 Process Census of Population ##
census_of_population/process.sh
#### 7.0 Census of Agriculture ####
## 7.1 Download Census of Population ##
census_of_agriculture/download.sh
## 7.2 Process Census of Agriculture ##
census_of_agriculture/process.sh
#### 8.0 National Address Register ####
## 8.1 Download National Address Register ##
national_address_register/download.sh
## 8.2 Load National Address Register ##
national_address_register/process.sh
