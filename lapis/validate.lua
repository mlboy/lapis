local insert = table.insert
local validate_functions = {
  exists = function(input)
    return input and input ~= "", "%s must be provided"
  end,
  file_exists = function(input)
    return type(input) == "table" and input.filename ~= "" and input.content ~= ""
  end,
  min_length = function(input, len)
    return #tostring(input or "") >= len, "%s must be at least " .. tostring(len) .. " chars"
  end,
  max_length = function(input, len)
    return #tostring(input or "") <= len, "%s must be at most " .. tostring(len) .. " chars"
  end,
  is_integer = function(input)
    return tostring(input):match("^%d+$"), "%s must be an integer"
  end,
  equals = function(input, value)
    return input == value, "%s must match"
  end
}
local test_input
test_input = function(input, func, args)
  local fn = assert(validate_functions[func], "Missing validation function " .. tostring(func))
  if type(args) ~= "table" then
    args = {
      args
    }
  end
  return fn(input, unpack(args))
end
local validate
validate = function(object, validations)
  local errors = { }
  local _list_0 = validations
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
    local key = v[1]
    local input = object[key]
    for fn, args in pairs(v) do
      local _continue_0 = false
      repeat
        if not (type(fn) == "string") then
          _continue_0 = true
          break
        end
        local success, msg = test_input(input, fn, args)
        if not (success) then
          insert(errors, msg:format(key))
          break
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
  end
  return next(errors) and errors
end
if ... == "test" then
  require("moon")
  local o = {
    age = "",
    name = "abc",
    height = "12234234"
  }
  moon.p(validate(o, {
    {
      "age",
      exists = true
    },
    {
      "name",
      exists = true
    }
  }))
  moon.p(validate(o, {
    {
      "name",
      exists = true,
      min_length = 4
    },
    {
      "age",
      min_length = 4
    },
    {
      "height",
      max_length = 5
    }
  }))
  moon.p(validate(o, {
    {
      "height",
      is_integer = true
    },
    {
      "name",
      is_integer = true
    },
    {
      "age",
      is_integer = true
    }
  }))
  moon.p(validate(o, {
    {
      "height",
      min_length = 4
    }
  }))
end
return {
  validate = validate,
  test_input = test_input
}
