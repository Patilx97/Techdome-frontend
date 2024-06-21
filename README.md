Multi-Container Application Deployment with Docker Compose

Steps:

Launch EC2 instance with instance type t2.small.
Allow port 8080, as we are going to map container ports with 8080.
Connect to EC2 instance with SSH
Create bash file with following content and give it executable permission:

```bash
#! /bin/bash

sudo apt-get update -y
wget https://github.com/slyfox1186/script-repo/raw/main/Bash/Misc/docker-compose-multi-arch.sh
sudo chmod +x docker-compose-multi-arch.sh
sudo ./docker-compose-multi-arch.sh
sudo apt-get install docker.io -y
sudo apt-get install npm nodejs -y
sudo usermod -aG docker ubuntu
git clone https://github.com/Anand-1432/Techdome-backend.git
git clone https://github.com/Anand-1432/Techdome-frontend.git
cd Techdome-backend
wget https://github.com/stark303test/delete-later/blob/master/.env
wget https://github.com/stark303test/delete-later/blob/master/backend/Dockerfile?raw=true -O Dockerfile
npm install
sudo npm install -g pm2
cd /home/ubuntu/Techdome-frontend
wget https://github.com/stark303test/delete-later/blob/master/frontend/Dockerfile?raw=true -O Dockerfile
npm install
pm2 start npm --name "frontend-server" -- start
cd /home/ubuntu
wget https://github.com/stark303test/delete-later/blob/master/docker-compose.yml?raw=true -O docker-compose.yml
```



This above script will:

Update the packages.
Download the docker-compose-multi-arch.sh script and give it executable permission.
Install Docker and Docker Compose.
Install npm and Node.js.
Grant permission to the user ubuntu to run Docker commands without needing to use sudo.
Clone the git repositories for the frontend and backend.
Download the .env file into the Techdome-backend/ directory.
Download Dockerfile and docker-compose.yml into the respective directories.
Install dependencies from the package.json file in the Techdome-backend/ and Techdome-frontend/ directories.

Setup Accounts:
Create accounts on Cloudinary and MongoDB Atlas to get the necessary configuration values for the .env file in the Techdome-backend/ directory.
Deploy the Application:
Navigate to the docker-compose.yml file and run it to create images and run the containers: ```bash $ sudo docker-compose up --build -d ```
After running this command, Docker will create the images and start the containers.
Copy the EC2 instance’s public IP and paste it into your browser with port 8080.














Explanation of Application Architecture
1. Backend Container
Base Image: The backend container is based on the node:14-alpine image, which provides a lightweight Node.js environment using the Alpine Linux distribution.
Working Directory: The application code is copied into the /NodeApp directory within the container.
Exposed Port: The backend application runs on port 5000 inside the container, which is mapped to port 5000 on the host machine.
Command: The backend service is started using the command npm start.
2. Frontend Container
Base Image: The frontend container is also based on the node:14-alpine image, ensuring a lightweight and consistent environment with the backend.
Working Directory: The application code is copied into the /NodeApp directory within the container.
Exposed Port: The frontend application runs on port 3000 inside the container, which is mapped to port 8080 on the host machine to avoid port conflicts.
Command: The frontend service is started using the command npm start.
3. Database Container
Base Image: The database container uses the mongo:5.0.15-focal image, which is a smaller and optimized MongoDB image based on Ubuntu Focal.
Exposed Port: MongoDB runs on port 27017 inside the container, which is mapped to port 27017 on the host machine.
Volume: A named volume mongo-data is used to persist MongoDB data, ensuring data durability and consistency across container restarts.











Deployment Strategy
Infrastructure Setup:
Launch an EC2 instance with t2.small instance type.
Configure necessary ports.
Environment Preparation:
Install Docker, Docker Compose, npm, and Node.js.
Clone the repositories and set up the necessary files and permissions.
Application Deployment:
Use Docker Compose to build and run the containers.
Verification:
Access the application via the EC2 instance's public IP to verify functionality.
Documentation
Prerequisites: Accounts on Cloudinary and MongoDB Atlas.
Setup: Instructions for setting up the environment, cloning the repositories, and configuring the environment variables.
Deployment: Steps to build and run the application using Docker Compose.
Verification: Instructions to access and verify the application's functionality.
Additional Notes
Ensure all necessary environment variables are properly configured in the .env file.
Verify all files and scripts from https://github.com/stark303test/delete-later.git are correctly referenced and used.
Include screenshots or recordings of the application's functionality to demonstrate successful deployment.














docker-compose.yml

```bash
version: '3'
services:
  frontend:
    build:
      context: ./Techdome-frontend
      dockerfile: Dockerfile
    ports:
      - "8080:3000"
  backend:
    build:
      context: ./Techdome-backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    depends_on:
      - database
  database:
    image: mongo:5.0.15-focal
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db

volumes:
  mongo-data:
```




















![Here is the attached screenshot of the homepage](https://github.com/stark303test/Techdome-frontend/raw/master/Screenshot%202024-06-20%20231411.jpg)

























Techdome-Backend/Dockerfile
```bash
# Techdome-backend/Dockerfile

# Lightweight Node.js
FROM node:14-alpine

# Set the working directory to /NodeApp
WORKDIR /NodeApp

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages from package.json
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy the .env file from the host to the container
COPY .env .env

# Exposing port the app runs on
EXPOSE 5000

# To Run the app
CMD ["npm", "start"]
```

















Techdome-frontend/Dockerfile
```bash
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

```



