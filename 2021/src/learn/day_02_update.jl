# https://adventofcode.com/2021/day/2
using AdventOfCode

input = readlines("../data/day_2_test.txt")

function move(start_coord, instructions, rules)
  coord = start_coord
  for instruction in instructions
    direction, value = split(instruction, " ")
    coord = rules[direction](coord, parse(Int, value))
  end
  return coord
end

function part_1(input)
  # Given set of instructions, find final depth and horizontal direction
  # Multply end result together
  # 'coord' is [horizontal position, depth]
  rules = Dict(
    "forward" =>  (pos, x) -> pos + [1, 0] .* x,
    "down" => (pos, x) -> pos + [0, 1] .* x,
    "up" => (pos, x) -> pos + [0, -1] .* x
  )
  coord = move([0, 0], input, rules)
  return prod(coord)
end
@info part_1(input)

function part_2(input)
  # Add 'aim' quantity as third index in 'coord'
  # 'coord' is [horizontal position, depth, aim]
  rules = Dict(
    "forward" => (pos, x) -> [pos[1] + x, pos[2] + pos[3] * x, pos[3]],
    "down" => (pos, x) -> pos + [0, 0, 1].*x,
    "up" => (pos, x) -> pos + [0, 0, -1].*x
  )
  coord = move([0, 0, 0], input, rules)
  return prod(coord[1:2])
end
@info part_2(input)
