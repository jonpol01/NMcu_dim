MAX_TIME = 2
led3 = 12
tmr.alarm(0, 5000, 1, function()
  timer = timer + 1
  if (timer >= MAX_TIME) then
    --timer interval gone
   --DO here what you want
    ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
    tmr.stop(0)
    timer = 0
  end
end)