tmr.delay(50000) -- this delay is to give NodeMCU a chance to finish printing it's version info
uart.setup(0,9600,8,0,1,1);
if file.open("LLbin.lua") then --This part is for LuaLoader v0.83 it can be erased with no problem
	LLbin = function(F) dofile("LLbin.lua"); LLbin(F); end; 
end;
if true then  --If false, script ends here
wifi.setmode(wifi.STATION);
wifi.sta.config("YOUR SSID","YOUR PASSWORD")
count=0
wait_wifi = function()
count = count + 1
wifi_ip = wifi.sta.getip()
if wifi_ip == nil and count < 20 then
tmr.alarm(0, 1000,0,wait_wifi)
elseif count >= 20 then
wifi_connected = false
print("Wifi connect timed out.")
else
wifi_connected = true
print("Got IP "..wifi_ip.."\n")
collectgarbage()
if file.open("main.lua") then dofile("main.lua"); print("\nReady!\r\n") else print("main.lua not present"); print("\nReady!"); end
wait_wifi=nil
init=nil
count=nil
end
end
wait_wifi()
else
print("\nReady!\r\n")
 end
collectgarbage()