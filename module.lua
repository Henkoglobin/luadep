-- luadep.util.lua
-- 
-- Provides utility functions

local module = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

module.__index = module

function module.new(mod)
	local temp = {
		module = mod,
		interfaces = {},
		dependencies = {},
		inject = function(self, interface, module, allowMultiple)
			if allowMultiple then
				if self.module[interface] == nil then
					self.module[interface] = {}
				end

				table.insert(self.module[interface], module)
			else
				self.module[interface] = module
			end
		end
	}
	
	return setmetatable(temp, module)
end

function module:isA(interfaceName)
	table.insert(self.interfaces, interfaceName)

	return self
end

function module:dependsOn(interfaceName, multiple)
	table.insert(self.dependencies, {
		interface = interfaceName,
		multiple = multiple or false
	})

	return self
end

function module:onInject(func)
	module.inject = func

	return self
end

return module
