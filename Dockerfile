# Use an official Node runtime as a parent image
FROM cgr.dev/chainguard/node:18.20.2

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY --chown=node:node ["package.json", "package-lock.json", "server.js", "./"]

# Install any needed packages specified in package.json
RUN npm install --omit-dev

# Run server.js when the container launches
CMD [ "server.js" ]
