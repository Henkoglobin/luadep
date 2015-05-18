-- container.lua
-- 
-- Provides a form of dependency injection for Lua projects

local container = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

container.__index = container

function container.new()
	return {
		modules = {}
	}
end

function container:collect(module)
	for _, interfaceName in pairs(module.interfaces) do
		if self.modules[interfaceName] == nil then
			self.modules[interfaceName] = {}
		end

		table.insert(self.modules[interfaceName], module)
	end
end

function container:get(interfaceName)
	local candidates = self.modules[interfaceName] or {}

	for _, module in pairs(candidates) do
		-- Get dependencies of this module 
		local dependencies = module.dependencies

		for _, dependency in pairs(dependencies) do
			local resolved = self:get(dependency.interface)

			if not resolved then
				error(string.format("Cannot resolve dependency '%s'", dependency.interface))
			end

			module:inject(dependency.interface, resolved, dependency.multiple)

			if not dependency.multiple then 
				break 
			end
		end

		return module.module
	end
end

return container
