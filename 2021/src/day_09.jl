# https://adventofcode.com/2021/day/9
using AdventOfCode
# using PaddedViews
using Images

input = readlines("./data/day_09.txt")
# to 2D array
input = reduce(hcat, [[parse(Int, i) for i in split(line[1], "")] for line in eachrow(input)])'

function collect_groups(labels)
  # Reference:
  # https://stackoverflow.com/questions/32772190/how-to-find-connected-components-in-a-matrix-using-julia
  groups = [Int[] for i = 1:maximum(labels)]
  for (i,l) in enumerate(labels)
    if l != 0
      push!(groups[l], i)
    end
  end
  groups
end

function part_1(input)
  # NOTE
  # It would be much nicer to do this by sliding a selection kernel across the
  # array, e.g.
  # kernel = [1 0 1; 0 1 0; 1 0 1]
  # Then if the central element is the smallest element in the array, it's a
  # low point
  low_points = []
  for i in 1:size(input, 1)
    for j in 1:size(input, 2)
      e_central = input[i,j]
      e_left = (1 <= j-1 <= size(input, 2)) ? input[i, j-1] : 10
      e_right = (1 <= j+1 <= size(input, 2)) ? input[i, j+1] : 10
      e_up = (1 <= i+1 <= size(input, 1)) ? input[i+1, j] : 10
      e_down = (1 <= i-1 <= size(input, 1)) ? input[i-1, j] : 10
      if (e_left > e_central) && (e_right > e_central) &&
        (e_up > e_central) && (e_down > e_central)
        push!(low_points, e_central)
      end
    end
  end

  return reduce(+, 1 .+ low_points)
end
@info part_1(input)

function part_2(input)
  # Consider '9' as a wall, then collect labels by using the Images library
  # to identify the components (could also create a graph and then run DFS)
  matrix = input .< 9
  labels = label_components(matrix)
  groups = collect_groups(labels)
  return reduce(*, sort([length(g) for g in groups], rev=true)[1:3])
end
@info part_2(input)

