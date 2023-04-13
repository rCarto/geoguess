# original image
FROM rocker/shiny-verse:latest

# needed libraries (spatial and internet stuff)
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
    libudunits2-dev \
	libgdal-dev \
	libgeos-dev \
	libproj-dev \
	libfontconfig1-dev
	
# install relevant R packages  
RUN install2.r --error sf leaflet DT

# clean apps in the shiny app folder
RUN rm -rf /srv/shiny-server/*

# copy the app 
COPY cityguess /srv/shiny-server/
