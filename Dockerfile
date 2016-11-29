# -- TODO -- GET temporary token for checking out private repos

FROM node:argon
RUN apt-get install wget -y
RUN wget -qO- https://github.com/amalgam8/amalgam8/releases/download/v0.4.2/a8sidecar.sh | sh

WORKDIR /usr/src/
# -- Private npm attempt
RUN git clone https://github.com/DecentricCorp/insight-api-coval.git
WORKDIR /usr/src/insight-api-coval/
RUN npm install -g n
RUN n 0.10.36
RUN npm install
# -- Expose ports
WORKDIR /usr/src/insight-api-coval/
EXPOSE 3027
CMD [ "bash", "./usr/src/insight-api-coval/start2" ]
#ENTRYPOINT ["a8sidecar", "node", "index.js"]


