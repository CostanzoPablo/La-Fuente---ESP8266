gpio.mode(3, gpio.OUTPUT)
gpio.mode(4, gpio.OUTPUT)
gpio.write(3, gpio.HIGH);
gpio.write(4, gpio.HIGH);

questions = {"a", "b", "c", "d", "e", "f", "g"}
answers = {"100", "200", "300", "400", "500", "600", "700"}

local waiter=0;
local question = nil;
local answer = nil;
local newQuestion = nil;

cfg={}
cfg.ssid="La Fuente - ESP8266";
cfg.pwd="12345678";
wifi.ap.config(cfg);

cfg={}
cfg.ip="192.168.4.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.1.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)

print("Waiting for IP")
ip = wifi.sta.getip()

tmr.alarm(1,5000, 1, function() if wifi.ap.getip()==nil then print(" Wait to IP address!") else print("New IP address is "..wifi.ap.getip()) tmr.stop(1) end end)

if srv~=nil then
    srv:close()
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                if (k == "question")then
                        print(k..": "..v);
                        question = v;
                end
                if (k == "answer")then
                        print(k..": "..v);
                        answer = v;
                end
            end
        end

        if (question ~= nil) then
            print(question);
            print(answers[tonumber(question)]);
            if (answers[tonumber(question)] == answer) then
                tmr.alarm(1,1000, 1, function() if waiter<=3 then gpio.write(3, gpio.LOW); waiter = waiter + 1; else gpio.write(3, gpio.HIGH); waiter = 0; tmr.stop(1) end end)
            else
                tmr.alarm(1,1000, 1, function() if waiter<=3 then gpio.write(4, gpio.LOW); waiter = waiter + 1; else gpio.write(4, gpio.HIGH); waiter = 0; tmr.stop(1) end end)
            end
        end
        
        newQuestion = math.random(table.getn(questions))
        buf = buf.."<h1> LA FUENTE </h1>";
        buf = buf.."<form method=\"get\" action=\"\">";
        buf = buf.."<p>Pregunta: <input name=\"question\" type=\"text\" value=\""..newQuestion.."\">"..questions[newQuestion].."</p>";
        buf = buf.."<p>Respuesta: <input name=\"answer\" type=\"text\" value=\"\"></p>";
        buf = buf.."<input type=\"submit\" value=\"RESPONDER\">";
        buf = buf.."</form>";        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
