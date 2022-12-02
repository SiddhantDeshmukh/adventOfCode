# Advent of Code 2021

In this directory are my solutions to the Advent of Code 2021 puzzles done
in Julia. And I'll write my thoughts about each day's challenges below!

## Day 1 - Sonar Sweep

Today was focused on finite differencing arrays based on different windows.
Part 1, quite simply, involved computing a finite difference of the input
and counting the number of positive elements. Julia helpfully provides a
'diff' function that just does this, so for me this was a breeze.

Part 2 was more complicated, using a 3-element sliding window and the sum
of the elements. Keeping the finite differencing idea in mind, I looped
over the input in 3-element windows, summing each one and adding it to
an array. At the end, I applied the same finite difference
positive-counting method on this new array whose elements were the window
sums. All in all, a good start!

## Day 2 - Dive

I solved this using vectors, assigning coordinates [pos, depth] for part 1
and [pos, depth, aim] for part 2. The instructions for the submarine are
stored in a dictionary. In part 1, this dictionary contains the array that
should be multipled by the value 'X' to get the new [pos, depth]. In part 2,
the dictionary contains the 'forward', 'down', 'up' functions to directly
update the coordinates.

One way I could clean it up (but I won't since I want the solutions to be as-
attempted) is to package the loop over the 'input' into a function that updates
the coordinates at each step. Essentially, create an update function (rules)
for each part (Dict of functions) and then pass this Dict of instructions in as
well. The function should just return the final coords!

Update: I went ahead and did it in the 'learn' directory, which I'll use to
write improvements to the challenges!

## Day 3 - Binary Diagnostic

Part 1 waws pretty straightforward but I struggled to finish part 2 in Julia.
I spent a lot of time trying to come up with mathematical tricks to avoid
looping, but in the end just bit the bullet and wrote out the loops. Oh
well, would love to improve the code!

## Day 4 - Squid Bingo

Difficulty is picking up! I spent a long time trying to figure out how to create
a 3D array in Julia from the input provided, and eventually just resigned
myself to looping. Really hope there's a nicer way to turn an array of 2D arrays
into a 3D array (and higher order versions)! After figuring out the data, part 1
was a little finnicky because there were lots of small things I had to check
for. In the end, I added a 'scoreboard' for each bingo board that was
initialised with zeroes. For every 'hit', the corresponding scoreboard value
would become 1. This makes it easy to check for a bingo!

I really think my code is too long, but I can't find a nicer way to do it; a
quarter is just to load in the data! I suspect there is a much better way to
do for loops akin to 'itertools.product' (or at least to go over every index).
Part 2 wasn't much harder because of the way I'd written the code, I just had
to change the rules for the 'win' condition. Onto the next one!

## Day 5 - Hydrothermal Ventures

Still struggling with arrays! I'm getting a little better at constructing
multidimensional ones and just discovered the 'cat' with 'dims' function
so that's nice. I spent a lot of time trying to abstract the code which is
why part 2 took a while today, but in the end I had to live with my split
conditional that filtered the order of indices depending on if we were
dealing with a diagonal line or not.

## Day 6 - Lanternfish

Was fun! Thanks to a hint I managed to avoid creating a large list (I was
shying away from it anyways) and instead made a 'growth_rate + 2' size
array that kept track of how many lanternfish were in each stage. The
update rule is just a scalar value 'num_6_increase' in the current
implementation, but it would be more interesting to make it a vector of
the same length as the fish counts so one could define arbitrary update
rules for the fish. Part 1 and part 2 were the same because of the method
I chose, which was a nice surprise.

## Day 7 - The Treachery of Whales

Nice simple one today! Part 1 was simply the median, part 2 involved a
minimisation on a custom loss. There's probably a statistics analogue to this
as well but I just brute-forced it by iterating through the array since it was
only 1000 elements or so. Wrote a nice function that takes in the loss function
as an argument to easily calculate these and learnt about types!

## Day 8 - Seven Segment Search

I've come back on the 20th to binge the puzzles and this one took a few hours
to get right! I settled on identifying digits uniquely by comparing them to
digits I had already identified (a sort of boolean mask) and 'subtracting' their
segments from one another (custom loss metric). There are a few things that
could be cleaned up, namely figuring out how to zip my (signals, values), a
cleaner way to filter and delete segment lists, and better multiple dispatch
support. I wrote a lot of one-liners for this one since I used a lot of
comprehensions (which naturally fit quite nicely into a one-liner).

## Day 9 - Smoke Basin

I feel like there was a better way to solve part 1 using a kernel to slide
across the input and select the allowed neighbours. I just did it the brute
force way, though. And in part 2, I cheated by using the Images library to find
and label components, then a nice snippet from SO that gave me the elements
(but that part is simple, since the components are already labelled). Another
idea that might be useful in the future is to build up a graph, then do the DFS
to identify connected components. For a grid, the graph would be pretty big but
I wonder if it's tractable.

## Day 10 - Syntax Scoring

Took me a while to get going, but the way I solved part 1 automatically solved
part 2 since I was keeping track of which closing brackets were necessary.

## Day 11 - Dumbo Octopus

Just like 10, took me a bit to get going (I'm still bad at recursion), but I
managed to do it all without needing to look much up! Struck me as quite similar
to a Game of Life, and even though I haven't written many, I was able to piece
together the essentials to get this to work. Again, part 2 is free after part 1.

## Day 12 - Passage Pathing

First time I've had to write a pathfinding algorithm with rules, I think! It was
quite fun, but took me a really long time to do properly. I kept getting stuck
in infinite loops because I popped the visited nodes too soon or messed up a
rule. It also took me a good hour to get to grips with Julia OOP -> and I have
to say the way I did it makes it really convoluted for part 2. Instead, I should
have created external functions that operated on the struct. Turns out my part 2
logic was almost correct for a while, but I had '<=2' instead of '<2'...

## Day 13 - Transparent Origami

## Day 14 - Extended Polymerization

I had to rewrite all of part 1 because I fell into the classic trap of actually
making the polymer. I didn't realise until a while later that only the numbers
of pairs matter, not their order.

## Day 15 - Chiton
