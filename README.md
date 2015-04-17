# Sava - VAMP showcase services


## Services

**Sava 1.0**

* Simple monolithic application without real server-side (only to provide the static content).
* Landing page messages provided by external [lorem ipsum API](http://hipsterjesus.com).
* docker pull magneticio/sava:1.0.0

**Sava 1.1**

* Similar to **Sava 1.0** but with different (dark) theme and 2 column messages.
* docker pull magneticio/sava:1.1.0

**Sava Frontend 1.2**

* Serves the static content (index.html, css, js).
* Rest API endpoints /api/message1 and /api/message2.
* API endpoints are just proxy to 2 separate backends (backend1 & backend2).
* docker pull magneticio/sava-frontend:1.2.0

**Sava Backend 1.2**

* Simple single endpoint Rest API /api/messages, by default responding with custom [lorem ipsum](http://hipsterjesus.com).
* Used for **Sava Frontend 1.2** as 2 different dependencies 1 & 2
* docker pull magneticio/sava-backend1:1.2.0
* docker pull magneticio/sava-backend2:1.2.0

**Sava Frontend 1.3**

* Similar to **Frontend 1.2** but with different theme and single backend.
* docker pull magneticio/sava-frontend:1.3.0
* docker pull magneticio/sava-backend:1.3.0

**Sava Backend 1.3**

* Backend for 1.3 version
* docker pull magneticio/sava-backend:1.3.0

## Building services

Running **docker/build.sh VERSION** will:

* build assembly (fat) jars
* create and push docker images (access right to magneticio Docker repository required) with specified **VERSION**


## Showcases

**A/B testing different themes:** 

* **Sava Monolith 1.0** + **Sava Monolith 1.1** with router filters and weights (e.g. by browser type).

Steps: 

* deploy sava_1.0.yaml
* add to the deployment sava_1.1.yaml
* adjust weights and filters
* adjust weight to 100% for 1.1 and remove the 1.0 from the deployment (using sava_1.0.yaml)

**Topology change:**

* Starting with micro-services and over-engineering it (3 services): from **Sava 1.x** to 3 service deployment **Sava Frontend 1.2** & 2 **Sava Backend 1.2**.
* Moving back to more reasonable micro-services setup (2 services): from **Sava Frontend 1.2** and 2 backends to deployment of **Sava Frontend 1.3** and single **Sava Backend 1.3**.

Steps: 

* deploy sava_1.2.yaml
* add to the deployment sava_1.3.yaml
* adjust weights and filters
* adjust weight to 100% for 1.3 and remove the 1.2 from the deployment (using sava_1.2.yaml)


