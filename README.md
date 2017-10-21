# mkpass
Generate a secure, memorable password using the XKCD 936 method

[https://imgs.xkcd.com/comics/password_strength.png]

# Example usage


## Compliance with XKCD 936 Standard

There is are two differences between this implementation
and the method described in XKCD 936.

### Alphabetized word list

The first difference: the word list is alphabetized to make it easier
for humans to remember. The author (hackerb9) can remember the "story"
(_A horse says "that's a battery staple" and then somebody says
"correct"_) but can't always remember the order of the words. There
are only 24 different possible permutations, so it's easy for a
computer to try all of them, but it's a pain for a human to have to
type each one in.

    HORSE BATTERY STAPLE  CORRECT
    HORSE BATTERY CORRECT STAPLE
    HORSE CORRECT BATTERY STAPLE
    HORSE CORRECT STAPLE BATTERY
    HORSE STAPLE  BATTERY CORRECT
    HORSE STAPLE  CORRECT BATTERY
    ...which one was it?...    

More technically, by alphabetizing we lose 4.6 bits of entropy. This
would still reasonably hard to crack (~23 years at 1000 guesses per
second), but is actually compensated for by the second change.

### A small increase in dictionary size. 

The XKCD 936 standard states that four random words from a dictionary
is equal to 2^44 bits of entropy. This would be true if the dictionary
is of size 2^11, that is 2048 words. However, it's actually hard to
find a dictionary that small. The default UNIX word list contains over
2^16 words (which is way too many for humans). The SCOWL package
[/usr/share/dict/scowl/english-words.10] includes a dictionary of the
most frequent 10% of English words, which happens to be a little over
2^12 (4096) words long. Since we are picking four random words, this
increases the amount of entropy by 4 bits.

### The upshot: a wash

Alphabetizing the passphrase, but using a dictionary that is twice as
long results in a passphrase that is only slightly weaker (0.58 bits)
than the XKCD 936 specification. This means instead of taking 550
years, it'd take 366 years to crack at 1000 guesses per second. For
my purposes, this should be fine.  

## Difference from other implementations

* Other implementations use an unnecessarily large dictionary, which
  defeats the purpose of XKCD 936. (Seriously, who is going to
  remember "fractious bustling fussy realm veining undying", which is
  a real output from one of the other XKCD 936 inspired tools).
  
* Uses a smaller dictionary, as recommended in XKCD 936, for more
  easily remembered words

* Alphabetizing words makes the phrase more human friendly with little
  loss in security

### correcthorsebatterystaple.net

Example output: 

* Web based, which is nice
* Has a minimum word length, which makes memorization harder
* Uses a much too large dictionary
* Defaults to adding capitalization, dashes, and numbers 

### Ben Finney's xkcdpass (python)

Example output: nonhuman boulevard covert hardcover tracer acrobat

* Easily installable in Debian using `apt install xkcdpass`
* Uses a much too large dictionary
* Defaults to six words instead of four.
