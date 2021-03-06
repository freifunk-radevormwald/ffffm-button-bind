local uci = luci.model.uci.cursor()

local f, s, o, fct

f = SimpleForm('button-bind', "Taster")
f.template = 'admin/expertmode'
s = f:section(SimpleSection, nil, "Hier können dem Router-Taster unterschiedliche Funktionalitäten zugeordnet werden.")

fct = uci:get('button-bind', 'wifi', 'function')
if not fct then
	fct='0'
	uci:set('button-bind', 'wifi', 'button')
	uci:set('button-bind', 'wifi', 'function', fct)
	uci:commit('button-bind')
end
o = s:option(ListValue, "wifi", "Wifi ON/OFF Taster")
o.default = fct
o.widget = "radio"
o.rmempty = false
o:value('0', "Wifi an/aus")
o:value('1', "Funktionslos (default)")
o:value('2', "Wifi-Reset")
o:value('3', "alle Status-LEDs an/aus (Nachtmodus 1)")
o:value('4', "LEDs aus, an beim Drücken (Nachtmodus 2)")
o:value('5', "Client-Netz an/aus")
o:value('6', "Mesh-VPN aus für 5 Stunden")

function f.handle(self, state, data)
	if state == FORM_VALID then
		uci:set('button-bind', 'wifi', 'function', data.wifi)
		uci:commit('button-bind')
	end
end

return f
