function menu()
    return {
        loadMenu = function()
            buttons = {}
            newButton = function(x, y, text, fn)
                return {
                    x = x,
                    y = y,
                    text = text,
                    fn = fn
                }
            end
            img = love.graphics.newImage("Sprites/TitleScreen.png")
            font = love.graphics.newFont("Sprites/AncientModernTales-a7Po.ttf", 60)
            table.insert(buttons, newButton(
                love.graphics.getWidth() / 2,
                500,
                "Start",
                function()
                    print("Start Game")
                end
            ))
            love.graphics.setFont(font)
        end,

        drawMenu = function()
            --love.graphics.print("Example Text", love.graphics.getWidth() / 2 - (font:getWidth("Example Text") / 2), 10)
            love.graphics.draw(img, love.graphics.getWidth() / 2 - (img:getWidth() / 2), 0)
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("line", love.graphics.getWidth() / 2 - (img:getWidth() / 2), 0, img:getWidth(), img:getHeight() - 245)
            love.graphics.print("INSIDE THE LIVING CAVE", love.graphics.getWidth() / 2 - font:getWidth("INSIDE THE LIVING CAVE") / 2, 400)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(buttons[1].text, buttons[1].x - font:getWidth(buttons[1].text) / 2, buttons[1].y)
        end
    }

end

return menu

-- function love.mousepressed(x, y, button)
--     if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
--        for i, value in ipairs(buttons) do
--         if ((y > buttons[i].y) and (y < buttons[i].y + font:getHeight(buttons[i].text))) and ((x > buttons[i].x - font:getWidth(buttons[i].text) / 2) and (x < buttons[i].x + font:getWidth(buttons[i].text) / 2)) then
--             love.event.quit()
--         end
--        end
--     end
-- end