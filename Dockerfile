FROM rocker/rstudio:latest

# use either: 'stable' or 'testing'
ARG INLA_REPO='stable'

# OPENBLAS IS DEFINED AS ALTERNATIVE TO BLAS, SHOULD INCREASE PERFORMANCE
ENV LD_LIBRARY_PATH="/etc/alternatives/:$LD_LIBRARY_PATH" \
    LIBRARY_PATH="/etc/alternatives/:$LIBRARY_PATH"

RUN apt-get update && apt-get -y install \
        build-essential \
        gcc g++ gfortran \
        libfreetype6-dev \
        libgdal-dev \
        libglu1-mesa-dev \
        libgraphviz-dev \
        libssl-dev \
        mesa-common-dev && \
    apt-get clean && \
    Rscript -e "install.packages('INLA', repos=c('https://cloud.r-project.org/', INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), dep=TRUE)" && \
    Rscript -e "options(repos = c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/$INLA_REPO'))" && \
    Rscript -e "update.packages(ask=FALSE)" && \
    rm -rf /tmp/*
