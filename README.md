When developing against the [Serials Solutions Summon search API](http://api.summon.serialssolutions.com/help/api/search), as with many HTTP apis, 
it can be convenient to interact directly with the API Server, in an iterative interaction fashion. 
Say, in your browser.

However, the Summon API's auth requirements (involving crypto-calculated headers) make this
inconvenient in a browser. 

The Summon [docs have an embedded sort of 'console' app](http://api.summon.serialssolutions.com/help/api/search/example?s.q=foo)
that at first looks convenient for this -- but turns out it's got a number of bugs,
at least at the time I write this (June 20 2013). For instance, it refuses to recognize more than
one query param with the same key, even though Summon API uses this convention. 

So here's a dirt simple bare-bones ruby Sinatra app that will be a sort of 'proxy'
for testing the Summon API, taking care of the auth headers for you. You can 
run it on linux or osx if you have ruby 1.9.3+ installed, dunno about Windows. It probably
has bugs at the edges, and could use some more features. Patches welcome. 

git clone then...

~~~bash
# Need your Summon api keys in environment variables
$ export SUMMON_ACCESS_ID=your_access_id
$ export SUMMON_SECRET_KEY=your_secret_key

$ cd summon_demo_proxy
$ bundle install
$ rackup -p 3000 # port starts on port 3000
~~~

Now visit `http://your.server.tld:3000/search?s.q=foo`. Add whatever Summon API strings you want
after the ? mark.  You'll get back raw JSON. 

Or change to `/search.html?` to get pretty-printed JSON embedded in an HTML pre tag. 

**NOTE WELL** Do not put this on the public web unless you've protected it behind
a firewall and/or password protection, or you've exposed a backdoor into your
Summon API access to anyone on the internet, skipping auth! 

**Note also** You can also easily deploy this app in a more permanent way
using Phusion Passneger, same as any rack app.  Don't forget to set the Summon api
key env variables so Passenger picks up em, google the passenger docs. 
