
out="test-out"

mkdir $out

echo "Generating output with Normunds..."
sh test-genall.sh > normunds.txt
echo "Normalizing Normunds..."
cat normunds.txt | grep -v '^$' > ${out}/normunds_normalized.txt
echo "Normalizing AceWiki..."
cat acewiki.txt | sed -f wordform_changes.sed > ${out}/acewiki_normalized.txt

echo "Finding intersection..."
fgrep -xf ${out}/normunds_normalized.txt ${out}/acewiki_normalized.txt > ${out}/intersection.txt
