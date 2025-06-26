FROM ghcr.io/osgeo/gdal:ubuntu-full-3.11.0

# Ubuntu is UID 1000 and GID 1000
ARG USERNAME=ubuntu

USER root

RUN apt-get update \
    && apt-get -y install gcc g++ make libsqlite3-dev zlib1g-dev

# Add user to sudoers
RUN apt-get -y install sudo \
     && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
     && chmod 0440 /etc/sudoers.d/${USERNAME}

# Utilities
RUN apt-get install -y neovim \
                       python3-neovim \
                       htop \
                       tmux \
                       git \
                       aria2 \
                       postgresql-client \
                       zip \
                       jq

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
    && uv pip install 'geopandas[all]' duckdb psycopg2-binary jupyterlab lonboard click stats-can openpyxl ordered-set buckaroo jenkspy 'polars[all]'

# Bash Kernel
RUN cd ~ \
    && uv pip install bash_kernel \
	&& /root/.venv/bin/python -m bash_kernel.install

# When user logs in, we use the spatial virtual environment
RUN echo 'source /home/'${USERNAME}'/.venv/bin/activate' > ~/.bashrc \
    && echo 'export PATH="/home/'${USERNAME}'/.local/bin:${PATH}"' >> ~/.bashrc

RUN mv /root/.venv /home/${USERNAME} \
    && mv /root/.bashrc /home/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} -R /home/${USERNAME}/.venv \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc

RUN mkdir /data

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && uv cache clean

USER ubuntu

# Install DuckDB
RUN mkdir -p ~/.local/bin \
    && curl https://install.duckdb.org | sh