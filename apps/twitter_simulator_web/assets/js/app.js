// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

let channel = socket.channel("twitter", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

$(document).ready(function () {
  $("#login").click(function () {
    let username = $("#username").val()
    let password = $("#password").val()
    if (username && password) {
      channel.push("login_user", { user: username, password: password })
        .receive("ok", resp => {
          console.log(resp["message"])
          window.userToken = username
        })
        .receive("error", resp => { alert(resp["message"]) })
    } else {
      alert("Please fill username and password")
    }
  })

  $("#signup").click(function () {
    let username = $("#username").val()
    let password = $("#password").val()
    if (username && password) {
      channel.push("register_user", { user: username, password: password })
        .receive("ok", resp => { alert(resp["message"]) })
        .receive("error", resp => { alert(resp["message"]) })
    } else {
      alert("Please fill username and password")
    }
  })
});







