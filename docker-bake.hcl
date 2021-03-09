// Special target: https://github.com/crazy-max/ghaction-docker-meta#bake-definition
target "ghaction-docker-meta" {
  tags = ["crazymax/diun:local"]
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["ghaction-docker-meta"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}
