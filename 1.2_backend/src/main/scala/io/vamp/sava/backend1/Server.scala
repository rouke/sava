package io.vamp.sava.backend1

import akka.actor.{ActorLogging, ActorSystem, Props}
import akka.io.IO
import akka.pattern.ask
import akka.util.Timeout
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
  IO(Http)(system) ? Http.Bind(serverActor, "0.0.0.0", 8081)
}

class ServerActor extends HttpServiceActor with ActorLogging {

  implicit val ec = context.dispatcher
  val lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

  def handleTimeouts: Receive = {
    case Timedout(x: HttpRequest) =>
      sender() ! HttpResponse(InternalServerError)
  }

  def receive = handleTimeouts orElse runRoute(route)

  val route = pathPrefix("api") {
    respondWithMediaType(`application/json`) {
      path("message") {
        get {
          onComplete(hipster) { message =>
            complete(OK, write("text" -> message.getOrElse(lorem))(DefaultFormats))
          }
        }
      }
    }
  }

  def hipster: Future[Any] = {
    implicit val formats = DefaultFormats
    dispatch.Http(dispatch.url("http://hipsterjesus.com/api/?paras=1&type=hipster-latin&html=false") OK dispatch.as.json4s.Json) map { json =>
      json.extract[Map[String, Any]].getOrElse("text", lorem)
    }
  }
}
