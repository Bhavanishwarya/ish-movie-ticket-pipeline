# Use a lightweight web server image
FROM nginx:alpine

# Copy your website files into nginx html folder
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
COPY . /usr/share/nginx/html
