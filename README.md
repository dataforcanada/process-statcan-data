## Table of Contents
- [About](#about)
- [How to Run](#how-to-run)
- [License](#license)

## About

**process-statcan-data** is a set of scripts that helps you load and prepare Statistics Canada data for analysis. It performs schema normalization, field name standardization, and adds derived fields (such as DGUIDs) to improve consistency, interoperability, and usability across datasets.

All output datasets are written in GeoParquet format to support modern geospatial workflows and ensure broad compatibility across platforms.

This project processes the following datasets:

- **Geographic Boundaries** (2001–2021)
- **Road Network Files** (2001–2021)
- **Health Regions** (2003–2023)
- **National Address Register** (2022–2024)
- **Census of Population** (2001–2021)
- **Census of Agriculture** (2001–2021)
- **National Household Survey** (2011–2016)

## How to Run

This project uses a **Dev Container** environment for setup and execution:

```shell
# Clone the repository
git clone https://github.com/dataforcanada/process-statcan-data.git

# Navigate to the project directory
cd process-statcan-data
```

## License

This product is distributed under an MIT license.

[Back to top](#top)