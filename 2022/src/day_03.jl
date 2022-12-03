function find_duplicates(line1, line2)
	# Find duplicate characters between two lines
	all_duplicates = []
	for item in line1
		if (item in line2)
			push!(all_duplicates, item)
		end
	end
	return all_duplicates
end

function compute_priority(c::Char)
	if (isuppercase(c))
		return Int(c) - 38
	else
		return Int(c) - 96
	end
end

function main()
	# data = readlines("./data/day_03_test.txt")
	data = readlines("./data/day_03.txt")

	# First half of string is compartment 1, second half is compartment 2
	# Part 1: Find common items in each compartment
	duplicate_sum = 0
	# Part 2: Find common item in running 3 groups
	line_count = 0
	elf_groups = []
	badge_sum = 0
	for line in data
		# Part 1: Find common character in each compartment
		half_idx = floor(Int, length(line) / 2)
		items_c1 = line[1:half_idx]
		items_c2 = line[half_idx+1:end]
		all_duplicates = find_duplicates(items_c1, items_c2)
		item_duplicate = unique(all_duplicates)[1]
		duplicate_sum += compute_priority(item_duplicate)
		# Part 2: Find common character in each 3-line segment
		push!(elf_groups, line)
		line_count += 1
		if line_count >= 3
			# Find common item in all 3
			# Sort by line length
			sort!(elf_groups)
			duplicates_1::Array{Char} = find_duplicates(elf_groups[1], elf_groups[2])
			duplicates_badge = unique(find_duplicates(String(duplicates_1), elf_groups[3]))
			badge_sum += compute_priority(duplicates_badge[1])
			# New group of elves
			line_count = 0
			elf_groups = []
		end
	end
	@show duplicate_sum
	@show badge_sum
end

main()