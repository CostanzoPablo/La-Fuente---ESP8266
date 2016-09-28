gpio.mode(3, gpio.OUTPUT)
gpio.mode(4, gpio.OUTPUT)
gpio.write(3, gpio.HIGH);
gpio.write(4, gpio.HIGH);

questions = {"De cinco futbolistas, donde ninguno tiene la misma cantidad de goles convertidos, se sabe que Claudio tiene dos goles más que Abel, Flavio tiene dos goles más que Roberto, pero uno menos que Abel y Ándres más goles que Roberto, pero menos que Abel. ¿Cuántos goles menos que Claudio tiene Ándres?", "Cuantos continentes tiene el mundo ?", 
"En una caja, se tiene 200 canicas de color verde, 200 de color rojo, 200 de color azul, 200 de color  negro y 250 de color amarillo. ¿Cuál es el  menor número de canicas que se debe extraer al azar para  tener, con certeza, al menos 100 canicas del mismo color?", 
"Se tiene tres ciudades M, N y P. Un empresario que viaja en avión, cuando va de M hacia N tiene que atrasar su reloj 2 horas al llegar a N y cuando va de M hacia P debe adelantarlo 3 horas al llegar a P. Si sale de P hacia N, a las 11 p.m. y el viaje dura 4 horas, ¿qué hora es en N cuando llega?", 
"Juan es el doble de rápido que Ángel y este dos veces más rápido que Omar. Para realizar una obra trabajaron durante 3 horas al término de las cuales se retira Omary los otros culminan la Obra en 5 horas más de trabajo. ¿Cuántas horas emplearía Omar en realizar 1/3 de la Obra?", 
"Se compran tres manzanas por $10 y se venden cinco manzanas por $20, ¿Cuántas manzanas se deben vender para ganar $150?", 
"Lucía fue al médico, éste le recetó tomar 4 pastillas, una pastilla cada 6 horas, ¿En qué tiempo podrá terminar de tomar todas las pastillas?",
"Si dos estudiantes pueden resolver 2 preguntas en 2 minutos, ¿Cuántos estudiantes se necesitarán para resolver 4 preguntas en 4 minutos?",
"En una ferretería tienen un stock de 84m de alambre, y diario cortan 7m. ¿En cuántos días habrán cortado todo el alambre?",
"En  una  habitación  hay  11  pelotas  amarillas,  13  azules  y  17 verdes. Si se le pide a un ciego sacar las pelotas, ¿cuál es el mínimo número de pelotas que debe extraer para que obtenga con total seguridad 11 pelotas del mismo color?",
"En una caja grande hay 6 cajas dentro de cada una de estas cajas hay 3 cajas, dentro de estas hay 2  cajas. ¿Cuántas cajas hay en total?",
"Un sapo se dirige dando saltos desde el punto A hacia el punto B, distantes entre sí 100 cm. Si entre ambos puntos está el punto C a 12.5 cm de B, ¿con cuántos saltos llegará a C, si en cada salto avanza la mitad de la distancia que le falta para llegar a B?",
"Si una ficha roja equivale a 3 azules y cada azul equivale a 2 blancas, ¿a cuánto equivaldrán 120 blancas?",
"Si en el  producto  indicado  27x36, cada factor aumenta  en  4  unidades; ¿Cuánto aumenta el producto original?",
"Un turista alquila un auto a $30 diarios y adicionalmente abona $ 0,1 por km recorrido. El auto le rinde 35 km por galón en la ciudad y 50 km por galón en carretera, a un costo de $3,5 por galón. Si en una semana lo que recorre en carretera es 5 veces lo recorrido en ciudad, calcule el costo total en  dólares, del alquiler del auto en dicha semana al cabo de la cual se recorrió 600 km en total.",
"Paco llena un vaso con vino y bebe una cuarta parte del contenido; vuelve a llenarlo, esta vez con agua, y bebe una tercera parte de la mezcla; finalmente, lo llena nuevamente con agua y bebe la mitad del contenido del vaso. Si la capacidad del vaso es de 200mL, ¿qué cantidad (en ml) de vino queda finalmente en el vaso?",
"Roberto es el único hijo del abuelo de Javier, y Rosario es la única nuera del abuelo de Roberto. Si el hijo único de Javier tiene cinco años y de una generación a otra consecutiva transcurren 20 años, ¿cuál es la suma de las edades del abuelo y bisabuelo de Javier?",
"María califica 25 exámenes por hora y Rosa 20 exámenes por hora. Cada una tiene que calificar 500 exámenes. Si María terminó de calificar. ¿Cuántos exámenes le faltan por calificar a Rosa?",
"¿Cuántos árboles hay en un campo triangular que tiene 10 árboles en cada lado y un árbol en cada esquina?",
"Se desea colocar postes igualmente espaciados en el perímetro de un terreno rectangular de 280 m de largo por 120 m de ancho. Si se sabe que debe colocarse un poste en cada esquina y el número de postes debe ser el menor posible, determínese el número total de postes por colocar.",
"Con tres frutas diferentes: papaya, pera y piña. ¿Cuántos sabores diferentes de jugo se podrá preparar con estas frutas?",
"Se tiene una colección de 7 tomos de libros de 700 páginas cada uno. Si cada tapa tiene un espesor de 0.25cm, y las hojas por cada tomo, un espesor de 4cm, ¿Cuántos cm recorrerá una polilla que se encuentra en la primera página del primer tomo a la última página del último tomo?",
}
answers = {"4", "496", "10", "25", "225", "18", "4", "11", "31", "61", "3", "20", "268", "315", "50", "150", "100", "27", "20", "7", "31"}

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
        buf = buf.."<p>Pregunta: <input name=\"question\" type=\"text\" value=\""..newQuestion.."\" hidden=\"hidden\">"..questions[newQuestion].."</p>";
        buf = buf.."<p>Respuesta: <input name=\"answer\" type=\"number\" value=\"\"></p>";
        buf = buf.."<input type=\"submit\" value=\"RESPONDER\">";
        buf = buf.."</form>";        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
