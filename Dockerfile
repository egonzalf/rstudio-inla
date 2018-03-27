#FROM r-base:latest
FROM rocker/rstudio:latest

#RUN apt-get update && apt-get -y install -t unstable
RUN apt-get update && apt-get -y install \
        build-essential \
        gcc g++ gfortran \
        libgdal-dev \
        libglu1-mesa-dev \
        libgraphviz-dev \
        libssl-dev \
        mesa-common-dev && \
    Rscript -e 'install.packages("INLA", repos=c("https://cloud.r-project.org/", INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)' && \
    rm -rf /tmp/*
