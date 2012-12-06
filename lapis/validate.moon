
import insert from table

validate_functions = {
  exists: (input) ->
    input and input != "", "%s must be provided"

  file_exists: (input) ->
    type(input) == "table" and input.filename != "" and input.content != ""

  min_length: (input, len) ->
    #tostring(input or "") >= len, "%s must be at least #{len} chars"

  max_length: (input, len) ->
    #tostring(input or "") <= len, "%s must be at most #{len} chars"

  is_integer: (input) ->
    tostring(input)\match"^%d+$", "%s must be an integer"

  equals: (input, value) ->
    input == value, "%s must match"
}

test_input = (input, func, args) ->
  fn = assert validate_functions[func], "Missing validation function #{func}"
  args = {args} if type(args) != "table"
  fn input, unpack args

validate = (object, validations) ->
  errors = {}
  for v in *validations
    key = v[1]
    input = object[key]

    for fn, args in pairs v
      continue unless type(fn) == "string"
      success, msg = test_input input, fn, args
      unless success
        insert errors, msg\format key
        break

  next(errors) and errors


if ... == "test"
  require "moon"

  o = {
    age: ""
    name: "abc"
    height: "12234234"
  }

  moon.p validate o, {
    { "age", exists: true }
    { "name", exists: true }
  }

  moon.p validate o, {
    { "name", exists: true, min_length: 4 }
    { "age", min_length: 4 }
    { "height", max_length: 5 }
  }

  moon.p validate o, {
    { "height", is_integer: true }
    { "name", is_integer: true }
    { "age", is_integer: true }
  }


  moon.p validate o, {
    { "height", min_length: 4 }
  }


{ :validate, :test_input }
