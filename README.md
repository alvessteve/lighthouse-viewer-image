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

### FAQ

1. **I have a permission denied when cloning the git repo**

This means that you have no identity set up in your ssh configuration. You can fix this by adding your ssh key to the ssh-agent:

```bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```

or

```bash
ssh-add --apple-use-keychain
```

source: https://stackoverflow.com/questions/70611942/docker-ssh-default-permission-denied-publickey