--------------------------------------------------------
-- Utility functions.                                 --
--------------------------------------------------------

local function bitwise_op(op_name)
    return function(...)
        local n = select("#", ...)
        local chunk
        -- Bitwise exclusive OR and bitwise NOT have the same
        -- operator.
        if (op_name == "&" or op_name == "|") then
            assert(n > 1)
        end
        if n == 1 then
            local x = ...
            chunk = ("return %s %d"):format(op_name, x)
        else
            local op_name_ws = (" %s "):format(op_name)
            chunk = "return " .. table.concat({...}, op_name_ws)
        end
        return assert(load(chunk))()
    end
end

local band = bitwise_op("&")

local ms = {}

-- Generates a random integer for an arbitrary table.
-- @param t table
function ms.table_to_int(t)
  local acc = 0
  for i, v in ipairs(t) do
    if type(v) == "number" then
      acc = acc + v
    else
      acc = band(acc, i)
    end
  end
  return acc + #t
end
