FROM rocker/tidyverse:3.6.3

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y liblzma-dev && \
    apt-get install -y libbz2-dev

RUN Rscript -e "install.packages('rJava')"
