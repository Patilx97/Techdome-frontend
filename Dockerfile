# Techdome-frontend/Dockerfile

# Lightweight Node.js image 
FROM node:14-alpine

# Set the working directory to /NodeApp
WORKDIR /NodeApp

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages from package.json
RUN npm install

# Copy the current data to working directory
COPY . .

# Exposing port
EXPOSE 3000

# To tun the app
CMD ["npm", "start"]
