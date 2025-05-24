#!/bin/bash
echo "Processing 2021 Census of Agriculture"
jupyter execute census_of_agriculture/process_2021.ipynb
echo "Processing 2016 Census of Agriculture"
jupyter execute census_of_agriculture/process_2016.ipynb