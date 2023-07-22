#!/bin/bash

# Download the .deb file
sudo wget https://github.com/Zerbaib/AppImageBuilder/releases/download/v1.9/AppImageBuilder.deb

# Install the .deb file
sudo dpkg -i AppImageBuilder.deb

# Clean up by removing the .deb file
sudo rm -R AppImageBuilder.deb
