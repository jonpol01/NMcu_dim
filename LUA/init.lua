wifi.setmode(wifi.STATION)
wifi.sta.config("pr500k-0db676-1","fb2a0508c4a95")
print(wifi.sta.getip())
led1 = 4
led2 = 7
led3 = 12
led4 = 3
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<body>";
        buf = buf.."<h1> Project s1</h1>";
--        buf = buf.."<p>GPIO13 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
--        buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO11 <a href=\"?pin=ON3\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF3\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO12 <a href=\"?pin=ON4\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF4\"><button>OFF</button></a></p>";
--        buf = buf.."<p>SET LED <a href=\"?set=amountRange.value\"><button>SET</button></a>&nbsp;";
        --buf = buf.."<input type='range' id='myRange' value='90'>";
        buf = buf.."<form>";
        buf = buf.."<input type='range' name='amountRange' min='0' max='255' value='0' oninput='this.form.amountInput.value=this.value' />";
        buf = buf.."<input type='number' name='amountInput' min='0' max='255' value='0' oninput='this.form.amountRange.value=this.value' />";
        buf = buf.."</form>";
        buf = buf.."</body>";

        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.LOW);
        elseif(_GET.pin == "ON2")then
              gpio.write(led2, gpio.HIGH);
        elseif(_GET.pin == "OFF2")then
              gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "ON3")then
              ws2812.writergb(led3, string.char(255, 0, 100):rep(7))
        elseif(_GET.pin == "OFF3")then
              ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
        elseif(_GET.pin == "ON4")then
              ws2812.writergb(led4, string.char(255, 0, 200):rep(2))
        elseif(_GET.pin == "OFF4")then
              ws2812.writergb(led4, string.char(0, 0, 0):rep(2))
        end

        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)

MAX_TIME = 4
timer = 0
led_flg = 0
r_led = 250
g_led = 125
b_led = 10
tmr.alarm(0, 1000, 1, function()

  timer = timer + 1

  if (r_led < 10) then
    r_led = 250
  elseif (g_led < 10) then
    g_led = 125
  elseif (b_led > 100) then
    b_led = 0
  end

  if (timer >= MAX_TIME) then
    if (led_flg == 1) then
        ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
        ws2812.writergb(led4, string.char(0, 0, 0):rep(7))
        ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
        ws2812.writergb(led4, string.char(0, 0, 0):rep(7))
        ws2812.writergb(led3, string.char(r_led, g_led, b_led):rep(7))
        ws2812.writergb(led4, string.char(r_led, g_led, b_led):rep(2))
        ws2812.writergb(led3, string.char(r_led, g_led, b_led):rep(7))
        ws2812.writergb(led4, string.char(r_led, g_led, b_led):rep(2))

        led_flg = 0
    else
        r_led = r_led - 5
        g_led = g_led - 5
        b_led = b_led + 1
--        ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
--        ws2812.writergb(led3, string.char(0, 0, 0):rep(7))
        led_flg = 1
    end
--    tmr.stop(0)
    timer = 0
  end

end)