# https=//adventofcode.com/2021/day/10
using AdventOfCode

input = readlines("./data/day_10.txt")

function score_line(line)
  # Returns a positive value for syntax errors, and a negative value for
  # autocompletion (incomplete line)
  open_to_close = Dict(
    '('=> ')',
    '['=> ']',
    '{'=> '}',
    '<'=> '>'
  )
  close_to_open = Dict(v => k for (k, v) in open_to_close)
  syntax_scores = Dict(
    ')'=> 3,
    ']'=> 57,
    '}'=> 1197,
    '>'=> 25137
  )
  autocomplete_scores = Dict(
    ')'=> 1,
    ']'=> 2,
    '}'=> 3,
    '>'=> 4
  )
  # I should encounter closers in the opposite order as openers
  current_open = []
  expected_closers = []
  for char in line
    if char in keys(open_to_close)
      # New bracket opened
      push!(current_open, char)
      push!(expected_closers, open_to_close[char])
      continue
    end

    if char in values(open_to_close)
      # Bracket closed
      if !(char == last(expected_closers))
        # Line is corrupted, return syntax error score
        return syntax_scores[char]
      end
      deleteat!(current_open, findlast(x -> close_to_open[x] == close_to_open[char], expected_closers))
      deleteat!(expected_closers, findlast(x -> x == char, expected_closers))
      continue
    end
  end
  # Line is not corrupt, but incomplete
  score = 0
  for closer in reverse(expected_closers)
    score = 5 * score + autocomplete_scores[closer]
  end
  return -score
end



function part_1_2(input)
  syntax_scores = []
  autocomplete_scores = []
  for (i, line) in enumerate(eachrow(input))
    score = score_line(line[1])
    if score > 0
      push!(syntax_scores, score)
    end
    if score < 0
      push!(autocomplete_scores, -score)
    end
  end
  middle_idx = ceil(Int, length(autocomplete_scores) / 2)
  return reduce(+, syntax_scores), sort(autocomplete_scores)[middle_idx]
end
@info part_1_2(input)