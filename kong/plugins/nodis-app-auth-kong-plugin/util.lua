_M = {}

--- Finds an element in a table by its value.
-- This is not guaranteed to return the first match on array tables.
-- @param haystack table to search
-- @param needle value to search for
-- @return the key of the element in the table, or nil if not found
function _M.table_find(haystack, needle)
  for k, v in pairs(haystack) do
    if v == needle then
      return k
    end
  end
  return nil
end


function _M.table_find_pattern(haystack, needle)
  for k, v in pairs(haystack) do
    local isMatching = not (string.find(ngx.var.uri, pattern) == nil)
    if (isMatching) then return true end
  end

  return false
end

return _M
