require 'sinatra'
require './lib/character.rb'

player = Character.new
enemy = Character.new

get '/' do
    erb :index
end

get '/turn/' do
    erb :cheatcatch
end

get '/player/' do
    erb :cheatcatch
end

post '/turn/' do
    paction = "nothing"
    eaction = "nothing"
    
    playerdealt = 0
    playerhealing = 0
    enemydealt = 0
    enemyhealing = 0
    
    if params['Action'].to_s == "a"
        paction = "attack"
        playerdealt = rand(1..player.power) - rand(1..enemy.defense)
        if playerdealt < 0
            playerdealt = 0
        end
        enemy.health -= playerdealt
        enemy.checkHealth
    elsif params['Action'].to_s == "d"
        paction = "defend"
        player.defend = true
        player.defense += 3
    elsif params['Action'].to_s == "h"
        paction = "heal"
        playerhealing = (player.max_health - player.health) / 5
        player.health += playerhealing
        player.checkHealth
    end
    
    if enemy.defend
        enemy.defend = false
        enemy.defense -= 3
    end
    
    if enemy.dead
        redirect to '/end/'
    end
    
    action = rand(1..10)
    
    if action <= 6
        eaction = "attack"
        enemydealt = rand(1..enemy.power) - rand(1..player.defense)
        if enemydealt < 0
            enemydealt = 0
        end
        player.health -= enemydealt
        player.checkHealth
    elsif action <= 9
        eaction = "defend"
        enemy.defend = true
        enemy.defense += 3
    elsif action == 10
        eaction = "heal"
        enemyhealing = (enemy.max_health - enemy.health) / 10
        enemy.health += enemyhealing
        enemy.checkHealth
    end
    
    if player.dead
        redirect to '/end/'
    else
        erb :turn, :locals => { :player => player, :pact => paction, :pdmg => playerdealt, :pheal => playerhealing, :enemy => enemy, :eact => eaction, :edmg => enemydealt, :eheal => enemyhealing }
    end
end

post '/player/' do
    if player.defend
        player.defend = false
        player.defense -= 3
    end
    
    erb :player, :locals => { :player => player, :enemy => enemy }
end

get '/end/' do
    erb :endgame, :locals => { :player => player, :enemy => enemy }
end

get '/startover/' do
    player = Character.new
    enemy = Character.new
    redirect to '/'
end