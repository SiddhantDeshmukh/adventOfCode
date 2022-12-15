function data_to_matrix(data::Array{String})
  # Convert the input data into a matrix of ints
  matrix = Array{Int}(undef, length(data), length(data[1]))
  for (i, row) in enumerate(data)
    for (j, c) in enumerate(row)
      matrix[i, j] = parse(Int, c)
    end
  end
  return matrix
end

function visibility_array(matrix::Array{Int}, i::Int, j::Int; direction="left")
  # Calculate the boolean array of visibility values for a given direction
  visibility_calcs = Dict(
    "top" => matrix[i, j] .> matrix[1:i-1, j],
    "down" => matrix[i, j] .> matrix[i+1:end, j],
    "left" => matrix[i, j] .> matrix[i, 1:j-1],
    "right" => matrix[i, j] .> matrix[i, j+1:end]
  )
  return visibility_calcs[direction]
end

function is_greater_col(matrix::Array{Int}, i::Int, j::Int, row_len::Int)
  # Check if val matrix[i, j] is greater than all other values in the row
  # Check left and right separately
  visible_top = sum(visibility_array(matrix, i, j; direction="top")) == i - 1
  visible_down = sum(visibility_array(matrix, i, j; direction="down")) == row_len - i
  return visible_top || visible_down
end

function is_greater_row(matrix::Array{Int}, i::Int, j::Int, col_len::Int)
  # Check if val matrix[i, j] is greater than all other values in the col
  # Check top and down separately
  visible_left = sum(visibility_array(matrix, i, j; direction="left")) == j - 1
  visible_right = sum(visibility_array(matrix, i, j; direction="right")) == col_len - j
  return visible_left || visible_right
end

function score_array(arr::BitVector)
  # Count up 1s until we hit a zero
  score::Int = 0
  for v in arr
    if (v == 0)
      score += 1
      return score
    else
      score += 1
    end
  end
  return score
end

function visibility_score(matrix::Array{Int}, i::Int, j::Int)
  # Consider each direction separately
  dirs = ["left", "right", "top", "down"]
  visibilities = Dict(k => visibility_array(matrix, i, j; direction=k) for k in dirs)
  # Since we look out from the tree, we need to reverse the 'left' and 'top'
  reverse!(visibilities["left"])
  reverse!(visibilities["top"])
  score = reduce(*, [score_array(visibilities[k]) for k in dirs])
  return score
end

function num_visible_row_col(matrix::Array{Int})
  # Count the number of visible trees, considering only rows and cols
  num_visible::Int = 0
  num_x, num_y = size(matrix)
  for i in axes(matrix, 1)
    for j in axes(matrix, 2)
      if (i == 1) || (j == 1) || (i == num_x) || (j == num_y)
        # All outside trees are visible by default
        num_visible += 1
        continue
      end
      # Check if current val is strictly greater than all other in row/col
      if (is_greater_row(matrix, i, j, num_x) || is_greater_col(matrix, i, j, num_y))
        num_visible += 1
      end
    end
  end

  return num_visible
end

function most_scenic_tree(matrix::Array{Int})
  high_score::Int = 0
  for i in axes(matrix, 1)
    for j in axes(matrix, 2)
      score = visibility_score(matrix, i, j)
      if (score > high_score)
        high_score = score
      end
    end
  end
  return high_score
end


function main()
  # data = readlines("./data/day_08_test.txt")
  data = readlines("./data/day_08.txt")
  matrix = data_to_matrix(data)
  # Part 1
  # num_visible_p1 = num_visible_row_col(matrix)
  # @show num_visible_p1
  # Part 2
  scenic_score = most_scenic_tree(matrix)
  @show scenic_score
end

main()
