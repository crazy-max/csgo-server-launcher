variable "DEFAULT_TAG" {
  default = "csgo-server-launcher:local"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = [DEFAULT_TAG]
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

variable "TEST_BASE_IMAGE" {
  default = null
}

target "test-install" {
  dockerfile = "test.Dockerfile"
  target = "install"
  args = {
    BASE_IMAGE = TEST_BASE_IMAGE
  }
  output = ["type=cacheonly"]
}
