class Character
    attr_accessor :health, :power, :defense, :defend, :max_health, :dead
    
    @health = 75
    @power = 2
    @defense = 1
    @defend = false
    @max_health = 75
    @dead = false
    
    def initialize
        @health = 75 + (5 * rand(1..5))
        @power = rand(2..6)
        @defense = rand(1..4)
        @max_health = @health
    end
    
    def checkHealth
        if @health > @max_health
            @health = @max_health
        elsif @health < 0
            @health = 0
            @dead = true
        end
    end
end