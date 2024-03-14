job "traefik" {
  datacenters = ["dc1"]
  type        = "system"

  group "traefik" {

    network {
      mode = "host"
      port  "http"{
         static = 80
      }
      port  "admin"{
         static = 8080
      }
    }

    task "server" {
      driver = "docker"
      config {
        image = "traefik:2.11"
        ports = ["admin", "http"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true", # not for production
          "--ping=true",
          "--ping.terminatingStatusCode=204",
          "--ping.entryPoint=web",
          "--entrypoints.web.address=:${NOMAD_PORT_http}",
          "--entrypoints.traefik.address=:${NOMAD_PORT_admin}",
          "--providers.nomad=true",
          "--providers.nomad.endpoint.address=http://<nomad server ip>:4646" 
        ]
      }

      resources {
        cpu    = 100 # Mhz
        memory = 100 # MB
      }
    }

    service {
      name = "traefik-http"
      provider = "nomad"
      port = "http"
    }
  }
}