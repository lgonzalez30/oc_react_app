# Use the official Node.js runtime as the base image
FROM node:18 as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application code to the container
COPY . .

# Build the React app for production
RUN npm run build

# Use Nginx as the production server
FROM nginx:alpine
RUN  touch /var/run/nginx.pid && \
     chown -R nginx:nginx /var/cache/nginx /var/run/nginx.pid
USER nginx
COPY --chown=nginx:nginx my/html/files /usr/share/nginx/html
COPY --chown=nginx:nginx config/myapp/default.conf /etc/nginx/conf.d/default.conf


# Expose port 80 for the Nginx server
EXPOSE 8080

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
