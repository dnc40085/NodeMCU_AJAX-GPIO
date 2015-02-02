start_init = function() 
gpio.mode(3, gpio.OUTPUT); 
gpio.mode(4, gpio.OUTPUT); 
gpio.write(3,gpio.LOW); 
gpio.write(4,gpio.LOW); 
gpio2_state=0; 
gpio0_state=0; 
wifi.setmode(wifi.STATION); 
wifi.sta.config("your SSID","your PASSWORD"); 
end 
 
sendFileContents = function(conn, filename) 
    if file.open(filename, "r") then 
        --conn:send(responseHeader("200 OK","text/html")); 
        repeat  
        local line=file.readline()  
        if line then  
            conn:send(line); 
        end  
        until not line  
        file.close(); 
    else 
        conn:send(responseHeader("404 Not Found","text/html")); 
        conn:send("Page not found"); 
            end 
end 
 
responseHeader = function(code, type) 
    return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n";  
end 
 
httpserver = function () 
    start_init(); 
 srv=net.createServer(net.TCP)  
    srv:listen(80,function(conn)  
      conn:on("receive",function(conn,request)  
        conn:send(responseHeader("200 OK","text/html")); 
        if string.find(request,"gpio=0") then 
            if gpio0_state==0 then 
                gpio0_state=1; 
                gpio.write(3,gpio.HIGH); 
            else 
                gpio0_state=0; 
                gpio.write(3,gpio.LOW); 
            end 
        elseif string.find(request,"gpio=2") then 
            if gpio2_state==0 then 
                gpio2_state=1; 
                gpio.write(4,gpio.HIGH); 
            else 
                gpio2_state=0; 
                gpio.write(4,gpio.LOW); 
            end 
        else 
            if gpio0_state==0 then 
                preset0_on=""; 
            end 
            if gpio0_state==1 then 
                preset0_on="checked=\"checked\""; 
            end 
            if gpio2_state==0 then 
                preset2_on=""; 
            end 
            if gpio2_state==1 then 
                preset2_on="checked=\"checked\""; 
            end 
            sendFileContents(conn,"header.htm"); 
            conn:send("<div><input type=\"checkbox\" id=\"checkbox0\" name=\"checkbox0\" class=\"switch\" onclick=\"loadXMLDoc(0)\" "..preset0_on.." />"); 
            conn:send("<label for=\"checkbox0\">GPIO 0</label></div>"); 
            conn:send("<div><input type=\"checkbox\" id=\"checkbox2\" name=\"checkbox2\" class=\"switch\" onclick=\"loadXMLDoc(2)\" "..preset2_on.." />"); 
            conn:send("<label for=\"checkbox2\">GPIO 2</label></div>"); 
            conn:send("</div>"); 
        end 
        print(request); 
      end)  
      conn:on("sent",function(conn)  
        conn:close();  
        conn = nil;     
 
      end) 
    end) 
end 
 
httpserver()