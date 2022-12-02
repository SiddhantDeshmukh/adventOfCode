# https://adventofcode.com/2021/day/15
using AdventOfCode
using SparseArrays

input = readlines("./data/day_15_test.txt")
input = reduce(hcat, [parse(Int, i) for i in line[1]] for line in eachrow(input))'

mutable struct Graph
  nodes
  adjacency

  single_idx::Function

  function Graph(nodes, adjacency)
    this = new()
    this.nodes = nodes
    this.adjacency = adjacency
  
    this.single_idx = function(node)
      # Turn CartesianIndex into single index
      node = Tuple(node)
      idx = ((node[2]-1) * size(nodes, 1)) + node[1]
      return idx
    end
    return this
  end
end
Graph(nodes) = Graph(nodes,
                        reduce(hcat, [[0 for j in 1:length(nodes)]
                                        for i in 1:length(nodes)]))

function dfs(G::Graph, current, target, visited_nodes,
            current_path, all_paths)
  push!(visited_nodes, current)
  push!(current_path, current)

  if current == target
    push!(all_paths, copy(current_path))
  end

  # How to deal with weights?
  connections = findall(x->x>=1, G.adjacency[G.single_idx(current), :])
  # println(G.nodes[current])
  # println(connections)
  # for c in connections
  #   println(G.adjacency[c])
  # end
  # exit()
  for n_idx in connections
    if !(G.nodes[n_idx] in visited_nodes)
      dfs(G, G.nodes[n_idx], target, visited_nodes, current_path, all_paths)
    end
  end

  pop!(visited_nodes)
  pop!(current_path)

  if isempty(current_path)
    return all_paths
  end
end

function dijkstra(G::Graph, source, target)
  visited_nodes = []
  distance = 0
  done = false
  niter = 0
  piter = 4
  # Start at 'target'
  current = target
  while !done
    # Distance to end for all nodes leading to 'current'
    if typeof(current) == CartesianIndex{2}
      current = G.single_idx(current)
    end
    connections = findall(x->x>=1, G.adjacency[current, :])
    if niter >= piter
      println("All possible connections: $connections")
      println(visited_nodes)
    end
    # Remove visited connections
    # NOTE:
    # Store the indices to pop and then pop them all at once!
    remove_idxs = []
    for c in connections
      if c in visited_nodes
        idx = findfirst(x->x==c, connections)
        push!(remove_idxs, idx)
      end
    end
    for idx in remove_idxs
      deleteat!(connections, idx)
      remove_idxs .-= 1
    end
    if niter >= piter
      println("Next connections: $connections")
    end
    distances = [G.adjacency[current, c] for c in connections]
    # Add 'current' to visited, then 'current' is next visit (shortest distance)
    push!(visited_nodes, current)
    min_idx = argmin(distances)
    current = connections[min_idx]
    distance += distances[min_idx]
    if niter >= piter
      println("Iteration $niter")
      println("Next: $current")
      println("Current distance = $distance")
      println("$(length(visited_nodes)) nodes visited ($(length(unique(visited_nodes))) unique).")
      println(connections)
      println(distances)
      println(visited_nodes)
      println(unique(visited_nodes))
      exit()
    end
    if current == source
      done = true
    end
    # println(length(visited_nodes))
    niter += 1
  end
  return visited_nodes, distance
end

function find_paths(source::String, target::String, search::Function)
  # 'source' and 'target' must be in 'this.nodes'
  visited_nodes = []
  current_path = []
  all_paths = []
  return search(source, target, visited_nodes, current_path, all_paths)
end

function init(input)::Graph
  # Each node is the CartesianIndex of the input grid
  # Edge weight is the value of the grid at the node
  nodes = eachindex(input)
  num_nodes = size(nodes, 1) * size(nodes, 2) # n1 x n2
  adjacency = spzeros(num_nodes, num_nodes)  # (n1*n2) x (n1*n2)
  for i in 1:size(nodes, 1)
    for j in 1:size(nodes, 2)
      # Neighbours
      for x in -1:1
        for y in -1:1
            # Ignore diagonals and self
            if (abs(x) == abs(y))
              continue
            end
            # Check bounds
            if (1 <= i + x <= size(nodes, 1)) && (1 <= j + y <= size(nodes, 2))
              # Convert to single index for nodes
              idx_u = ((j-1) * size(nodes, 1)) + i
              idx_v = ((j+y-1) * size(nodes, 1)) + (i+x)
              adjacency[idx_u, idx_v] = input[nodes[i+x, j+y]]
              adjacency[idx_v, idx_u] = input[nodes[i, j]]
            end
        end
      end
    end
  end
  return Graph(nodes, adjacency)
end

function part_1(input)
  # Create a weighted Graph out of the grid
  G = init(input)
  visited_nodes, distance = dijkstra(G, first(G.nodes), last(G.nodes))
  println(visited_nodes)
  return distance
end
@info part_1(input)

function part_2(input)
  nothing
end
@info part_2(input)

