# TODO
- Process 2023 Federal Electoral Districts
- For `load.sh`
  - Finish processing 2001 data

- For `country.sql`
  - Create `country_2001` from 2001 geometries. Need to finish `load.sh`
  - Add English abbreviation for all years
  - Add French abbreviation for all years

- For `geographic_regions_of_canada.sql`
  - Add other years (2016, 2011, 2006, 2001) 
  - Add GRC abbreviation english
  - Add GRC abbreviation french
  - According to this, Territories DGUID should be `2021A00016` https://www150.statcan.gc.ca/n1/en/geo?geotext=Territories%20%5BRegion%5D&geocode=A00016
  - According to the link above, British Columbia DGUID should be `2021A00015`
 
- For `er_2021`, split `er_name` into English and French components. There's some records that are separated by `/`
  - South Coast--Burin Peninsula / Côte-sud--Burin Peninsula
  - West Coast--Northern Peninsula--Labrador / Côte-ouest--Northern Peninsula--Labrador
  - Prince Edward Island / Île-du-Prince-Édouard

- For `cma_2021`, split `cma_name` into English and French components. There's some records that are separated by `/`
  - Greater Sudbury / Grand Sudbury
  - Ottawa - Gatineau (Ontario part / partie de l'Ontario)
  
- For `ccs_2021`, split `ccs_name` into English and French components. There's some records that are separated by `/`
  - West Nipissing / Nipissing Ouest
  - French River / Rivière des Français
  - Greater Sudbury / Grand Sudbury
  - The Nation / La Nation
  
- For `csd_2021`, split `csd_name` into English and French components. There's some records that are separated by `/`
   - The Nation / La Nation
   - West Nipissing / Nipissing Ouest
   - Greater Sudbury / Grand Sudbury
   - Beaubassin East / Beaubassin-est
   
- For `csd_2021`, figure out what level of geography the sac_code and sac_type belongs to so I can name it appropriately

- For `pop_ctr_2021`, split `pop_ctr_name` into English and French components. There's one record that is separated by `/`
    - Grand Falls / Grand-Sault
    
- For `dpl_2021`, split `dpl_name` into English and French components. There's records that are separated by `/`
    - Saint Irénée and Alderwood / Saint Irénée et Alderwood
    - `Sainte-Anne-de-Kent part B / partie B` - this one would need to be split into `Sainte-Anne-de-Kent part B` and  `Sainte-Anne-de-Kentpartie partie B`
