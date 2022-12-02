# https://adventofcode.com/2021/day/6
using AdventOfCode

input = readlines("data/day_06.txt")
# Initial state
input = [parse(Int, i) for i in split(input[1], ",")]

function initialise(input, growth_rate::Int)
  fish_counts = fill(0, growth_rate + 2)
  for i in input
    fish_counts[i+1] += 1
  end

  return fish_counts
end

# Would be nice to make this evolve!() but for some reason it doesn't work
function evolve(fish_counts, num_days)
  num_6_increase = 0
  for day in 1:num_days
    fish_counts = circshift(fish_counts, -1)
    if num_6_increase > 0
      fish_counts[7] += num_6_increase
      num_6_increase = 0
    end
    num_6_increase = fish_counts[1]
  end
  return fish_counts
end

function part_1(input)
  fish_counts = initialise(input, 7)
  return reduce(+, evolve(fish_counts, 80))
end
@info part_1(input)


function part_2(input)
  fish_counts = initialise(input, 7)
  return reduce(+, evolve(fish_counts, 256))
end
@info part_2(input)
