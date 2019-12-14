# TwitterSimulatorWeb

Twitter simulator in elixir with web interface written in HTML and JS.

### Please check the video demo of the functionalities (https://youtu.be/zZnRoKCYuj8)

### Group Members
1.   Madhav Sodhani       :     1988-9109 
2.   Vaibhav Mohan Sahay  :     5454-1830

### Steps to run the project:

To start your Phoenix server:
  * unzip the project and `cd twitter-simulator`
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd twitter-simulator/apps/twitter_simulator_web/assets` followed by `npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to view the web interface.
  * Create a user from the given form and login.
  * Create another user from a new browser session and follow the logged in user. If the logged in user posts a tweet, the subscriber would see it in his feed with the timestamp.


### Implemented Functionalities

Implemented all the listed functionalities in a simulation for 100 users when the application starts.
The simulation registers 100 users which post tweets with hashtags and mentions. All the functionalities can also be accessed using the web interface.
Please check the video demo of the functionalities https://youtu.be/zZnRoKCYuj8 

1. User Registration
2. User Login
3. Post tweet by a user
4. Follow another user and subscibe to his tweets
5. Retweet a tweet made by another user
6. View the tweets of a subscribed user real-time.
7. Post Tweets with hashtags and mentions.
8. Query the tweets with the hashtags.
9. Query tweets having the user's mentions.
10. Logout User

### Implementation Details

The web user interface has been implemented using HTML, Javascript and frameworks like Bootstrap and JQuery.
The backend and the server which was developed in 4.1 is being reused and integrated with the UI using Phoenix Channels.
The project is an Umbrella Project which contains the codebase for project 4.1 and the newly developed Web Interface.
On starting the Phoenix Server, it would first start the backend server which has the business logic and the in-memory tables. This would initialize all the tables.
It would then start the web interface project which can be accessed by opening the URL localhost:4000 in your browser.

The user can create an account and login into it which will open the user dashboard. The user can then post a new tweet or retweet a tweet from one of his subscribed users.
The user can then follow other users by inputting the username and clicking on follow button.
The querying can be done based on hashtag and the tweets with the given hashtag will be populated in the table in the sidepane.