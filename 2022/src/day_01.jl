function main()
  # data = readlines("./data/day_01_test.txt")
  data = readlines("./data/day_01.txt")

  # Task 1
  # Count up each group's cals and find the one with the greatest
  cals = []
  current_sum = 0
  for line in data
    if length(line) == 0
      # End group
      push!(cals, current_sum)
      current_sum = 0
    else
      # Add to sum
      current_sum += parse(Int, line)
    end
  end
  # EOF, last line
  push!(cals, current_sum)
  # Sort in descending order
  sort!(cals; rev=true)
  # Part 1
  @show cals[1]
  # Part 2
  @show sum(cals[1:3])
end

main()