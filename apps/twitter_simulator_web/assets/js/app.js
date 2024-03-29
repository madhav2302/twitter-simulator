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
  channel.on('notify', function (payload) {
    $("#ul").append(createLi(payload))
    console.log(payload)
  })

  var login = $("#login")
  var welocomeName = $("#welcome_name")
  var logout = $("#logout")
  var signup = $("#signup")
  var dashboardContainer = $("#dashboardContainer")
  var loginContainer = $("#loginContainer")
  var tweetBtn = $("#tweetBtn")

  login.click(function () {
    let username = $("#username").val()
    let password = $("#password").val()
    if (username && password) {
      channel.push("login_user", { user: username, password: password })
        .receive("ok", resp => {
          window.userToken = username
          welocomeName.text(username + "!")
          console.log(resp["message"])

          loginContainer.css('display', 'none')
          dashboardContainer.css('display', 'block')
        })
        .receive("error", resp => { alert(resp["message"]) })
    } else {
      alert("Please fill username and password")
    }
  })

  logout.click(function () {
    console.log("Logging out")
    channel.push("logout_user", { user: window.userToken })
      .receive("ok", resp => {
        console.log(resp)
        location.reload()
      }).receive(
        "error", resp => {
          console.log(resp)
        }
      )
  })

  signup.click(function () {
    let username = $("#username").val()
    let password = $("#password").val()
    if (username && password) {
      channel.push("register_user", { user: username, password: password })
        .receive("ok", resp => {
          alert(resp["message"])
        })
        .receive("error", resp => { alert(resp["message"]) })
    } else {
      alert("Please fill username and password")
    }
  })

  function createLi(map) {
    var li = '<li>' +
      '<div style="display: inline-block; width: 25%;">' + new Date(map.time).toLocaleString() + '</div>'
      + '<div style="display: inline-block; width: 60%;">' + map.user + ': ' + map.tweet + '</div>'

    if (map.user !== window.userToken) {
      li = li + '<div style="display: inline-block; width: 10%;">'
        + '<input type="radio" name="retweet_id" value="' + map.tweetid + '">'
        + '</div>'
    }

    li += '</li>'

    return li;
  }

  tweetBtn.click(function () {
    let tweet = $("#tweetBox").val()

    if (tweet) {
      channel.push("tweet", { user: window.userToken, tweet: tweet })
        .receive("ok", resp => {
          // console.log(resp)
          $("#ul").append(createLi(resp.message))
          $("#tweetBox").val('')
        })
        .receive("error", resp => {
          alert(resp["message"])
        })
      console.log("Tweeting " + tweet)

    } else {
      alert("Tweet empty")
    }
  })

  var follow = $("#followBtn")
  follow.click(function () {
    let username = window.userToken
    let followUsername = $("#followerBox").val()
    if (followUsername === username) {
      alert("Cannot follow to self")
    } else if (followUsername) {
      channel.push("follow_user", { user: username, following: followUsername })
        .receive("ok", resp => {
          alert(resp["message"])
          $("#followerBox").val('')
        })
        .receive("error", resp => { alert(resp["message"]) })
    } else {
      alert("Please fill username of the user to follow")
    }
  })

  function clearTable() {
    var hashtagTable = document.getElementById("hashtagTable")
    var rowCount = hashtagTable.rows.length;
    while (rowCount >= 0) {
      hashtagTable.deleteRow(rowCount - 1);
      rowCount--;
    }
  }

  var hashtagBtn = $("#hashtagBtn")
  hashtagBtn.click(function () {
    let hashtag = $("#hashtagBox").val()
    if (hashtag) {
      channel.push("query_by_hashtag", hashtag)
        .receive("ok", resp => {
          clearTable()
          var hashtagTable = document.getElementById("hashtagTable")
          var tweet = resp["result"]
          for (var i = 0; i < tweet.length; i++) {
            var row = hashtagTable.insertRow()
            var cell = row.insertCell()
            console.log(tweet[i])
            cell.innerHTML = tweet[i]
          }
        })
        .receive("error", resp => { alert("No tweets found with the hashtag " + hashtag) })
    } else {
      alert("Please fill hashtag to query")
    }
  })

  function clearMentionTable() {
    var mentionTable = document.getElementById("mentionTable")
    var rowCount = mentionTable.rows.length;
    while (rowCount >= 0) {
      mentionTable.deleteRow(rowCount - 1);
      rowCount--;
    }
  }

  var mentionBtn = $("#mentionBtn")
  mentionBtn.click(function () {
    let mention = $("#username").val()
    if (mention) {
      channel.push("query_by_mention", mention)
        .receive("ok", resp => {
          clearMentionTable()
          var mentionTable = document.getElementById("mentionTable")
          var tweet = resp["result"]
          for (var i = 0; i < tweet.length; i++) {
            var row = mentionTable.insertRow()
            var cell = row.insertCell()
            console.log(tweet[i])
            cell.innerHTML = tweet[i]
          }
        })
        .receive("error", resp => { alert("No tweets found with mention " + mention) })
    } else {
      alert("Please fill mention to query")
    }
  });

  var retweet = $("#retweetBtn")
  retweet.click(function () {
    var tweetid = $('input[name=retweet_id]:checked').val()

    if (tweetid) {
      channel.push("retweet", { user: window.userToken, tweet_id: tweetid })
        .receive("ok", resp => {
          console.log(resp)
          $("#ul").append(createLi(resp.message))
          $('input[name=retweet_id]:checked').prop('checked', false)
        }).receive("error", resp => {
          alert(resp.message)
        })

    } else {
      alert("Please select tweet to retweet")
    }
    console.log()
  })
})

