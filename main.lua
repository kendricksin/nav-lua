local http = require('http')
local fs = require('fs')

-- Function to parse the CSV file
local function parseCSV(data)
  local rows = {}
  for line in data:gmatch("[^\r\n]+") do
    local row = {}
    for cell in line:gmatch("[^,]+") do
      table.insert(row, cell)
    end
    table.insert(rows, row)
  end
  return rows
end

-- Function to generate the HTML table
local function generateTable(data)
  local tableHTML = [[
    <table>
      <tr>
        <th>Distance</th>
        <th>Mark1</th>
        <th>Mark2</th>
        <th>Mark3</th>
        <th>Mark4</th>
      </tr>
  ]]
  for _, row in ipairs(data) do
    tableHTML = tableHTML .. "<tr>"
    for _, cell in ipairs(row) do
      tableHTML = tableHTML .. "<td>" .. cell .. "</td>"
    end
    tableHTML = tableHTML .. "</tr>"
  end
  tableHTML = tableHTML .. "</table>"
  return tableHTML
end

-- HTTP request handler
local function onRequest(req, res)
  fs.readFile('data.csv', function(err, data)
    if err then
      res:writeHead(500, {["Content-Type"] = "text/plain"})
      res:write("500 Internal Server Error\n")
      res:finish()
      return
    end

    local parsedData = parseCSV(data)

    local tableHTML = generateTable(parsedData)

    fs.readFile('index.html', function(err, data)
      if err then
        res:writeHead(500, {["Content-Type"] = "text/plain"})
        res:write("500 Internal Server Error\n")
        res:finish()
        return
      end

      local htmlContent = data:gsub("{{table}}", tableHTML)
      res:writeHead(200, {["Content-Type"] = "text/html"})
      res:write(htmlContent)
      res:finish()
    end)
  end)
end

local server = http.createServer(onRequest)
server:listen(8080)

print("Server listening on http://localhost:8080/")
