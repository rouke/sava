package io.vamp.sava.frontend

import akka.actor.{ActorLogging, ActorSystem, Props}
import akka.io.IO
import akka.pattern.ask
import akka.util.Timeout
import com.typesafe.config.ConfigFactory
import dispatch._
import org.json4s.DefaultFormats
import org.json4s.native.Serialization._
import spray.can.Http
import spray.http.MediaTypes._
import spray.http.StatusCodes._
import spray.http.{HttpRequest, HttpResponse, Timedout}
import spray.routing.HttpServiceActor

import scala.concurrent.duration._
import scala.language.postfixOps

object Server extends App {
  implicit val timeout = Timeout(10 seconds)
  implicit val system = ActorSystem("actor-system")
  val serverActor = system.actorOf(Props[ServerActor], "server-actor")
  IO(Http)(system) ? Http.Bind(serverActor, "0.0.0.0", 80)
}

class ServerActor extends HttpServiceActor with ActorLogging {

  implicit val ec = context.dispatcher
  val config = ConfigFactory.load().getConfig("frontend")
  val lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

  def handleTimeouts: Receive = {
    case Timedout(x: HttpRequest) =>
      sender() ! HttpResponse(InternalServerError)
  }

  def receive = handleTimeouts orElse runRoute(staticRoutes ~ restRoutes)

  val staticRoutes = pathEndOrSingleSlash {
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

  val restRoutes = pathPrefix("api") {
    respondWithMediaType(`application/json`) {
      path("message1") {
        get {
          onComplete(backend()) { message =>
            complete(OK, write("text" -> message.getOrElse(lorem))(DefaultFormats))
          }
        }
      } ~ path("message2") {
        get {
          onComplete(backend()) { message =>
            complete(OK, write("text" -> message.getOrElse(lorem))(DefaultFormats))
          }
        }
      }
    }
  }

  def backend(): Future[Any] = {
    val host = config.getString("backend.host")
    val port = config.getAnyRef("backend.port") match {
      case v: Integer => v
      case v => v.toString.toInt
    }

    implicit val formats = DefaultFormats
    dispatch.Http(dispatch.url(s"http://$host:$port/api/message") OK dispatch.as.json4s.Json) map { json =>
      json.extract[Map[String, Any]].getOrElse("text", lorem)
    }
  }
}