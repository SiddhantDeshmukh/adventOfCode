function score_game_1(v1, v2)
  # v1 is opponent, v2 is us
  scoring = Dict(
    "R" => 1,
    "P" => 2,
    "S" => 3
  )

  # R < P, P < S, S < R
  if v1 == v2  # draw
    return 3 + scoring[v2]
  end
  if v1 == "R"
    if v2 == "S"  # loss
      return 0 + scoring[v2]
    else  # v2 = "P", win
      return 6 + scoring[v2]
    end
  elseif v1 == "P"
    if v2 == "S"  # win
      return 6 + scoring[v2]
    else  # v2 = "R", loss
      return 0 + scoring[v2]
    end
  elseif v1 == "S"
    if v2 == "R"  # win
      return 6 + scoring[v2]
    else  # v2 = "P", loss
      return 0 + scoring[v2]
    end
  end
end

function score_game_2(v1, v2)
  # 'v1' is opponent, 'v2' is how round needs to end
  # Rules map opp value to (loss, win)
  scoring = Dict(
    "R" => 1,
    "P" => 2,
    "S" => 3,
    "X" => 0,
    "Y" => 3,
    "Z" => 6
  )
  rules = Dict(
    "R" => Dict("X" => "S", "Y" => "R", "Z" => "P"),
    "P" => Dict("X" => "R", "Y" => "P", "Z" => "S"),
    "S" => Dict("X" => "P", "Y" => "S", "Z" => "R")
  )
  choice = rules[v1][v2]
  return scoring[choice] + scoring[v2]
end

function main()
  # data = readlines("./data/day_02_test.txt")
  data = readlines("./data/day_02.txt")
  # First col is opponent: A -> Rock, B -> Paper, C -> Scissors
  # Part 1
  # Second col is us: X -> Rock, Y -> Paper, Z -> Scissors
  # Set up dicts
  lookup = Dict(
    "A" => "R",  # r
    "B" => "P",  # p
    "C" => "S",  # s
    "X" => "R",  # r
    "Y" => "P",  # p
    "Z" => "S"  # s
  )
  # Scoring: type we chose + (0, loss; 3, draw; 6, win)
  scores_1 = []
  scores_2 = []
  for line in data
    v1, v2 = split(line)
    push!(scores_1, score_game_1(lookup[v1], lookup[v2]))
    push!(scores_2, score_game_2(lookup[v1], v2))
  end
  @show sum(scores_1)
  @show sum(scores_2)
end

main()