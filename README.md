# rstudio-inla
Docker container with RStudio and INLA package. The image is available in Docker Hub: https://hub.docker.com/r/egonzalf/ in two flavors:
- Using [stable INLA](https://hub.docker.com/r/egonzalf/inla-stable-rstudio/)
- Using [testing INLA](https://hub.docker.com/r/egonzalf/inla-testing-rstudio/)

The Dockerfile allows to build using the stable (default) or testing repository for [INLA](http://www.r-inla.org).

I'm providing as well a script to run a docker container based on Rstudio + INLA image.
* Start the container exposing Rstudio on a predefined port.
* Change default user (rstudio) id to match current host user.
* Mount a host directory to use as Rstudio working directory.
