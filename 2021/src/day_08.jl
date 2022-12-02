# https://adventofcode.com/2021/day/8
using AdventOfCode
import Base.sort

input = readlines("./data/day_08.txt")

charmatch(match, string) = all([occursin(char, string) for char in match])
filter_digit_segments(l) = Dict(k => v for (k,v) in digit_segments if length(v) == l)
filter_line(line, l) = [v for v in line if length(v) == l]
filter_segments_by_digit(segments, digit) = [s for s in segments if charmatch(digit, s)]
sort(s::String) = join(sort(collect(s)))

function digit_loss(digit_string, string)
  # A loss metric that defines how many missing components 'string' has compared
  # to 'digit_string'
  # e.g. '8' - '0' = 1 since '0' has every element from '8' except 1
  return length([v for v in [occursin(d, string) for d in digit_string] if v < 1])
end

function read_signals_values(input)
  signals, values = [], []
  for line in eachrow(input)
    split_line = split(line[1], " | ")
    push!(signals, split_line[1])
    push!(values, split_line[2])
  end
  return signals, values
end

function decode(value, digit_strings)
  for (digit, string) in digit_strings
    if length(string) == length(value)
      if charmatch(value, string)
        return digit
      end
    end
  end
  return nothing
end

function part_1(input)
  signals, values = read_signals_values(input)
  count = 0
  for line in eachrow(values)
    nums = split(line[1], " ")
    for n in nums
      if length(n) in [2, 3, 4, 7]
        count += 1
      end
    end
  end

  return count
end
@info part_1(input)

function part_2(input)
  # First note down unique digits, then use process of elimination to figure
  # out the 6-segment and 5-segment ones
  # When referring to digits, I'll use single quotes, e.g. '2'
  signals, values = read_signals_values(input)
  decoded_values = []
  for (i, line) in enumerate(eachrow(signals))
    digit_strings = Dict(i => "" for i in 0:9)  # digit => confirmed string of digit
    line = split(line[1], " ")
    # Add unique digits
    digit_strings[1] = filter_line(line, 2)[1]
    digit_strings[4] = filter_line(line, 4)[1]
    digit_strings[7] = filter_line(line, 3)[1]
    digit_strings[8] = filter_line(line, 7)[1]
    
    # Non-unique digits
    segment_6s = filter_line(line, 6)
    segment_5s = filter_line(line, 5)

    # 6-segment strings ('0, '6', '9')
    # '9' contains (all segments of) '4'
    digit_strings[9] = filter_segments_by_digit(segment_6s, digit_strings[4])[1]
    deleteat!(segment_6s, findall(x -> x == digit_strings[9], segment_6s))
    # '0' contains '7'
    digit_strings[0] = filter_segments_by_digit(segment_6s, digit_strings[7])[1]
    deleteat!(segment_6s, findall(x -> x == digit_strings[0], segment_6s))
    # '6' is the only 6-segment string left
    digit_strings[6] = segment_6s[1]

    # 5-segment strings ('2', '3', '5')
    # '3' contains '1'
    digit_strings[3] = filter_segments_by_digit(segment_5s, digit_strings[1])[1]
    deleteat!(segment_5s, findall(x -> x == digit_strings[3], segment_5s))
    # '5' contains all of '9' except 1 element; '2' would miss 2 elements
    losses = [digit_loss(digit_strings[9], s) for s in segment_5s]
    digit_strings[5] = segment_5s[losses .== 1][1]
    deleteat!(segment_5s, findall(x -> x == digit_strings[5], segment_5s))
    # '2' is the only 5-segment string left
    digit_strings[2] = segment_5s[1]
    # Decode!
    push!(decoded_values, parse(Int,
                                join([decode(val, digit_strings)
                                      for val in split(values[i], " ")])))
  end
  return reduce(+, decoded_values)
end
@info part_2(input)

