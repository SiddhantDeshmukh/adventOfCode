# https://adventofcode.com/2021/day/2
using AdventOfCode

input = readlines("data/day_2_test.txt")

function part_1(input)
  # Given set of instructions, find final depth and horizontal direction
  # Multply end result together
  # 'coord' is [horizontal position, depth]
  coord = [0, 0]
  # Define directions
  directions = Dict("forward" => [1, 0], "down" => [0, 1], "up" => [0, -1])
  for instruction in input
    direction, value = split(instruction, " ")
    coord += (directions[direction] .* parse(Int, value))
  end
  return prod(coord)
end
@info part_1(input)

function part_2(input)
  # Add 'aim' quantity as third index in 'coord'
  # 'coord' is [horizontal position, depth, aim]
  coord = [0, 0, 0]
  # Define directions
  forward(coord, x) = [coord[1] + x, coord[2] + coord[3] * x, coord[3]] 
  down(coord, x) = coord + [0, 0, 1].*x
  up(coord, x) = coord + [0, 0, -1].*x
  aims = Dict(
    "forward" => forward,
    "down" => down,
    "up" => up
  )
  
  for instruction in input
    direction, value = split(instruction, " ")
    coord = aims[direction](coord, parse(Int, value))
  end
  return prod(coord[1:2])
end
@info part_2(input)
