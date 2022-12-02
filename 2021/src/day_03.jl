# https://adventofcode.com/2021/day/3
using AdventOfCode

input = readlines("data/day_3.txt")
# Turn input into a 2D array to look at cols easily
input = reduce(hcat, [[parse(Int, i) for i in line] for line in input])'

arr_to_int(array) = parse(Int, join(array), base = 2)

function o2_counter(arr)
  # Calculate which (0,1) is most common in 1D array
  num_ones = count(x->(x==1), arr)
  num_zeros = length(arr) - num_ones
  return (num_ones >= num_zeros) ? 1 : 0
end

function co2_counter(arr)
  # Calculate which (0,1) is most common in 1D array
  num_ones = count(x->(x==1), arr)
  num_zeros = length(arr) - num_ones
  return (num_ones < num_zeros) ? 1 : 0
end

function part_1(input)
  input = input'
  # Gamma is most common bit in row
  gamma = []
  # Epsilon is least common bit in row
  epsilon = []
  for row in eachrow(input)
    num_ones = count(r->(r==1), row)
    num_zeros = length(row) - num_ones
    if num_ones > num_zeros
      push!(gamma, 1)
      push!(epsilon, 0)
    else
      push!(gamma, 0)
      push!(epsilon, 1)
    end
  end
  return prod([arr_to_int(gamma), arr_to_int(epsilon)])
end
@info part_1(input)

function part_2(input)
  o2_done = false
  co2_done = false
  o2_matrix = input
  co2_matrix = input
  for curr_pos in 1:size(input, 2)
    valid_o2s = []
    valid_co2s = []
    most = o2_counter(o2_matrix[:, curr_pos])
    least = co2_counter(co2_matrix[:, curr_pos])
    if !o2_done
      for entry in eachrow(o2_matrix)
        if entry[curr_pos] == most
          push!(valid_o2s, entry)
        end
      end
      o2_matrix = reduce(hcat, [[idx for idx in arr] for arr in valid_o2s])'
    end
    if !co2_done
      for entry in eachrow(co2_matrix)
        if entry[curr_pos] == least
          push!(valid_co2s, entry)
        end
      end
      co2_matrix = reduce(hcat, [[idx for idx in arr] for arr in valid_co2s])'
    end
    if size(o2_matrix, 1) == 1
      o2_done = true
    end
    if size(co2_matrix, 1) == 1
      co2_done = true
    end
    if o2_done && co2_done
      break
    end
  end
  return prod([arr_to_int(o2_matrix), arr_to_int(co2_matrix)])
end
@info part_2(input)
