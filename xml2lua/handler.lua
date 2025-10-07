local xmljsontransformer = {
    PRIORITY = 1010, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.9",
  }
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local parser = xml2lua.parser(handler)
local cjson = require "cjson"

-- How to convert XML to JSON and otherwise


function xmljsontransformer:header_filter(config)
  kong.response.set_header("Content-Type", "application/xml")

  kong.response.clear_header("content-length")
end

-- Convert XML to JSON
function xmljsontransformer:access(config)
	kong.service.request.enable_buffering()
end

local function table_to_xml(tbl, tag_name)
  local xml = ""
  tag_name = tag_name or "root"

  xml = xml .. "<" .. tag_name .. ">"
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      xml = xml .. table_to_xml(v, k)
    else
      xml = xml .. string.format("<%s>%s</%s>", k, v, k)
    end
  end
  xml = xml .. "</" .. tag_name .. ">"
  return xml
end

-- Convert JSON to XML
function xmljsontransformer:body_filter(config)
  -- get json from stream services.
  local response_body = kong.service.response.get_raw_body()
  local json2lua = cjson.decode(response_body)
  local xml_result = table_to_xml(json2lua, "response")
  print(xml_result)
  kong.response.set_raw_body(xml_result)
end


return xmljsontransformer


