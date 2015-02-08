Output_T = {[2]=false,[0]=false}; --[GPIO]=State(true=OGPIO_T = {[2]=false,[0]=false}; --[GPIO]=State(true=ON|false=OFF)
G2P_T = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=2,[5]=1,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}; -- table to convert gpio to pin

GPIOToPin = function(GPIO)
return (G2P_T[GPIO])
end
gpio_write = function (GPIOPIN, GPIO_state)
		PIN=GPIOToPin(GPIOPIN)
		statehold = ((GPIO_state) and 1 or 0);
		gpio.write(PIN,statehold);
		return (not GPIO_state)
	end
	
for k,v in pairs(Output_T) do 
	gpio.mode(GPIOToPin(k), gpio.OUTPUT);
	gpio.write(k, ((not Output_T[k]) and 1 or 0));
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
			conn:send("The file was not found!"); 
		end
		collectgarbage()
	end 
 
responseHeader = function(code, type) 
		return "HTTP/1.1 " .. code .. "\r\nConnection: close\r\nServer: nunu-Luaweb\r\nContent-Type: " .. type .. "\r\n\r\n";
		end 


httpserver = function () 
	srv=net.createServer(net.TCP)
	srv:listen(80,function(conn)
		conn:on("receive",function(conn,request)
			request=string.match(request, "GET%s+/.+HTTP/")
			print("\nHTTP Request: ");
			print(request);
			
			if string.find(request, "GET / ") then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn,"header.htm"); 
			elseif string.find(request,"gpio=%d+") then 
				t=tonumber(string.match((string.match(request, "gpio=%d+ ")), "%d+"));
				Output_T[t]=gpio_write((t),Output_T[t]); 
				conn:send("HTTP/1.1 204 No Content\r\n\r\n");
			elseif string.find(request,"/GetJSON") then 
				generateJSON = function(INPUT,KEY,VALUE)
					BN=function(A) if ((A==true) or (A==false)) then return ((A) and 1 or 0); else return A; end end; --boolean or number test 
					JS=nil;
					for k,v in pairs(INPUT) do 
						if JS==nil then 
							JS="[{\""..KEY.."\":\""..k.."\",\""..VALUE.."\":"..BN(INPUT[k]).."}" ;
						else 
							JS=JS .. ",{\""..KEY.."\":\""..k.."\",\""..VALUE.."\":"..BN(INPUT[k]).."}" 
						end
					end
					JS=JS .. "]";
					return JS
				end
				conn:send(responseHeader("200 OK","application/json\r\nAccess-Control-Allow-Origin: *"));
				conn:send(generateJSON(Output_T,"gpio","state"));
			elseif file.open(string.match(string.match(request, "GET%s+/.+%s+HTTP/"), "%w+%.%w+")) then
				conn:send(responseHeader("200 OK","Content-Type: text/html"));
				sendFileContents(conn, string.match(string.match(request, "GET%s+/.+%s+HTTP/"), "%w+%.%w+")); 
			else
				conn:send("HTTP/1.1 404 Not Found\r\n\r\n"); 
			end
			collectgarbage()
		end)
		conn:on("sent",function(conn)
			conn:close();
			conn = nil;
			collectgarbage()
		end)
		collectgarbage()
	end)
end 
 
httpserver()
httpserver=nil;
collectgarbage()
