# https://adventofcode.com/2021/day/7
using AdventOfCode
using Statistics

input = readlines("./data/day_07.txt")
input = [parse(Int, val) for val in split(input[1], ",")]
sort!(input)

function linear_loss(arr::Array{Int}, val)
  # Sum of linear loss between 'arr' elements and 'val'
  return reduce(+, abs.(arr .- val))
end

function consecutive_loss(arr::Array{Int}, val)
  # 'nth' triangle number foreach element, summed up
  differences = abs.(arr .- val)
  return reduce(+, (differences.^2 + differences)/2)
end

function cheapest_move(arr::Array{Int}, loss_function::Function)
  # Find the fuel cost and position of the cheapest move by evaluating loss for
  # all possible inputs
  positions = range(first(arr), last(arr), step=1)
  cheapest_cost, cheapest_position = Inf, -1
  for position in positions
    cost = loss_function(input, position)
    if cost < cheapest_cost
      cheapest_cost = cost
      cheapest_position = position
    end
  end

  return cheapest_position, cheapest_cost
end

function part_1(input)
  return Int(median(input))
end
@info part_1(input)

function part_2(input)
  return BigInt(cheapest_move(input, consecutive_loss)[2])
end
@info part_2(input)

