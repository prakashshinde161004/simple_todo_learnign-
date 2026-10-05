# Use Node.js as base image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package.json from backend folder
COPY backend/package*.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Command to start the app
CMD ["node", "backend/server.js"]
