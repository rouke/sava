package io.vamp.sava.monolith

import akka.actor.{ActorLogging, ActorSystem, Props}
import akka.io.IO
import akka.pattern.ask
import akka.util.Timeout
import spray.can.Http
import spray.http.StatusCodes._
import spray.http.{HttpRequest, HttpResponse, Timedout}
import spray.routing.HttpServiceActor

import scala.concurrent.duration._
import scala.language.postfixOps

object Server extends App {
  implicit val timeout = Timeout(10 seconds)
  implicit val system = ActorSystem("actor-system")
  val serverActor = system.actorOf(Props[ServerActor], "server-actor")
  IO(Http)(system) ? Http.Bind(serverActor, "0.0.0.0", 8080)
}

class ServerActor extends HttpServiceActor with ActorLogging {

  def handleTimeouts: Receive = {
    case Timedout(x: HttpRequest) =>
      sender() ! HttpResponse(InternalServerError)
  }

  def receive = handleTimeouts orElse runRoute(routes)

  val routes = pathEndOrSingleSlash {
    get {
      getFromResource("public/index.html")
    }
  } ~ pathPrefix("^(css|js|images)$".r) { dir =>
    get {
      getFromResourceDirectory(s"public/$dir")
    }
  } ~ path("^index\\.html$".r) { extension =>
    get {
      getFromResource(s"public/index.html")
    }
  }
}