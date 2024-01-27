# Use the official Node.js 18 image from DockerHub
FROM --platform=linux/amd64 node:21-slim

# Create a directory in the container to hold the application code
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the work directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application code to the work directory
COPY . .

ARG PORT=3000

# Expose port 3000 to the outside world
EXPOSE ${PORT}

# Start the application
CMD [ "node", "index.js" ]
