function parse_section(section)
	# Get the start and end values from the section string
	vals = parse.(Int, split(section, "-"))
	return vals
end

function fully_contained_check(bounds_1, bounds_2)
	return (bounds_1[1] <= bounds_2[1]) && (bounds_1[2] >= bounds_2[2])
end

function contains(bounds, num)
	# Check if 'num' is within 'bounds'
	return (bounds[1] <= num) && (num <= bounds[2])
end

function overlap_check(bounds_1, bounds_2)
	# Check if either bounds of '2' are in between '1'
	return ((contains(bounds_1, bounds_2[1])) || (contains(bounds_1, bounds_2[2])))
end

function is_fully_contained(lims_1, lims_2)
	# Part 1
	# Check if one section fully contains another, i.e. check the bounds
	return (fully_contained_check(lims_1, lims_2) || fully_contained_check(lims_2, lims_1))
end

function has_overlap(lims_1, lims_2)
	# Part 2
	# Checks if there is any overlap between sections at all
	return (overlap_check(lims_1, lims_2) || overlap_check(lims_2, lims_1))
end

function main()
	# data = readlines("./data/day_04_test.txt")
	data = readlines("./data/day_04.txt")
	num_fully_contained = 0
	num_overlap = 0
	for line in data
		# Split line by comma, this gives the assingnment sections
		section_1, section_2 = split(line, ",")
		lims_1 = parse_section(section_1)
		lims_2 = parse_section(section_2)
		num_fully_contained += Int(is_fully_contained(lims_1, lims_2))
		num_overlap += Int(has_overlap(lims_1, lims_2))
	end
	@show num_fully_contained
	@show num_overlap
end

main()