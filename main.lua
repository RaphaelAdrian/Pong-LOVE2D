
--requiremnents
Class = require 'class'

push = require 'push'
require 'paddle'
require 'ball'
require 'menubutton'

--[ Variables]
--[ Screen Var]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
--[[VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT =243--]]

VIRTUAL_HEIGHT = 720
VIRTUAL_WIDTH = 1280
PADDLE_SPEED = 400


function love.load()


	love.graphics.setDefaultFilter('nearest','nearest')
	love.window.setTitle('Razu Pong')
	math.randomseed(os.time())
	initializeFont()
	love.graphics.setFont(smallFont)

	sounds = {
		['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
		['score'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'), 
		['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
	}


	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
	fullscreen = false,
	resizable = false,
	vsync = true
	})

	--[Player Components]

	player1 = Paddle(10,30,15,60)
	player2 = Paddle(VIRTUAL_WIDTH - 30, VIRTUAL_HEIGHT - 30, 15, 60)

	local margin = 65
	buttons = {}

	player1_button = MenuButton( VIRTUAL_WIDTH * 0.5 , (VIRTUAL_HEIGHT * 0.5) + margin, 200, 40, '1 PLAYER','serve')
	table.insert(buttons, player1_button)
	player2_button = MenuButton( VIRTUAL_WIDTH * 0.5 , (VIRTUAL_HEIGHT * 0.5) + margin * 2, 200, 40, '2 PLAYER','start' )
	table.insert(buttons, player2_button)


	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 12, 12)


--[Player Score]

	player1_score = 0
	player2_score = 0

	playerServe = 1

	playerWin = 0

	gameState = 'menu'

end



function love.resize(w, h)
	push:resize(w,h)
end




function love.update(dt)

	if gameState  =='serve' then 
		ball.dy = math.random(-250,250)
		if playerServe == 1 then
            ball.dx = -math.random(350, 400)
        else
            ball.dx = math.random(350, 400)
        end

	elseif gameState == 'play' then
		if ball:collides(player1) then 
			ball.dx = -ball.dx * 1.03
			ball.x = player1.x + 15 
			if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

			sounds['paddle_hit']:play()

		end

		if ball:collides(player2) then 
			ball.dx = -ball.dx * 1.03
			ball.x = player2.x - 12 
		if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

			sounds['paddle_hit']:play()
		end

		if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

		if ball.y >= VIRTUAL_HEIGHT - 12 then
			ball.y = VIRTUAL_HEIGHT - 12
			ball.dy = -ball.dy
			sounds['wall_hit']:play()
		end


		if ball.x < 0 then
			playerServe = 1
			player2_score = player2_score + 1
			sounds['score']:play()

			if player2_score == 10 then
				playerWin =2 
				gameState = 'done'
			else 
				gameState = 'serve'

				ball:reset()
			end
		end

		if ball.x > VIRTUAL_WIDTH then
			playerServe = 2
			player1_score = player1_score + 1
			sounds['score']:play()

			if player1_score == 10 then
				playerWin = 1
				gameState = 'done'
			else 
				gameState = 'serve'

				ball:reset()
			end
		end
	end




	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED 
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED 
	else 
		player1.dy = 0
	end
	--Player 2 Controls
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED 
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED 
	else 
		player2.dy = 0
	end

	if gameState == 'play' then
		ball:update(dt)
	end

	player1:update(dt)
	player2:update(dt)

end


	function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then 
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'done' then
			gameState = 'serve'
			ball:reset()
			player1_score = 0
			player2_score = 0

			if playerWin == 1 then
				playerServe = 2
			else 
				playerServe = 1
			end
		end
	end
end


function love.draw()
	push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

 	if gameState == 'menu' then
 		displayMenu()
 	elseif gameState == 'start' or gameState == 'serve' or gameState == 'play' then
 		displayScore()
 		player1:render()
 		player2:render()
		ball:render()
		
		if gameState == 'serve'then
				love.graphics.setFont(smallFont)
				love.graphics.printf('Player ' .. tostring(playerServe).. "'s serve", 0,100,VIRTUAL_WIDTH,'center')
				love.graphics.printf('Press Enter to serve', 0,620,VIRTUAL_WIDTH,'center')
		end



	elseif gameState == 'play' then
	elseif gameState == 'done' then
		love.graphics.setFont(largeFont)
		love.graphics.printf('Player '.. tostring(playerWin).. ' wins', 0,100,VIRTUAL_WIDTH,'center')
		love.graphics.setFont(smallFont)
		love.graphics.printf("Press Enter to Play Again" , 0, 30, VIRTUAL_WIDTH, 'center')
	end
	

	displayFPS()

	push:apply('end')
end  

function displayMenu()
		titleFont = love.graphics.newFont('font.ttf', 120)
		love.graphics.setFont(titleFont)
		love.graphics.printf('Razu Pong!', 0 , 250, VIRTUAL_WIDTH, 'center')

	x, y = love.mouse.getPosition()
	for i, v in ipairs(buttons) do 
		v:collides(x,y)
		v:render() 
	end
end

function displayMouse()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print('X - '.. tostring(x),20,20)
	love.graphics.print('Y - '.. tostring(y),20,30)

end

function displayScore()
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH / 2 + 90, VIRTUAL_HEIGHT /3)
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print('FPS: '.. tostring(love.timer.getFPS()),10,10)
end
function initializeFont()
	smallFont = love.graphics.newFont('font.ttf', 8)
	largeFont = love.graphics.newFont('font.ttf' , 16)
	scoreFont = love.graphics.newFont('font.ttf', 80)
end



