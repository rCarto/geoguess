# Docker example 

## How to build this app with docker

The fisrt step is to build the docker image of the application.    
The **Dockerfile** is displayed below. It needs to be adapted to the deployed app (system libraries and R packages). 

``` sh
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
```


To build the image run the following command: 

``` sh
docker build -t awesome_geo_app .
```

It will build the **awesome_geo_app** image. 

## How to the the app 

The following command run the app and expose it on the port 80. 

``` sh
docker run --rm -ti -p 80:3838 awesome_geo_app
```

Access the app: http://127.0.0.1/ or http://localhost/
