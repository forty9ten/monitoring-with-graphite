package com.devopscasts.demo

import java.util.concurrent.ConcurrentHashMap
import com.timgroup.statsd.NonBlockingStatsDClient

class DemoServlet extends DemoAppStack {
  val stats = new NonBlockingStatsDClient("demoapp", "localhost", 8125)

  before() {
    contentType = "text/html"
    request.setAttribute("requestStart", System.currentTimeMillis)
  }

  after() {
    val requestEnd = System.currentTimeMillis
    request.getAttribute("requestStart") match {
      case requestStart: java.lang.Long =>
        stats.recordExecutionTime("latency.millis", (requestEnd - requestStart).asInstanceOf[Int])
      case _ => stats.increment("latency.unusable")
    }
  }

  get("/") {
    if (session.get("loggedIn").nonEmpty) {
      stats.increment("page.home.member")
      jade("index")
    } else {
      stats.increment("auth.anonymous.rejected")
      redirect("sessions/new")
    }
  }

  get("/sessions/new") {
    stats.increment("page.sessions.new")
    jade("sessions/new")
  }

  get("/sessions/destroy") {
    stats.increment("auth.sessions.closed")
    session.remove("loggedIn")
    redirect("/")
  }

  def signInFail = {
    jade("sessions/new", "message" -> Option("Username or password is incorrect"))
  }

  post("/sessions") {
    (params("email"), params("password")) match {
      case(email:String, password:String) if email.nonEmpty && password.nonEmpty => {
        val user = UserData.all.get(email)
        if (user != null) {
          stats.increment("auth.sessions.userFound")
          if (user.password == password) {
            stats.increment("auth.sessions.opened")
            flash.update("notice", "Signed in successfully!")
            session.setAttribute("loggedIn", email)
            redirect("/")
          } else {
            stats.increment("auth.sessions.badPassword")
            signInFail
          }
        } else {
          stats.increment("auth.sessions.badUser")
          signInFail
        }
      }
      case _ => {
        stats.increment("auth.sessions.formIncomplete")
        signInFail
      }
    }
  }

  get("/users/new") {
    stats.increment("page.users.new")
    jade("users/new")
  }

  post("/users") {
    (params("email"), params("password")) match {
      case(email:String, password:String) if email.nonEmpty && password.nonEmpty => {
        UserData.all.put(params("email"), new User(params("email"), params("password")))
        stats.recordGaugeValue("auth.users.total", UserData.all.size())
        stats.increment("auth.registration.success")
        flash.update("notice", "Registered successfully!")
        redirect("/")
      }
      case _ => {
        stats.increment("auth.registration.formIncomplete")
        jade("users/new", "message" -> Option("Please provide an email and password"))
      }
    }
  }
}

case class User(email: String, password: String)

object UserData {
  var all = new ConcurrentHashMap[String, User]()
}