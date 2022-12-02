# https://adventofcode.com/2021/day/5
using AdventOfCode

input = readlines("data/day_05.txt")

to_array(string) = [parse(Int, s) for s in split(string, ",")]

function parse_line_segment(segment)
  # Turn a line segment into coordinates
    pos_1, pos_2 = map(to_array, split(segment, "->"))
    return pos_1, pos_2
end

function get_bounds(lines)
  x_vals, y_vals = lines[:, 1, :], lines[:, 2, :]
  return [min(x_vals...), max(x_vals...)], [min(y_vals...), max(y_vals...)]
end

function create_grid(lines)
  # Find bounds of grid
  x, y = get_bounds(lines)
  # Create 2D grid
  grid = fill(0, (x[2] + 1, y[2] + 1))
  return grid
end

gradient(p_1, p_2) = (p_2[2] - p_1[2]) / (p_2[1] - p_1[1])

function filter_lines(input; use_diagonals=false)
  filtered_lines = []
  for line_segment in eachrow(input)
    pos_1, pos_2 = parse_line_segment(line_segment[1])
    slope = gradient(pos_1, pos_2)
    allowed_slopes = use_diagonals ? [0., -1., 1.] : [0.]
    if isinf(slope) || slope in allowed_slopes
      push!(filtered_lines, hcat([pos_1, pos_2]...))
    end
  end
  return cat(filtered_lines..., dims=3)
end

function draw_line!(grid, line)
  # 'Draw' line on grid, increasing values where line exists by 1
  idxs = line .+ 1
  slope = gradient(idxs[:, 1], idxs[:, 2])
  if isinf(slope) || slope == 0.
    # Check if indices need to be reversed (if 'higher': 'lower')
    if idxs[1,2] < idxs[1,1] || idxs[2, 2] < idxs[2, 1]
      idxs = hcat(reverse(idxs[1, :]), reverse(idxs[2, :]))'
    end
    grid[idxs[1, 1]:idxs[1, 2], idxs[2, 1]:idxs[2,2]] .+= 1
  else
    # Check if indices need to be reversed (if 'higher': 'lower')
    if idxs[1,2] < idxs[1,1] 
      idxs = hcat(reverse(idxs[1, :]), reverse(idxs[2, :]))'
    end
    num_points = max(idxs[1, 2] - idxs[1, 1], idxs[2, 2] - idxs[2, 1])
    curr = idxs[:, 1]
    for i in 1:num_points + 1
      grid[curr[1], curr[2]] += 1.
      curr[1] += 1
      curr[2] += slope
    end
  end

end

function find_vents(input; use_diagonals=false)
  lines = filter_lines(input; use_diagonals = use_diagonals)
  grid = create_grid(lines)
  for k in 1:size(lines)[3]
    draw_line!(grid, lines[:, :, k])
  end

  # display(grid')
  return grid
end

function part_1(input)
  return count(x -> x>=2, find_vents(input; use_diagonals=false))
end
@info part_1(input)


function part_2(input)
  return count(x -> x>=2, find_vents(input; use_diagonals=true))
end
@info part_2(input)