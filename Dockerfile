FROM rocker/r-ver:4.1.1

# system libraries of general use
## install debian packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    build-essential \
    libcairo2-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libfontconfig1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    coinor-libcbc-dev \
    libudunits2-dev \
    libgeos-dev \
    coinor-libclp-dev \
    libgsl-dev \
    libgdal-dev \
    libxt-dev \
    libgeos-dev \
    libproj-dev \
    libglpk-dev && \
    apt-get clean

# Install R packages (https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file)

RUN install2.r --error \
    devtools \
    BiocManager \
    data.table \
    magrittr \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# install packages from Bioconductor
#RUN R -e 'requireNamespace("BiocManager"); BiocManager::install(c("mzR", "MSnbase", "xcms"));' \
#&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN R -e 'BiocManager::install("mzR")'
RUN R -e 'BiocManager::install("MSnbase")'
RUN R -e 'BiocManager::install("xcms")'

# install remote packages
RUN R -e 'devtools::install_github("lingjuewang/credential", ref="release/3.1",dependencies = T)'

ENTRYPOINT ["/bin/bash"]