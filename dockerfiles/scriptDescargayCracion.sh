#!/bin/bash

sudo docker pull griger/maquinalocal
sudo docker pull griger/maquinappal
sudo docker pull griger/maquinadata

sudo docker run -itd --name contenedorLocal griger/maquinalocal
sudo docker run -itd --name contenedorPpal griger/maquinappal
sudo docker run -itd --name contenedorData griger/maquinadata
