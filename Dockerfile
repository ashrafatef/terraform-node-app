# Use an official Node.js runtime as the base image
FROM node:18.16.0-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock.json to the working directory
COPY package.json yarn.lock ./

# Install project dependencies
RUN yarn install

# Copy the rest of the application code
COPY . .

# Expose the port that the app will run on
EXPOSE 3000

# Define the command to run your application
CMD ["node", "./server/index.js"]
