#!/bin/bash

# getcorpus.sh: Get a selection of books (a "corpus") from Project
# Gutenburg and convert them to ASCII (if need be).

# b9 2018

# This will download a maximum of 25 books (the search result size).
# Filenames are all digits followed by ".txt". (E.g., "36532.txt")

# You can modify the search query below with author, title, or subject.
# Default is Andrew Lang's "The
# {Blue,Brown,Crimson,Green,Grey,Lilac,Olive,Orange,Pink,Red,Violet,Yellow}
# Fairy Book"


url="https://www.gutenberg.org/ebooks/search/?query="
language="english"
author="andrew lang"
title="fairy"
subject=""

######################################################################

degutenfy() {
    # Trim the Project Gutenberg standard headers and footers before we
    # count up the word frequencies. (Otherwise "Gutenberg" is always one
    # of the most popular words!)
    sed -r '1,/(START OF.*GUTENBERG|END THE SMALL PRINT)/ d;
	      /(END OF.*GUTENBERG|End of.*Gutenberg)/,$ d;'
}

url="$url"$(for f in $language; do echo -n "+l.$f."; done)
url="$url"$(for f in $author; do echo -n "+a.$f."; done)
url="$url"$(for f in $title; do echo -n "+t.$f."; done)
url="$url"$(for f in $subject; do echo -n "+s.$f."; done)

echo "$url"
if [ -r debug.html ]; then
    html=$(cat debug.html)	# Let's not tromple the PG server while testing
else
    html=$(curl "$url")
fi

ebooknumbers=$(echo "$html" | grep -Po '(?<=ebooks/)[0-9]+')

gutfile=www.gutenberg.org/files
for book in $ebooknumbers; do
    echo $gutfile/$book/$book.txt
    if ! wget --no-clobber https://$gutfile/$book/$book.txt; then

	# Prefer the plain ASCII version, but download UTF-8 if needbe.
	echo "No plain ASCII version found." >&2
	if wget --no-clobber https://$gutfile/$book/$book-0.txt; then
	    echo "Found Unicode. Presuming UTF-8 and converting to ASCII." >&2
	    iconv -f UTF-8 -t ASCII//TRANSLIT < $book-0.txt > $book.txt
	elif wget --no-clobber https://$gutfile/$book/$book-8.txt; then
	    echo "Found 8-bit. Presuming Latin-1 and converting to ASCII." >&2
	    iconv -f 8859_1 -t ASCII//TRANSLIT < $book-8.txt > $book.txt
	else
	    echo "Couldn't find UTF-8 or Latin1, either. Skipping $book." >&2
	    continue
	fi

    fi

    # Remove standard project gutenberg headers and footers
    degutenfy < $book.txt > temp.txt
    if [ -s temp.txt ]; then
	mv $book.txt $book.txt.orig
	mv temp.txt $book.txt
    else
	rm temp.txt
    fi

done


