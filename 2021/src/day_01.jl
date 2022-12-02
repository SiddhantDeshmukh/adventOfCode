# https://adventofcode.com/2021/day/1
using AdventOfCode

input = readlines("data/day_01.txt")

input = map(x->parse(Int32, x), input)  # convert to ints

function part_1(input)
  # Compute differences between subsequent elements and track positive
  # changes (i.e. depth increases)
  num_positive = count(x->(x > 0), diff(input))
  return num_positive
end
@info part_1(input)


function part_2(input)
  # Differences on a 3-measurement sliding window sum
  # First create an array of 3-element sums
  sum = 0
  arr = []
  for i in firstindex(input):lastindex(input) - 2
    for j in i:i+2
      sum += input[j]
    end
    push!(arr, sum)
    sum = 0
  end
  # Finite difference positive-element check
  num_positive = count(x->(x > 0), diff(arr))
  return  num_positive
end
@info part_2(input)
