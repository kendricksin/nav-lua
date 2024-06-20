local http = require('http')
local fs = require('fs')

local function onRequest(req, res)
  fs.readFile('index.html', function (err, data)
    if err then
      res:writeHead(500, {["Content-Type"] = "text/plain"})
      res:write("500 Internal Server Error\n")
      res:finish()
      return
    end

    res:writeHead(200, {["Content-Type"] = "text/html"})
    res:write(data)
    res:finish()
  end)
end

local server = http.createServer(onRequest)
server:listen(8080)

print("Server listening on http://localhost:8080/")
