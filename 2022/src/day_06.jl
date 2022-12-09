function count_duplicates(str::String, substr_length::Int)
  # Find the first occurrence of a unique 'substr_length' substring in str
  for i in 1:length(str)-substr_length
    substr = str[i:i+substr_length-1]
    if allunique(substr)
      return i + substr_length - 1
    end
  end
end


function main()
  # data = readlines("./data/day_06_test.txt")
  data = readlines("./data/day_06.txt")
  idx_1 = count_duplicates(data[1], 4)
  @show idx_1
  idx_2 = count_duplicates(data[1], 14)
  @show idx_2
end

main()