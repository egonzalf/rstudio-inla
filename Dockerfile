FROM rocker/rstudio:3.4.4

# OPENBLAS IS DEFINED AS ALTERNATIVE TO BLAS, SHOULD INCREASE PERFORMANCE
ENV LD_LIBRARY_PATH="/etc/alternatives/:$LD_LIBRARY_PATH" \
    LIBRARY_PATH="/etc/alternatives/:$LIBRARY_PATH"

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        build-essential \
        gcc g++ gfortran \
        libfreetype6-dev \
        libgdal-dev \
        libglu1-mesa-dev \
        libgraphviz-dev \
        libssl-dev \
        mesa-common-dev && \
    apt-get clean

# Install R packages
# In this case shiny requirement is not properly met
# during INLA installation, so we install it beforehand.
RUN Rscript -e "options(repos = c('https://cloud.r-project.org/')); \
    update.packages(ask=FALSE); \
    install.packages('shiny');  \
    install.packages(c('colorspace', 'assertthat', 'utf8', 'RColorBrewer', 'dichromat', 'munsell', 'labeling', 'viridisLite', 'cli', 'crayon', 'pillar', 'rlang', 'gtable', 'plyr', 'reshape2', 'scales', 'tibble', 'SparseM', 'dotCall64', 'lazyeval', 'ggplot2', 'miniUI', 'codetools', 'curl', 'openssl', 'backports', 'coda', 'MASS', 'mcmc', 'quantreg', 'lattice', 'spam', 'maps', 'htmlwidgets', 'crosstalk', 'manipulateWidget', 'polynom', 'httr', 'memoise', 'whisker', 'rstudioapi', 'git2r', 'withr', 'evaluate', 'highr', 'yaml', 'base64enc', 'rprojroot', 'MCMCpack', 'gtools', 'akima', 'ltsa', 'sp', 'Matrix', 'mvtnorm', 'numDeriv', 'fields', 'rgl', 'pixmap', 'splancs', 'orthopolynom', 'devtools', 'knitr', 'markdown', 'rmarkdown', 'rgdal', 'Deriv', 'HKprocess', 'FGN', 'MatrixModels'))" && \
    rm -rf /tmp/*

# Define the version/repo of INLA to use. Choose either: 'stable' or 'testing'
ARG INLA_REPO='stable'
ARG TIMESTAMP

# Install INLA
RUN Rscript -e "install.packages('INLA', repos=c('https://cloud.r-project.org/', INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), dep=TRUE)" && \
    rm -rf /tmp/*

LABEL maintainer="Eduardo Gonzalez Fisher"
