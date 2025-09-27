function Pandoc(doc)
  -- Procesar tablas
  local new_blocks = {}
  for i, block in ipairs(doc.blocks) do
    if block.t == "Div" then
      local processed = process_div(block)
      if processed then
        table.insert(new_blocks, processed)
      else
        table.insert(new_blocks, block)
      end
    else
      table.insert(new_blocks, block)
    end
  end
  doc.blocks = new_blocks
  return doc
end

function process_div(div)
  -- Check if this is a custom table block
  if div.classes:includes("table") then
    return process_custom_table(div)
  end
  return nil
end

function process_custom_table(div)
  local caption = ""
  local fuente = ""
  local referencia = ""
  local table_block = nil
  
  -- Extract metadata from attributes
  if div.attributes then
    if div.attributes.caption then
      caption = div.attributes.caption
    end
    if div.attributes.fuente then
      fuente = div.attributes.fuente
    end
    if div.attributes.referencia then
      referencia = div.attributes.referencia
    end
  end
  
  -- Find the table in the div content
  for i, block in ipairs(div.content) do
    if block.t == "Table" then
      table_block = block
      break
    end
  end
  
  if not table_block then
    return div
  end
  
  -- Convert the table to ConTeXt format
  return convert_table_to_context(table_block, caption, fuente, referencia)
end

function convert_table_to_context(table_block, caption, fuente, referencia)
  local context = {}
  
  -- Start the placetable environment
  table.insert(context, "\\startplacetable[title={" .. caption .. "},reference={" .. referencia .. "}]")
  
  -- Start the table
  table.insert(context, "\\bTABLE")
  
  -- Process header if it exists
  if table_block.head and table_block.head.rows then
    table.insert(context, "\\bTABLEhead")
    for _, row in ipairs(table_block.head.rows) do
      table.insert(context, "\\bTR")
      if row.cells then
        for _, cell in ipairs(row.cells) do
          -- Extract content using walk to get all inline elements
          local cell_content = ""
          if cell.contents then
            for _, block in ipairs(cell.contents) do
              cell_content = cell_content .. pandoc.utils.stringify(block)
            end
          end
          -- Handle tildes
          cell_content = cell_content:gsub("~", "\\lettertilde{}")
          -- For headers, apply bold formatting since markdown bold is lost in stringify
          if cell_content ~= "" then
            cell_content = "{\\bf " .. cell_content .. "}"
          end
          table.insert(context, "\\bTH " .. cell_content .. "\\eTH")
        end
      end
      table.insert(context, "\\eTR")
    end
    table.insert(context, "\\eTABLEhead")
  end
  
  -- Procesar cuerpo (nota: es 'bodies' plural, no 'body')
  if table_block.bodies and #table_block.bodies > 0 then
    table.insert(context, "\\bTABLEbody")
    for _, body_section in ipairs(table_block.bodies) do
      if body_section.body then
        for _, row in ipairs(body_section.body) do 
          table.insert(context, "\\bTR")
          if row.cells then
            for _, cell in ipairs(row.cells) do
              -- Extrar elementos inline con un walk
              local cell_content = ""
              if cell.contents then
                for _, block in ipairs(cell.contents) do
                  cell_content = cell_content .. pandoc.utils.stringify(block)
                end
              end
              -- Tildes y formateo (\strong, \em, etc.)
              cell_content = cell_content:gsub("~", "\\lettertilde{}")
              if cell_content:find("%*%*") then
                cell_content = cell_content:gsub("%*%*(.-)%*%*", "{\\bf %1}")
              end
              table.insert(context, "\\bTD " .. cell_content .. "\\eTD")
            end
          end
          table.insert(context, "\\eTR")
        end
      end
    end
    table.insert(context, "\\eTABLEbody")
  end
  
  -- Add empty footer
  table.insert(context, "\\bTABLEfoot")
  table.insert(context, "\\eTABLEfoot")
  
  -- End the table
  table.insert(context, "\\eTABLE")
  
  -- Add fuente if provided
  if fuente and fuente ~= "" then
    table.insert(context, "\\fuentetbl{Fuente: " .. fuente .. "}")
  end
  
  -- End the placetable environment
  table.insert(context, "\\stopplacetable")
  
  return pandoc.RawBlock("context", table.concat(context, "\n"))
end

function convert_table_to_context_disabled(table_block, caption, fuente, referencia)
  local context = {}
  
  -- Start the placetable environment
  table.insert(context, "\\startplacetable[title={" .. caption .. "},reference={" .. referencia .. "}]")
  
  -- Start the table
  table.insert(context, "\\bTABLE")
  
  -- Process header if it exists
  if table_block.head and table_block.head.c and #table_block.head.c > 0 then
    table.insert(context, "\\bTABLEhead")
    for _, row in ipairs(table_block.head.c) do
      table.insert(context, "\\bTR")
      for _, cell in ipairs(row) do
        -- Each cell contains block content (e.g., Plain, Para)
        local cell_content = ""
        for _, block in ipairs(cell) do
          if block.t == "Plain" or block.t == "Para" then
            cell_content = cell_content .. convert_inline_list_to_context(block.c)
          end
        end
        table.insert(context, "\\bTH " .. cell_content .. "\\eTH")
      end
      table.insert(context, "\\eTR")
    end
    table.insert(context, "\\eTABLEhead")
  end
  
  -- Process body
  if table_block.body and #table_block.body > 0 then
    table.insert(context, "\\bTABLEbody")
    for _, body_section in ipairs(table_block.body) do
      for _, row in ipairs(body_section.c) do 
        table.insert(context, "\\bTR")
        for _, cell in ipairs(row) do
          -- Each cell contains block content (e.g., Plain, Para)
          local cell_content = ""
          for _, block in ipairs(cell) do
            if block.t == "Plain" or block.t == "Para" then
              cell_content = cell_content .. convert_inline_list_to_context(block.c)
            end
          end
          table.insert(context, "\\bTD " .. cell_content .. "\\eTD")
        end
        table.insert(context, "\\eTR")
      end
    end
    table.insert(context, "\\eTABLEbody")
  end
  
  -- Add empty footer
  table.insert(context, "\\bTABLEfoot")
  table.insert(context, "\\eTABLEfoot")
  
  -- End the table
  table.insert(context, "\\eTABLE")
  
  -- Add fuente if provided
  if fuente and fuente ~= "" then
    table.insert(context, "\\fuentetbl{Fuente: " .. fuente .. "}")
  end
  
  -- End the placetable environment
  table.insert(context, "\\stopplacetable")
  
  return pandoc.RawBlock("context", table.concat(context, "\n"))
end

function convert_inline_list_to_context(inlines)
  local result = {}
  -- Debug: check if inlines is valid
  if not inlines then return "" end
  for _, inline_element in ipairs(inlines) do
    if inline_element.t == "Str" then
      if inline_element.c then
        local text = inline_element.c
        text = text:gsub("~", "\\lettertilde{}")
        table.insert(result, text)
      end
    elseif inline_element.t == "Space" then
      table.insert(result, " ")
    elseif inline_element.t == "Strong" then
      if inline_element.c then
        local content = convert_inline_list_to_context(inline_element.c)
        table.insert(result, "{\\bf " .. content .. "}")
      end
    elseif inline_element.t == "SoftBreak" then
      table.insert(result, " ")
    elseif inline_element.t == "Emph" then
      if inline_element.c then
        local content = convert_inline_list_to_context(inline_element.c)
        table.insert(result, "{\\em " .. content .. "}")
      end
    else
      table.insert(result, pandoc.utils.stringify(inline_element))
    end
  end
  return table.concat(result, "")
end
