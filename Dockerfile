FROM ghcr.io/osgeo/gdal:ubuntu-full-3.11.0

USER root

RUN apt-get update -y \
    && apt-get -y install gcc g++ make libsqlite3-dev zlib1g-dev

# Utilities
RUN apt-get install -y neovim \
                       python3-neovim \
                       htop \
                       tmux \
                       git \
                       aria2 \
                       postgresql-client \
                       zip

# tippecanoe
RUN git clone https://github.com/felt/tippecanoe.git \
    && cd tippecanoe \
    && git checkout 2.78.0 \
    && make -j \
    && make install \
    && rm /home/jovyan/tippecanoe -rf

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

# Create virtual environment and install Python packages
RUN uv venv ~/.venv \
    && cd ~ \
    && uv pip install 'geopandas[all]' duckdb psycopg2-binary jupyterlab lonboard click stats-can openpyxl ordered-set sqlfluff buckaroo

# Bash Kernel
RUN cd ~ \
    && uv pip install bash_kernel \
	&& /root/.venv/bin/python -m bash_kernel.install

# Install DuckDB
RUN mkdir -p ~/.local/bin \
    && curl https://install.duckdb.org | sh

# When user logs in, we use the spatial virtual environment
RUN echo 'source /root/.venv/bin/activate' > ~/.bashrc \
    && echo 'export PATH="~/.local/bin:${PATH}"' >> ~/.bashrc

RUN mkdir /data

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && uv cache clean