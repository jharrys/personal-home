# Spring Boot, Micrometer, Webflux, Zipkin 

* Spring Boot: Java based framework for developing services
  * Webflux: Project Reactor that uses the WebClient instead of RestTemplate
  * Micrometer: Spring developed as the SLF4J of observability libraries. Provides a library for code instrumentation and also provides a bridge to other tracing formats.
* Zipkin: an app for visualizing distributed tracing
  * Brave: a distributed tracing instrumentation library providing trace context and propagation formats.

management.endpoints.web.base-path: "/api/actuator"
exposure:
include: "*"
endpoint:
health:
roles: "${stack.security.management.role}"
show-details: when_authorized
metrics:
enable:
all: true
distribution:
percentiles-histogram:
http.server.requests: true
tags:
application: "${spring.application.name}-${spring.profiles.active}"
zone: "us-east-1"
dynatrace:
metrics:
export:
api-token: "${dynatrace.api.token}"
enabled: false
v2:
metric-key-prefix: "${spring.application.name}-${spring.profiles.active}"
uri: "https://dvt94319.live.dynatrace.com/api/v2/otlp"
tracing:
sampling:
probability: 1.0
