# https://adventofcode.com/2021/day/4
using AdventOfCode
using InvertedIndices

input = readlines("./data/day_04.txt")
# First line is drawn numbers, each board is separated by ""

function load_boards(input)
  boards = []
  draws = []

  current_board = []
  for (i, line) in enumerate(eachrow(input))
    if i == 1
      for val in split(line[1], ',')
        push!(draws, parse(Int, val))
      end
      continue
    end
    if line[1] == ""
      if length(current_board) > 0
        current_board = reduce(hcat, current_board)
        push!(boards, current_board')
        current_board = []
      end
      continue
    else
      push!(current_board, [parse(Int, val) for val in split(line[1])])
    end
  end
  current_board = reduce(hcat, current_board)
  push!(boards, current_board')
  # Reshape into a 3D array
  reshaped = fill(0, (size(boards[1])[1], size(boards[1])[1], length(boards)))
  for (i, board) in enumerate(boards)
    for (j, row) in enumerate(eachrow(board))
      for (k, val) in enumerate(row)
        reshaped[j, k, i] = val
      end
    end
  end
  scoreboards = fill(0, size(reshaped))  # '1s' signify a 'hit'
  return draws, reshaped, scoreboards
end

function sum_unmarked(scoreboard, board)
  unmarked_idxs = findall(x->(x==0), scoreboard)
  return reduce(+, board[unmarked_idxs])
end

function check_bingo(scoreboards, boards; return_sum = true, ignore_boards=[])
  # Check if row/col sums to 5
  # If 'bingo', return sum of unmarked numbers on winning board OR board index
  for k in 1:size(scoreboards)[3]
    if k in ignore_boards
      continue
    end
    scoreboard = scoreboards[:, :, k]
    board = boards[:, :, k]
    for row in eachrow(scoreboard)
      if reduce(+, row) == 5
        return return_sum ? sum_unmarked(scoreboard, board) : k
      end
    end
    for col in eachcol(scoreboard)
      if reduce(+, col) == 5
        return return_sum ? sum_unmarked(scoreboard, board) : k
      end
    end
  end
  
  return nothing
end

function part_1(input)
  draws, boards, scoreboards = load_boards(input)
  # Draw number sequentially and mark off on "scoreboards"
  for draw in draws
    for i in 1:size(boards)[1]
      for j in 1:size(boards)[2]
        for k in 1:size(boards)[3]
          if boards[i, j, k] == draw
            scoreboards[i, j, k] = 1
            # Check for bingo
            bingo = check_bingo(scoreboards, boards; return_sum = true)
            if bingo !== nothing
              return bingo * draw
            end
          end
        end
      end
    end
  end
end
@info part_1(input)

function part_2(input)
  # Now we find which board wins last
  draws, boards, scoreboards = load_boards(input)
  max_wins = size(boards)[3]
  bingo_counter = fill(0, max_wins)
  # Draw number sequentially and mark off on "scoreboards"
  for draw in draws
    for i in 1:size(boards)[1]
      for j in 1:size(boards)[2]
        for k in 1:size(boards)[3]
          if boards[i, j, k] == draw
            scoreboards[i, j, k] = 1
            # Check for bingo
            index = check_bingo(scoreboards, boards; return_sum = false, ignore_boards = findall(x->x==1, bingo_counter))
            if index !== nothing
              bingo_counter[index] = 1
              if reduce(+, bingo_counter) == max_wins
                return sum_unmarked(scoreboards[:, :, index], boards[:, :, index]) * draw
              end
            end
          end
        end
      end
    end
  end
end
@info part_2(input)
