# Make sure you have rclone installed

echo '[data-01-dataforcanada]' >> ~/.config/rclone/config
echo 'type = http' >> ~/.config/rclone/config
echo 'url = https://data-01.dataforcanada.org' >> ~/.config/rclone/config

# If you want to list the Census of Population dataset
rclone ls data-01-dataforcanada:/processed/statistics_canada/census_of_population
# If you want to copy the entire Census of Population dataset
rclone copy --progress --transfers=16 data-01-dataforcanada:/processed/statistics_canada/census_of_population census_of_population
