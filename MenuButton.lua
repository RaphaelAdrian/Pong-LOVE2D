MenuButton = Class{}



WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

function MenuButton:init(x,y,width,height,text, state)
	self.width = width 
	self.text = text;
	self.height = height
	self.x = x - (self.width * 0.5)
	self.y = y - (self.height * 0.5)
	self.selected = false
	self.state = state

	love.graphics.setDefaultFilter('nearest','nearest')
	smallFont = love.graphics.newFont('font.ttf', 24)

end

function MenuButton:collides(x,y)
	local color = {0.4, 0.4, 0.4, 1.0}

   	hot = x >= self.x and x <=  self.width  + self.x and 
   			y >= self.y and y <= self.height + self.y

   	if hot then 
   		color = {0.8, 0.8, 0.9, 1.0}
   		if love.mouse.isDown(1) then
   			selected = true
			gameState = self.state

   		end
   	end


	love.graphics.setColor(unpack(color))
end



function MenuButton:render()

	local textW = smallFont:getWidth(self.text)
	local textH = smallFont:getHeight(self.text)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(self.text, smallFont , self.x + textW * 0.5  , self.y + textH * 0.5)
end

