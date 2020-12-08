push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
wrongCount=0
letterRight = 0
--sound effects
applause = love.audio.newSource("yay.mp3", "static")
boo = love.audio.newSource("boo.mp3", "static")

playing = true
wordSpots = {}
wordList = {"house", "aglet", "dog", "cheese", "alphabet", "hangman", "sky", "chocolate", "wheel", "filibuster", "xylophone", "cloud", "zigzag", "jazz", "extreme", "abyss", "askew", "hardcore", "python", "fizz", "buzz", "quiz", "jinx", "zugzwang", "gym", "rhythm"}
correctCount = 0

--gets a random word from the list
math.randomseed(os.time())
randomNum = math.random(1, #wordList)
randomWord = wordList[randomNum]
numBlanks = string.len(randomWord)

--sets up wordSpots as blank letters
for i = 1, #randomWord do  
    wordSpots[#wordSpots + 1] = ' '  
end

Ltext = " "

correctCount = 0




function love.load()

    mainFont = love.graphics.newFont('newFont.ttf',20)
    love.graphics.setFont(mainFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w,h)
    push:resize(w,h)
end


function love.keypressed(key)
    pressed = key
    if playing == true then
        if key == "escape" then --one of the letters in the word
            love.event.quit()
        elseif key == "a" or key == "b" or key == "c" or key == 'd' or key == "e" or key == 'f' or key == 'g' or key == "h" or key == "i" or key == 'j' or key == 'k' or key == 'l' or key == 'm' or key == 'n' or key == "o" or key == "p" or key == 'q' or key == 'r' or key == 's' or key == 't' or key == 'u' or key == "v" or key == "w" or key == 'x' or key == 'y' or key == 'z' then
            Ltext = string.lower(pressed)

            LrandomWord = string.lower(randomWord) --ensure no problems with capitalization
            letterWrong=0
            --cross checks the guessed letter with every letter in the word
            for i=1, #LrandomWord do
                c = LrandomWord:sub(i,i)
                if Ltext == c then
                    Cguess=Ltext
                    wordSpots[i] = Cguess
                    letterRight = letterRight + 1
                else
                    letterWrong= letterWrong + 1
                end
            end
            if letterWrong == #LrandomWord then
                wrongCount = wrongCount + 1
            end
        end
    end
    if playing == false then -- when playing == false
        if key == "escape" then --one of the letters in the word
            love.event.quit()
        elseif key == "space" then --reset button - code below resets the game
            wordSpots = {}
            math.randomseed(os.time())
            randomNum = math.random(1, #wordList)
            randomWord = wordList[randomNum]
            numBlanks = string.len(randomWord)
            for i = 1, #randomWord do  
                wordSpots[#wordSpots + 1] = ' '  
            end
            Ltext = " "
            wrongCount = 0
            letterWrong = 0
            letterRight = 0
            playing = true -- this should make it so keys can be clicked again
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,255/255)
    --last guess
    love.graphics.print("Last Guess:", VIRTUAL_WIDTH/2-200, VIRTUAL_HEIGHT/2-60)
    love.graphics.print(Ltext, VIRTUAL_WIDTH/2-170, VIRTUAL_HEIGHT/2-30)
    
    love.graphics.printf("Welcome to Hardcore Hangman!", 0, 10, VIRTUAL_WIDTH, "center")

    --hanging pole
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 -80, VIRTUAL_HEIGHT/2 +40, 160, 5) --base
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 60, VIRTUAL_HEIGHT/2 - 80, 5, 120) --pole
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-60, VIRTUAL_HEIGHT/2 -80, 45, 5) --upper base
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 15, VIRTUAL_HEIGHT/2 -80, 5, 15) -- small down pole
    
    
        -- below creates blanks for guessing
    blankPos = VIRTUAL_WIDTH/6
    for i=1, #randomWord do
        love.graphics.rectangle('fill', blankPos, VIRTUAL_HEIGHT/2 +80, 25, 5)
        blankPos= blankPos + 35
    end
    
    -- below prints letters on blanks
    for i=1, #wordSpots do
        love.graphics.print(wordSpots[i],(VIRTUAL_WIDTH/6 - 28) + 35*i, VIRTUAL_HEIGHT/2 +60)
    end
    --below builds the hangman as letters are guessed wrong
    if wrongCount>=1 then
        love.graphics.circle("fill", VIRTUAL_WIDTH/2 - 13, VIRTUAL_HEIGHT/2 -55,12)
    end
    if wrongCount >= 2 then
        love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 - 14, VIRTUAL_HEIGHT/2 -45, 3, 40)
    end
    if wrongCount >= 3 then
        love.graphics.rotate(45)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 - 25, VIRTUAL_HEIGHT/2-270, 3, 30) -- shouldn't be able to see edge when other arm is also there
        love.graphics.rotate(-45)
    end
    if wrongCount >=4 then
        love.graphics.rotate(-45)
        love.graphics.rectangle("fill", VIRTUAL_HEIGHT/3-62, VIRTUAL_WIDTH/2-20, 3, 30)
        love.graphics.rotate(45)
    end
    if wrongCount >=5 then
       love.graphics.rotate(45)
       love.graphics.rectangle("fill", VIRTUAL_WIDTH/2 -12, VIRTUAL_HEIGHT/2-235, 3, 30)
       love.graphics.rotate(-45)
    end
    --last guess
    if wrongCount>=6 then
        boo:play()
        love.graphics.rotate(-45)
        love.graphics.rectangle("fill", VIRTUAL_HEIGHT/3-74, VIRTUAL_WIDTH/2+16, 3, 30)
        love.graphics.rotate(45)
        love.graphics.setColor(1,0,0)
        love.graphics.print("Oh no! You lost!" , VIRTUAL_WIDTH/3 *2 + 15, VIRTUAL_HEIGHT/2-60)
        love.graphics.print("Press the Space Bar", VIRTUAL_WIDTH/3*2, VIRTUAL_HEIGHT/2 -40)
        love.graphics.print("to play again!", VIRTUAL_WIDTH/3 * 2 + 15, VIRTUAL_HEIGHT/2-20)
        love.graphics.setColor(0,0.5,1)
        love.graphics.print("The correct word was:", VIRTUAL_WIDTH/3*2 - 10, VIRTUAL_HEIGHT/2 +20)
        love.graphics.print(randomWord, VIRTUAL_WIDTH/3*2 + 30, VIRTUAL_HEIGHT/2 +40)
        love.graphics.setColor(1,1,1)
        playing = false

    end

    
    --if word is guessed all correct:
    if letterRight == #randomWord then
        applause:play()
        love.graphics.setColor(0,1,0)
        love.graphics.print("Congrats! You won!" , VIRTUAL_WIDTH/3 *2, VIRTUAL_HEIGHT/2-20)
        love.graphics.print("Press the Space Bar", VIRTUAL_WIDTH/3*2, VIRTUAL_HEIGHT/2)
        love.graphics.print("to play again!", VIRTUAL_WIDTH/3 * 2 + 15, VIRTUAL_HEIGHT/2 + 20)
        love.graphics.setColor(1,1,1)
        playing = false
    end

    
    push:apply('end')
end




