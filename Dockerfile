# Use an official Node from chainguard, need to change the specific version for prod environment
FROM cgr.dev/chainguard/node

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY --chown=node:node ["package.json", "package-lock.json", "server.js", "start.js", "./"]
COPY --chown=node:node ["models/Lookup.js", "./models/Lookup.js"]

# Install any needed packages specified in package.json
RUN npm install --omit-dev

# Run server.js when the container launches
CMD [ "start.js" ]
