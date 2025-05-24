#!/bin/bash
if [ ! -d "${DATA_FOLDER}/health_regions" ]
then
    echo "Making directory ${DATA_FOLDER}/health_regions/"
    mkdir -p ${DATA_FOLDER/health_regions/{input,extracted,output}
fi

aria2c -x16 --out=hr2024001.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2024001/hrbf-flrs/digi/ArcGIS/HR_000a23a_e.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2023001.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2023001/hrbf-flrs/digi/ArcGIS/HR_000a22a_e.zip?st=P3vL0l_a" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2018001.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2018001/data-donnees/boundary-limites/arcinfo/HR_000a18a-eng.zip?st=NgmRAZb7" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2017001.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2017001/data-donnees/boundary-limites/arcinfo/HR_000a17a_e.zip?st=i4-a3s-U" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2015002.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2015002/data-donnees/boundary-limites/arcinfo/HRP000b11a_e.zip?st=pdmD3cVj" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2015001.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2015001/data-donnees/boundary-limites/arcinfo/HRP000b11a_e.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2013003.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2013003/data-donnees/boundary-limites/arcinfo/HRP000b11a_e.zip?st=yEQLGVii" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2013002.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2013002/data-donnees/boundary-limites/arcinfo/HRP000b11a_e.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2013001.zip "https://www150.statcan.gc.ca/pub/82-402-x/2011001/data-donnees/boundary-limites/arcinfo/hr000b06p-eng.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2011001.zip "https://www150.statcan.gc.ca/pub/82-402-x/2011001/data-donnees/boundary-limites/arcinfo/hr000b06p-eng.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2009001.zip "https://www150.statcan.gc.ca/pub/82-402-x/2009001/data-donnees/boundary-limites/arcinfo/hr000b08pz-eng.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2007001.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2007001/data/boundary/arcinfo/HR000b07PZ.zip?st=hCrYIpzu" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2006001.zip "https://www150.statcan.gc.ca/n1/en/pub/82-402-x/2006001/data/boundary/arcview/lhr000b05pz.zip?st=TEqojTk8" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2005001.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2005001/data/boundary/arcview/lhr000b05pz.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2004001.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2004001/data/boundary/arcview/hr000b.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
aria2c -x16 --out=hr2003001.zip "https://www150.statcan.gc.ca/n1/pub/82-402-x/2004001/data/boundary/arcview/hr000b.zip" --dir=${DATA_FOLDER}/health_regions/input --auto-file-renaming=false
