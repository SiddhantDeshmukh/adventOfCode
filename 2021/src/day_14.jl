# https://adventofcode.com/2021/day/14
using AdventOfCode
using OrderedCollections


input = readlines("./data/day_14.txt")

function init(input)
  template = input[1]
  pair_insertions = Dict()
  for line in eachrow(input[3:length(input)])
    (k, v) = split(line[1], " -> ")
    pair_insertions[k] = v[1]
  end

  pair_occurrences = Dict(k => 0 for k in keys(pair_insertions))
  pairs = [template[i] * template[i+1] for i in 1:length(template)-1]
  for key in pairs
    pair_occurrences[key] += 1
  end
  occurrences = Dict(k => 0 for k in unique(join(keys(pair_insertions))))
  for key in template
    occurrences[key] += 1
  end

  return pair_insertions, pair_occurrences, occurrences
end

function step!(pair_occurrences, occurrences, pair_insertions)
  # Iterate over copy (previous polymer) and build up the new one
  for (pair, p_count) in copy(pair_occurrences)
    if p_count > 0
      # Current pair is destroyed
      pair_occurrences[pair] -= p_count
      # 2 new pairs are created
      new_element = pair_insertions[pair]
      occurrences[new_element] += p_count
      new_pairs = [pair[1] * new_element, new_element * pair[2]]
      for new_pair in new_pairs
        pair_occurrences[new_pair] += p_count
      end
    end
  end

  return pair_occurrences, occurrences
end

function evolve!(pair_occurrences, occurrences, pair_insertions, num_steps)
  # Store the polymer as a collection of pairs -> The order of the sequence does
  # not matter since all substitutions are performed simultaneously
  # Split the initial polymer into pairs
  for i in 1:num_steps
    step!(pair_occurrences, occurrences, pair_insertions)
  end
  return pair_occurrences, occurrences
end

function part_1(input)
  pair_insertions, pair_occurrences, occurrences = init(input)
  evolve!(pair_occurrences, occurrences, pair_insertions, 10)
  occurrences = sort(collect(occurrences); by=x->x[2]) 
  return last(occurrences)[2] - first(occurrences)[2]
end
@info part_1(input)

function part_2(input)
  pair_insertions, pair_occurrences, occurrences = init(input)
  evolve!(pair_occurrences, occurrences, pair_insertions, 40)
  occurrences = sort(collect(occurrences); by=x->x[2])

  return last(occurrences)[2] - first(occurrences)[2]
end
@info part_2(input)

