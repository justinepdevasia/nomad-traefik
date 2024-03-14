job "webapp" {
  datacenters = ["dc1"]

  type = "service"

  group "webapp" {
    count = 1

    network {
       mode = "host"
       port "http" {
         to = 80
       }
    }

    service {
      name = "webapp"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.webapp.rule=Path(`/`)",
      ]
    }

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }
    }
  }
}