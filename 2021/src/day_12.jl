# https://adventofcode.com/2021/day/12
using AdventOfCode

input = readlines("./data/day_12.txt")

mutable struct Graph
  nodes::Array{String}
  adjacency::Matrix{Int}

  node_idx::Function
  find_paths::Function
  dfs_1!::Function
  dfs_2!::Function

  function Graph(nodes::Array{String}, adjacency::Matrix{Int})
    this = new()
    this.nodes = nodes
    this.adjacency = adjacency

    this.node_idx = function(node::String)
      findfirst(x->x==node, this.nodes)
    end

    this.dfs_1! = function(current::String, target::String, visited_nodes,
      # We can visit large caves any number of times
      current_path, all_paths)
      push!(visited_nodes, current)
      push!(current_path, current)

      if current == target
        push!(all_paths, copy(current_path))
      end

      connections = findall(x->x==1, this.adjacency[this.node_idx(current), :])
      for v_idx in connections
        node = this.nodes[v_idx]
        if all(c->isuppercase(c), node) || !(this.nodes[v_idx] in visited_nodes)
            this.dfs_1!(this.nodes[v_idx], target, visited_nodes, current_path, all_paths)
        end
      end

      pop!(visited_nodes)
      pop!(current_path)

      if isempty(current_path)
        return all_paths
      end
    end

    this.dfs_2! = function(current::String, target::String,
                            visited_nodes, current_path, all_paths)
      # Like dfs_1!, but we can visit a single small cave twice
      push!(visited_nodes, current)
      push!(current_path, current)

      if current == target
        push!(all_paths, copy(current_path))
      end

      connections = findall(x->x==1, this.adjacency[this.node_idx(current), :])
      for n_idx in connections
        node = this.nodes[n_idx]
        # Vertex allowed if
        # 1. it is uppercase
        # 2. it is lowercase and is not in the visited nodes
        # 3. it is lowercase, and no lowercase node is in the visited nodes
        #    twice; unless it is 'start' or 'end', which are visited only once
        occurrences_small = Dict(k => v for (k, v) in count_occurrences(visited_nodes) if all(x->islowercase(x), k))
        if all(c->isuppercase(c), node)
          this.dfs_2!(this.nodes[n_idx], target, visited_nodes, current_path, all_paths)
        elseif !(this.nodes[n_idx] in visited_nodes)
          this.dfs_2!(this.nodes[n_idx], target, visited_nodes, current_path, all_paths)
        elseif !isempty(occurrences_small) && all(x->x<2, values(occurrences_small))
          single_visit_nodes = ["start", "end"]
          if !(node in single_visit_nodes)
            this.dfs_2!(this.nodes[n_idx], target, visited_nodes, current_path, all_paths)
          end
        else

        end
      end

      pop!(visited_nodes)
      pop!(current_path)

      if isempty(current_path)
        return all_paths
      end
    end

    # Need to write my own pathfinding alg from (start -> end)
    # that allows for multiple traversals through big caves but not small caves
    this.find_paths = function(source::String, target::String, dfs::Function)
      # 'source' and 'target' must be in 'this.nodes'
      visited_nodes = []
      current_path = []
      all_paths = []
      return dfs(source, target, visited_nodes, current_path, all_paths)
    end

    return this
  end
end
Graph(nodes) = Graph(nodes,
                        reduce(hcat, [[0 for j in 1:length(nodes)]
                                        for i in 1:length(nodes)]))

function count_occurrences(list::Array)
  counts = Dict(k => 0 for k in list)
  for item in list
    counts[item] += 1
  end

  return counts
end

function find_nodes(input)
  nodes::Array{String} = []
  for line in eachrow(input)
    vs = split(line[1], "-")
    for v in vs
      if !(v in nodes)
        push!(nodes, v)
      end
    end
  end
  return nodes
end

function add_edge!(graph::Graph, head::String, tail::String)
  # undirected, add both edges
  i_h, i_t = findfirst(x->x==head, graph.nodes), findfirst(x->x==tail, graph.nodes)
  graph.adjacency[i_h, i_t] = 1
  graph.adjacency[i_t, i_h] = 1
end

function add_edges!(graph::Graph, input)
  for line in eachrow(input)
    (head, tail) = split(line[1], "-")
    add_edge!(graph, string(head), string(tail))
  end
end

function init_graph(input)
  nodes = find_nodes(input)
  G = Graph(nodes)
  add_edges!(G, input)
  return G
end

function part_1(input)
  G = init_graph(input)
  all_paths = G.find_paths("start", "end", G.dfs_1!)
  return length(all_paths)
end
@info part_1(input)

function part_2(input)
  G = init_graph(input)
  all_paths = G.find_paths("start", "end", G.dfs_2!)
  return length(all_paths)
end
@info part_2(input)

