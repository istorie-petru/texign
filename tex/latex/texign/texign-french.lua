-- French spacing, for text in the French language only: the space usually
-- typed before ; ! ? becomes a thin unbreakable space, the one before : and
-- » and after « becomes unbreakable.
local GLUE, GLYPH = node.id("glue"), node.id("glyph")
local CLOSE_THIN = { [59] = true, [33] = true, [63] = true } -- ; ! ?
local CLOSE = { [58] = true, [187] = true }                  -- : »
local OPEN = 171                                             -- «
local lang = texign_french_language

local function nobreak(head, before)
  local p = node.new("penalty")
  p.penalty = 10000
  return node.insert_before(head, before, p)
end

local function spacing(head)
  local n = head
  while n do
    local nxt = n.next
    if n.id == GLUE and nxt and n.prev then
      local a, b = n.prev, nxt
      if b.id == GLYPH and b.lang == lang and (CLOSE_THIN[b.char] or CLOSE[b.char]) then
        head = nobreak(head, n)
        if CLOSE_THIN[b.char] then
          node.setglue(n, font.getfont(b.font).size // 8, 0, 0)
        end
      elseif a.id == GLYPH and a.lang == lang and a.char == OPEN then
        head = nobreak(head, n)
      end
    end
    n = nxt
  end
  return head
end

luatexbase.add_to_callback("pre_linebreak_filter", spacing, "texign.french")
