# https://adventofcode.com/2021/day/11
using AdventOfCode


path = "./data/day_11.txt"
init(path) = reduce(hcat, [parse(Int, i) for i in line[1]] for line in eachrow(readlines(path)))'

function flash!(input, flash_idxs, idx)
  # Recursive! Single octopus flash that increases neighbours energy by 1
  for i in -1:1
    for j in -1:1
      if i == 0 && j == 0
        continue
      end
      new_idx = CartesianIndex(idx[1] + i, idx[2] + j)
      if any([i < 1 || i > 10 for i in Tuple(new_idx)])
        continue
      end
      if !(new_idx in flash_idxs) 
        input[new_idx] += 1
        if input[new_idx] > 9
          push!(flash_idxs, new_idx)
          input, flash_idxs = flash!(input, flash_idxs, new_idx)
        end
      end
    end
  end

  return input, flash_idxs
end

function step!(input)
  flash_idxs = []
  # 1. Increase energy level of each octopus by 1
  input .+= 1
  # 2. Any octopus with energy higher than 9 flashes, increasing all adjacent
  #    octopodes' energy levels by 1 (including diagonals)
  potential_idxs = findall(>(9), input)
  for idx in potential_idxs
    if !(idx in flash_idxs)
      push!(flash_idxs, idx)
      input, flash_idxs = flash!(input, flash_idxs, idx)
    end
  end
  # 3. Set octopus that flashed energy level to 0
  if !isempty(flash_idxs)
    for idx in flash_idxs
      input[idx] = 0
    end
  end

  num_flashes = length(flash_idxs)
  return input, num_flashes
end

function part_1(path)
  input = init(path)
  # Evolve for 100 steps
  num_flashes = 0
  num_steps = 100
  for i in 1:num_steps
    input, n = step!(input)
    num_flashes += n
  end
  return num_flashes
end
@info part_1(path)

function part_2(path)
  input = init(path)
  # Evolve until all octopodes flash at the same time
  done = false
  num_steps = 0
  while !done
    step!(input)
    num_steps += 1
    if all(x->x==0, input)
      return num_steps
    end
  end
end
@info part_2(path)
