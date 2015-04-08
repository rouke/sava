# Sava - VAMP showcase services


## Services

**Monolith 1.0**

* Simple monolithic application without real server-side (only to provide the static content).
* Landing page messages provided by external [lorem ipsum API](http://hipsterjesus.com).
* docker pull magneticio/sava-1.0_monolith

**Monolith 1.1**

* Similar to **Monolith 1.0** but with different (dark) theme and 2 column messages.
* docker pull magneticio/sava-1.1_monolith

**Frontend 1.2**

* Serves the static content (index.html, css, js).
* Rest API endpoints /api/message1 and /api/message2.
* API endpoints are just proxy to 2 separate backends (backend1 & backend2).
* docker pull magneticio/sava-1.2_frontend

**Backend 1.2**

* Simple single endpoint Rest API /api/messages, by default responding with custom [lorem ipsum](http://hipsterjesus.com).
* Used for **Frontend 1.2** (as 2 different dependencies) and **Frontend 1.3** (as single dependency)
* docker pull magneticio/sava-1.2_backend

**Frontend 1.3**

* Similar to **Frontend 1.2** but with different theme and single backend.
* docker pull magneticio/sava-1.3_frontend

## Building services

Running **docker/build.sh VERSION** will:

* build assembly (fat) jars
* create and push docker images (access right to magneticio Docker repository required) with specified **VERSION**


## Showcases

**A/B testing different themes:** 

* **Monolith 1.0** + **Monolith 1.1** with router filters and weights (e.g. by browser type).

Steps: 

* deploy 1.0_monolith.yaml
* add to the deployment 1.1_monolith.yaml
* adjust weights and filters
* adjust weight to 100% for 1.1 and remove the 1.0 from the deployment (using 1.0_monolith.yaml)

**Topology change:**

* Starting with micro-services and over-engineering it (3 services): from **Monolith 1.x** to 3 service deployment **Frontend 1.2** & 2 **Backend 1.2**.
* Moving back to more reasonable micro-services setup (2 services): from **Frontend 1.2** and 2 backends to deployment of **Frontend 1.3** and single **Backend 1.2**.

Steps: 

* deploy 1.2_fe_be.yaml
* add to the deployment 1.3_fe_be.yaml
* adjust weights and filters
* adjust weight to 100% for 1.3 and remove the 1.2 from the deployment (using 1.2_fe_be.yaml)


