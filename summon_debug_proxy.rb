require 'sinatra'
require 'cgi'
require 'httpclient'

SUMMON_BASE_URL = ENV["SUMMON_BASE_URL"] || "http://api.summon.serialssolutions.com/2.0.0/search"
 


get "/search.?:format?" do
  client = HTTPClient.new

  # We need to use CGI::parse rather than
  # sinatra/rack's own query parsing, cause
  # we need multiple values with same key etc. 
  parsed_params = CGI::parse(request.query_string)


  headers = Summon::Transport::Headers.new(
    :access_id  => ENV["SUMMON_ACCESS_ID"],
    :secret_key => ENV["SUMMON_SECRET_KEY"],
    :accept     => "json",
    :params     => parsed_params,
    :url        => SUMMON_BASE_URL
  )

  uri = "#{SUMMON_BASE_URL}?#{query_string(parsed_params)}"

  response = client.get(uri, nil, headers) 
  status response.status


  if status != 200
    return response.body
  end

  if params["format"] == "html"
   return <<-EOS
    <html>
      <head>
        <link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/github.min.css">
        <script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
        <script>hljs.initHighlightingOnLoad();</script>
      </head>
      <body>
        <pre><code class="JSON">
#{JSON.pretty_generate( JSON.parse response.body ) }
        </pre></code>
      </body>

    </html>

   EOS

    #return "<pre>" + JSON.pretty_generate(  JSON.parse(response.body)  ) + "</pre>"
  else
    content_type( response.headers["Content-Type"])
    return response.body
  end
end


def query_string(hash)
  query_string = hash.keys.collect do |key|
    [hash[key]].flatten.collect do |value|
      "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
    end
  end.flatten.join("&")
end
