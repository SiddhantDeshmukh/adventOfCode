struct Node
  id::String
  parent::String
  children::Vector{Node}
end

struct Tree
  nodes::Vector{Node}
end

function add_edge!(nodes::Vector{Node}, source::String, target::String)
  for node in nodes
    if node.id == source
      @show node.id, source, target
      push!(node.children, Node(target, node.id, []))
      return nodes
    else
      add_edge!(node.children, source, target)
    end
  end
  return nodes
end

function add_edge!(tree::Tree, source::String, target::String)
  return add_edge!(tree.nodes, source, target)
end

function find_node(nodes::Vector{Node}, target::String)
  for node in nodes
    if node.id == target
      return node
    elseif !isempty(node.children)
      return find_node(node.children, target)
    end
  end
  @show target, nodes
  return nothing
end

function find_node(tree::Tree, target::String)
  return find_node(tree.nodes, target)
end

iscommand(str::String) = startswith(str, "\$")

function print_nodes(nodes::Vector{Node}, tab_length::Int)
  # pretty-print the filesystem
  for node in nodes
    println(repeat("\t", tab_length), "$(node.id)")
    tab_length = tab_length + 1
    print_nodes(node.children, tab_length)
  end
end

function print_nodes(tree::Tree)
  print_nodes(tree.nodes, 0)
end

function parse_data(data)
  # Parse input data to get the filesystem
  # Top directory is '/'
  # commands start with '$'
  # Files start with numbers (filesize)
  # Directories start with 'dir'
  # Count number of directories
  line_num = 1
  current_dir = "/"
  filesystem = Tree([Node(current_dir, "", [])])
  while (line_num <= length(data))
    line = data[line_num]
    # for (line_num, line) in enumerate(data)
    if (iscommand(line))
      cmd_pattern = r"\$ ([a-z]+)"
      cmd_key = match(cmd_pattern, line).captures[1]
      if cmd_key == "cd"
        target_dir = string(strip(replace(line, cmd_pattern => "")))
        if target_dir == "/"
          # Top level
          println("Skip")
        elseif target_dir == ".."
          println("Going up from $(current_dir)")
          # up one dir
          current_dir = find_node(filesystem, current_dir).parent
        else
          println("Adding $(target_dir) under $(current_dir)")
          filesystem = add_edge!(filesystem, current_dir, target_dir)
          @show filesystem
        end
        current_dir = target_dir
      end
      # 'cd' changes directory
      # 'ls' lists files
      # @show line, replace(line, cmd_pattern => "")
      # data_pkg = [filesystem, current_dir, line_num]
      # control_flow = Dict(
      #   "cd" => change_directory(replace(line, cmd_pattern => ""), data_pkg),
      #   "ls" => list_directory(line, data_pkg)
      # )
      # result = control_flow[cmd_key]
      # @show result
    end
    line_num += 1
  end
  @show filesystem
  print_nodes(filesystem)
end


function main()
  data = readlines("./data/day_07_test.txt")
  # data = readlines("./data/day_07.txt")
  parse_data(data)
end

main()