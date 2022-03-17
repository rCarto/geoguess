FROM rocker/shiny-verse:latest
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    curl \
    libcurl4-openssl-dev \
    libxml2-dev \
    libudunits2-0 \
    libudunits2-dev
RUN apt-get update && apt-get install -y \
	libgdal-dev \
	libgeos-dev \
	libproj-dev \
	libfontconfig1-dev


RUN install2.r --error sf leaflet

RUN install2.r --error DT