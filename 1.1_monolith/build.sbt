organization := "io.vamp"

name := """monolith"""

version := "1.1"

scalaVersion := "2.11.6"

scalacOptions := Seq("-unchecked", "-deprecation", "-encoding", "utf8")

resolvers ++= Seq(
  "Spray repo" at "http://repo.spray.io/",
  "Sonatype releases" at "http://oss.sonatype.org/content/repositories/releases/",
  "Typesafe repo" at "http://repo.typesafe.com/typesafe/releases/"
)

libraryDependencies ++= Seq(
  "io.spray" %% "spray-can" % "1.3.3",
  "io.spray" %% "spray-routing" % "1.3.3",
  "org.json4s" %% "json4s-native" % "3.2.11",
  "com.typesafe.akka" %% "akka-actor" % "2.3.9",
  "com.typesafe.akka" %% "akka-slf4j" % "2.3.9",
  "com.typesafe.scala-logging" %% "scala-logging" % "3.1.0",
  "org.slf4j" % "slf4j-api" % "1.7.10",
  "ch.qos.logback" % "logback-classic" % "1.1.2"
)

assemblyJarName in assembly := "1.1_monolith.jar"

spray.revolver.RevolverPlugin.Revolver.settings.settings