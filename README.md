# Sava - VAMP showcase services


## Services

**Monolith 1.0**

* Simple monolithic application without real server-side (only to provide the static content).
* Landing page messages provided by external [lorem ipsum API](http://hipsterjesus.com).

**Monolith 1.1**

* Similar to **Monolith 1.0** but with different (dark) theme and 2 column messages.

**Frontend 1.2**

* Serves the static content (index.html, css, js).
* Rest API endpoints /api/message1 and /api/message2.
* API endpoints are just proxy to 2 separate backends (backend1 & backend2).

**Backend 1.2**

* Simple single endpoint Rest API /api/messages, by default responding with custom [lorem ipsum](http://hipsterjesus.com).
* Used for **Frontend 1.2** (as 2 different dependencies) and **Frontend 1.3** (as single dependency)

**Frontend 1.3**

* Similar to **Frontend 1.2** but with different theme and single backend.

## Showcases

**A/B testing different themes:**

* **Monolith 1.0** + **Monolith 1.1** with router filters (e.g. by browser type).

**Topology change:**

* Starting with micro-services and over-engineering it (3 services): from **Monolith 1.x** to 3 service deployment **Frontend 1.2** & 2 **Backend 1.2**.
* Moving back to more reasonable micro-services setup (2 services): from **Frontend 1.2** and 2 backends to deployment of **Frontend 1.3** and single **Backend 1.2**.

