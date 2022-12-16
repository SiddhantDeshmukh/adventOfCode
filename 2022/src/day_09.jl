function parse_data(data)
  # Get the instructions to move the head node
  directions::Array{String} = []
  distances::Array{Int} = []
  for line in data
    direction = string(line[1])
    distance = parse(Int, line[3:end])
    push!(directions, direction)
    push!(distances, distance)
  end

  return directions, distances
end

function move_node!(node_pos::Vector, direction::String, distance::Int)
  # Change the node position based on the direction and distance
  # "L" "R" affect -/+ x, "U" "D" affect +/- y
  movements = Dict(
    "L" => [-distance, 0],
    "R" => [distance, 0],
    "U" => [0, distance],
    "D" => [0, -distance]
  )

  node_pos += movements[direction]
  return node_pos
end

function calc_distance(node_1::Vector, node_2::Vector)
  # Calculates the distance vector between the nodes, i.e. the vector you would
  # add to 'node_1' to overlap with 'node_2'
  return node_2 - node_1
end

function move_tail!(head_pos::Vector{Int}, tail_pos::Vector{Int})
  vec::Vector{Int} = calc_distance(tail_pos, head_pos)
  if all(v -> (abs(v) <= 1), vec)
    return tail_pos
  end

  if abs(vec[1]) > abs(vec[2])
    inc = [-1, 0] * sign(vec[1])
  else
    inc = [0, -1] * sign(vec[2])
  end
  tail_pos += (vec + inc)
  return tail_pos
end

function simulate(directions::Array{String}, distances::Array{Int};
  starting_positions=[[0, 0], [0, 0]])
  # Must have at least 2 starting positions, correspond to knots (head and tail)
  # Move first node in 'starting_positions', and at each timestep, see if other
  # nodes should move based on this
  num_knots::Int = length(starting_positions)
  positions = starting_positions
  visited_positions = []  # only for last node!
  # @show head_pos
  for (direction, distance) in zip(directions, distances)
    # Due to the way the tail moves on diagonals, we have to step one at a time
    # @show direction, distance
    for i = 1:distance
      # @show head_pos, tail_pos
      positions[1] = move_node!(positions[1], direction, 1)
      for k = 2:num_knots
        positions[k] = move_tail!(positions[k-1], positions[k])
      end
      if !(positions[end] in visited_positions)
        push!(visited_positions, positions[end])
      end
      # @show head_pos, tail_pos
    end
  end

  return visited_positions
end

function main()
  data = readlines("./data/day_09_test.txt")
  # data = readlines("./data/day_09.txt")

  directions, distances = parse_data(data)
  start_pos = [0, 0]
  start_p1 = [start_pos for _ = 1:2]
  visited_p1 = simulate(directions, distances; starting_positions=start_p1)
  @show length(visited_p1)
  start_p2 = [start_pos for _ = 1:10]
  visited_p2 = simulate(directions, distances; starting_positions=start_p2)
  @show length(visited_p2)
end

main()


#=
Part 1:
Head and tail start at same position (overlapping). If tail is ever >=2 units
(left,right,top,down) away from head, tail moves to be close to head.
Tail can move diagonally.

tail_increment = vec + inc
Pattern for 'inc' distances given 'vec'
[-1, 0] * sign(x) if x > y
[0, -1] * sign(y) if x < y
Positive x; x > y => [-1, 0]
Positive y; y > x => [0, -1]
Negative x; abs(x) > abs(y): [1, 0]
Negative y; abs(y) > abs(x): [0, 1]
vec   => tail_increment  ; tail_increment - vec (add to vec)
[2, -1] => [1, -1]  # right-down   [-1, 0]
[2, 0] => [1, 0]  # right          [-1, 0]
[2, 1] => [1, 1]  # right-up       [-1, 0]
[1, 2] => [1, 1]  # up-right       [0, -1]
[0, 2] => [0, 1]  # up             [0, -1]
[-1, 2] => [-1, 1]  # up-left      [0, -1]
[-2, 1] => [-1, 1]  # left-up      [1, 0]
[-2, 0] => [-1, 0]  # left         [1, 0]
[-2, -1] => [-1, -1]  # left-down  [1, 0]
[-1, -2] => [-1, -1]  # down-left  [0, 1]
[0, -2] => [0, -1]  # down         [0, 1]
[1, -2] => [1, -1]  # down-right   [0, 1]

Alternate:
Pretty sure you can just keep track of the old head position and if we're out
of distance, move the tail to the previous head pos

REFACTOR FOR P2:
Create vector of 2D arrays that keeps track of all positions, then looping
through at each timestep, use the previous node to figure out if the current
node should move
=#