# Lighthouse Viewer Docker image

This repository contains the Dockerfile for the Lighthouse Viewer Docker image. 

## Usage

### Build the Docker image

To build the Lighthouse Viewer Docker image, you can use the following command:

```bash
docker build --ssh default -t lighthouse-viewer .
```  

### Run the Docker image

To run the Lighthouse Viewer Docker image, you can use the following command:

```bash
docker run -p 7333:7333 -d --name lighthouse-viewer lighthouse-viewer
```