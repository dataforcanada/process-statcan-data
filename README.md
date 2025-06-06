## Table of Contents
- [About](#about)
- [How to Run](#how-to-run)
- [License](#license)

## About

**process-statcan-data** is a set of scripts that helps you load and prepare Statistics Canada data for analysis. It performs schema normalization, field name standardization, and adds derived fields (such as DGUIDs) to improve consistency, interoperability, and usability across datasets.

All output datasets are written in GeoParquet format to support modern geospatial workflows and ensure broad compatibility across platforms.

This project processes the following datasets:

- **Geographic Boundaries** (2001–2021)
- **Census of Population** (2001–2021)
- **National Household Survey** (2011–2016)
- **Census of Agriculture** (2001–2021)
- **National Address Register** (2022–2024)
- **Road Network Files** (2001–2021)

## How to Run

This project uses a Dev Container environment for setup and execution. If you are using VS Code all you need is the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed and Docker installed on your system. 

```shell
# Clone the repository
git clone https://github.com/dataforcanada/process-statcan-data.git

# Navigate to the project directory
cd process-statcan-data

# In Dev Container
./main.sh
```

## License

This product is distributed under an MIT license.

[Back to top](#top)
