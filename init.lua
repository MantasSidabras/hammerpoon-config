hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

priceMenu = hs.menubar.new()
priceMenu:setTitle("Prices")


function updateMenu()
  basedir = "/Users/mantassidabras/Code/kaina/items/"

  function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
  end

  function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
  end

  function getDirs()
    return scandir(basedir)
  end

  function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
  end

  -- get all lines from a file, returns an empty 
  -- list/table if the file does not exist
  function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
  end

  menuTable = {}
  for _, file in pairs(getDirs()) do
    local lines = lines_from(basedir .. file)
    local submenu = {}
    for _, line in pairs(lines) do
      local labels = Split(line, " ")
      table.insert(submenu, {
        title=labels[3].."\t\t"..labels[1] ,
        fn = function() os.execute('open '..labels[2]) end
      })
    end
    
    table.insert(menuTable, {title=file, menu=submenu })
  end

  priceMenu:setMenu(menuTable)
end


hs.urlevent.bind("updatePrices", function(eventName, params)
    hs.alert('updating prices...')
    updateMenu()
end)
