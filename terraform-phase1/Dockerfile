# Use official nginx image as base
FROM nginx:alpine

# Copy your custom website files
COPY ../public/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
