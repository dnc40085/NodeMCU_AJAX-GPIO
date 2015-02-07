	gpio_write = function (GPIO_pin, GPIO_state)
		statehold = ((not GPIO_state) and 1 or 0);
		gpio.write(GPIO_pin,statehold);
		return (not GPIO_state)
	end
	GPIOInit = function()
	gpio.mode(3, gpio.OUTPUT);
	gpio.mode(4, gpio.OUTPUT);
	gpio0_state=false; gpio0_state=gpio_write(3,gpio0_state);
	gpio2_state=false; gpio2_state=gpio_write(4,gpio2_state);
	end

	sendFileContents = function(conn, filename)
		if file.open(filename, "r") then 
			repeat
				local line=file.readline()
				if line then
				conn:send(line); 
				end
			until not line
			file.close(); 
		else 
			conn:send("The htm file was not found!"); 
		end
	end 
 
	responseHeader = function(code, type) 
		return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n";
		end 

	httpserver = function () 
	GPIOInit();
	GPIOInit = nil;

	
	srv=net.createServer(net.TCP)
	srv:listen(80,function(conn)
		conn:on("receive",function(conn,request)
			print(request);
			if string.find(request,"gpio=0") then 
				gpio0_state=gpio_write(3,gpio0_state);
				conn:send("HTTP/1.1 204 No Content\r\n\r\n");
			elseif string.find(request,"gpio=2") then 
				conn:send("HTTP/1.1 204 No Content\r\n\r\n");
				gpio2_state=gpio_write(4,gpio2_state); 
			elseif string.find(request,"GET /GetJSON") then 
				conn:send(responseHeader("200 OK","application/json\r\nAccess-Control-Allow-Origin: *"));
				JS="[";
				JS=JS .. "{\"gpio\":\"0\",\"state\":" .. ((not gpio0_state) and 1 or 0) .. "}" .. ",";
				JS=JS .. "{\"gpio\":\"2\",\"state\":" .. ((not gpio2_state) and 1 or 0) .. "}" .. "]";
				conn:send(JS);
			
			elseif string.find(request,"GET / ") then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn,"header.htm"); 
			elseif string.find(request,"GET /ajaxgpio.htm ") then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn,"ajaxgpio.htm"); 
			elseif string.find(request,"GET /ajaxgpio.css ") then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn,"ajaxgpio.css"); 
			elseif string.find(request,"GET /ajaxgpio.js ") then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn,"ajaxgpio.js"); 
			else
				conn:send("HTTP/1.1 404 Not Found\r\n\r\n"); 
			end
		
		end)
		conn:on("sent",function(conn)
			conn:close();
			conn = nil;
			
		end)
		
	end)
end 
 
httpserver()
