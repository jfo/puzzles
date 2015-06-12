@world = []

@thingy = {
    "111" => 0,
    "110" => 1,
    "101" => 1,
    "100" => 0,
    "011" => 1,
    "010" => 1,
    "001" => 1,
    "000" => 0
}

100.times do
    @world << rand(1);
end
@world << 1

def tick(world)
    next_generation =  []
    world.each_with_index do |x, i|
        if i == world.length - 1
            next_generation[i] = @thingy[[world[i-1], x, world[0]].join.to_s]
        else
            next_generation[i] = @thingy[[world[i-1], x, world[i+1]].join.to_s]
        end
    end
    next_generation
end

system("clear")
loop do
    @world = tick(@world)
    derp = @world.map{|e| e == 1 ? "# " : "  " }.join
    puts derp
    sleep 0.05
end
