newfile="day_$1.jl"
cp template.jl "${newfile}"
sed -i "s/XX/$1/g" $newfile
touch "./data/day_$1.txt"
touch "./data/day_$1_test.txt"