-- Test for character searches

local n = require('test.functional.testnvim')()

local feed, insert = n.feed, n.insert
local clear, feed_command, expect = n.clear, n.feed_command, n.expect

describe('charsearch', function()
  setup(clear)

  it('is working', function()
    insert([[
      Xabcdefghijkemnopqretuvwxyz
      Yabcdefghijkemnopqretuvwxyz
      Zabcdefghijkemnokqretkvwxyz]])

    -- Check that "fe" and ";" work.
    feed_command('/^X')
    feed('ylfep;;p,,p')
    -- Check that save/restore works.
    feed_command('/^Y')
    feed('ylfep')
    feed_command('let csave = getcharsearch()')
    feed('fip')
    feed_command('call setcharsearch(csave)')
    feed(';p;p')
    -- Check that setcharsearch() changes the settings.
    feed_command('/^Z')
    feed('ylfep')
    feed_command("call setcharsearch({'char': 'k'})")
    feed(';p')
    feed_command("call setcharsearch({'forward': 0})")
    feed('$;p')
    feed_command("call setcharsearch({'until': 1})")
    feed(';;p')

    -- Assert buffer contents.
    expect([[
      XabcdeXfghijkeXmnopqreXtuvwxyz
      YabcdeYfghiYjkeYmnopqreYtuvwxyz
      ZabcdeZfghijkZZemnokqretkZvwxyz]])
  end)
end)
