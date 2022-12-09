function parse_instruction(instruction)
  # of form 'move X from Y to Z'
  # i.e. move "a number of crates" from "location 1" to "location 2"
  matches = [parse(Int, x.match) for x in eachmatch(r"[0-9]+", instruction)]
  return Dict("num" => matches[1], "source" => matches[2], "target" => matches[3])
end

is_crate(str::String) = occursin(r"\[[aA-zZ]\]", str)
get_crate(str::String) = match(r"(?<=\[)[^\[\]]+(?=\])", str).match
index_to_crate_num(idx::Int; crate_length=3) = Int((idx + 2) / (crate_length + 1))

function print_stacks(crate_stacks)
  # Print each stack as a line
  for k in sort(Int.(keys(crate_stacks)))
    println("$(k): $(join(crate_stacks[k]))")
  end
end

function parse_data(data)
  # Parse data into crate stacks and instructions
  # Read in crate_data top-down, outputs stacks bottom-up
  crate_length = 3  # each crate is 3 chars
  num_crates = (length(data[1]) + 1) / (crate_length + 1)
  crate_stacks = Dict(Int(k) => [] for k in 1:num_crates)
  instructions = []
  for line in data
    if startswith(line, "move")
      # instruction
      push!(instructions, parse_instruction(line))
    else
      if startswith(strip(line), "[")
        # Row of crates
        # Read in batches of 'crate_length'
        for i in 1:crate_length+1:length(line)
          crate_str = line[i:i+crate_length-1]
          crate_num = index_to_crate_num(i + 1; crate_length=crate_length)
          if (is_crate(crate_str))
            push!(crate_stacks[crate_num], get_crate(crate_str))
          else
            push!(crate_stacks[crate_num], nothing)
          end
        end
      elseif startswith(strip(line), r"[0-9]")
        # Bottom row, crate numbers
      else
        # blank line
      end
    end
  end
  # Reverse each stack of crates to be able to push to end
  for k in keys(crate_stacks)
    reverse!(crate_stacks[k])
    filter!(x -> !isnothing(x), crate_stacks[k])
  end
  return crate_stacks, instructions
end

function move_crates!(crate_stacks, instructions; lift_multiple=false, verbose=false)
  # Executes instructions line-by-line, changing crate_stacks inplace
  for (i, instruction) in enumerate(instructions)
    # Move 'num' crates from 'source' to 'target'
    source = crate_stacks[instruction["source"]]
    target = crate_stacks[instruction["target"]]
    num = instruction["num"]
    if (lift_multiple)
      crates = source[end-(num-1):end]
    else
      crates = reverse(source[end-(num-1):end])
    end
    idxs = []
    if (verbose)
      println("Before")
      print_stacks(crate_stacks)
    end
    for (i, crate) in enumerate(crates)
      push!(target, crate)
      push!(idxs, length(source) - (i - 1))
    end
    deleteat!(source, sort!(idxs))
    if (verbose)
      println("After")
      print_stacks(crate_stacks)
    end
  end
  return crate_stacks
end

function find_top_crates(crate_stacks)
  # Return the topmost crate in each stack
  return join([crate_stacks[k][end] for k in sort(Int.(keys(crate_stacks)))])
end

function main()
  # data = readlines("./data/day_05_test.txt")
  data = readlines("./data/day_05.txt")
  crate_stacks, instructions = parse_data(data)
  # Part 1
  crate_stacks_1 = move_crates!(deepcopy(crate_stacks), instructions; lift_multiple=false)
  top_crates_1 = find_top_crates(crate_stacks_1)
  @show top_crates_1
  # Part 2
  crate_stacks_2 = move_crates!(deepcopy(crate_stacks), instructions; lift_multiple=true)
  top_crates_2 = find_top_crates(crate_stacks_2)
  @show top_crates_2
end

main()
