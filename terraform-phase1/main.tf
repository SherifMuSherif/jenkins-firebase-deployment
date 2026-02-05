terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Build the custom nginx image
resource "docker_image" "custom_nginx" {
  name = "terraform-custom-nginx:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

# Run the container
resource "docker_container" "custom_nginx" {
  image = docker_image.custom_nginx.image_id
  name  = "terraform-custom-nginx-container"
  ports {
    internal = 80
    external = 5000
  }
  
  # Restart policy
  restart = "unless-stopped"
}
