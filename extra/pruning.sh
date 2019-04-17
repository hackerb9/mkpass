#!/bin/bash

# Prune -ing, -ed, -s;  -ies, -ied (from -y)
#
# pasture   -> okay
# pastures  -> reject
# pasturing -> reject
# pastured  -> reject
# copy   -> okay
# copies -> reject
# copied -> reject

# Note: if a word is mainly used in the plural or as a gerund (e.g.,
# "lolling" is more common than "loll"), it should be kept. We can do
# that by simply checking if the root word is in our small corpus. If
# it is absent, then likely the word ought to be kept. This makes the
# algorithm easier for pruning as well, since we can check the corpus
# against itself instead of an external dictionary.

if [[ "$1" == "-v" ]]; then
    shift
    vflag=1;		       
else
    vflag=0;		       
fi

if [[ ! -s "$1" ]]; then
    echo "Usage: pruning.sh [wordlist.file] >output" >&2
    exit 1
fi

awk -v vflag=$vflag < "$1" '
{ dict[$1] = 1; }

END { for (s in dict) { 
	t=s;
	if (sub(/ing$/, "", t) == 1) {
	    if (t in dict) {
		verbose( t "+ing is " s);
		continue;
	    }
	    if (t "e" in dict) {
		verbose( t "e+ing is " s);
		continue;
	    }
	}
	t=s;
	if (sub(/s$/, "", t) == 1) {
	    if (t in dict) {
		verbose( t "+s is " s);
		continue;
	    }
	}
	t=s;
	if (sub(/ed$/, "", t) == 1) {
	    if (t in dict) {
		verbose( t "+ed is " s);
		continue;
	    }
	    if (t "e" in dict) {
		verbose( t "e+ed is " s);
		continue;
	    }
	}
	t=s;
	if (sub(/ies$/, "y", t) == 1) {
	    if (t in dict) {
		verbose( t "+ies is " s);
		continue;
	    }
	}
	t=s;
	if (sub(/ied$/, "y", t) == 1) {
	    if (t in dict) {
		verbose( t "+ied is " s);
		continue;
	    }
	}
	# Made it through all the tests. Seems good so print it out.
	print s;
      }
    }

function verbose(a) {
    if (vflag) print(a);
}

'
