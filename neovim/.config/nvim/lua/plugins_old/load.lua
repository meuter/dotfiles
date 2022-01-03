local load = {}

function load.and_configure(module_name, configure)
    local ok, module = pcall(require, module_name)
    if ok then
        configure(module)
    end
end

function load.and_setup(module_name)
    return function(options)
        function configure(module)
            module.setup(options)
        end
        load.and_configure(module_name,configure)
    end
end

return load