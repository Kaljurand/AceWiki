path="."

g1="WildlifeAce.gf"
g2="AcewikitestAce.gf"

# It's not possible to go over 3 with AcewikitestAce.gf
depth=3

#echo "generate_trees -depth=$depth | l" | gf --run --path $path ${g1}
echo "generate_trees -depth=$depth | l" | gf --run --path $path ${g2}
