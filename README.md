# mkpass
Generate a secure, memorable password using the XKCD 936 method

[https://imgs.xkcd.com/comics/password_strength.png]

# Example usage

    $ ./mkpass
    grown hole issuing wears

Although it is simple for a human to make up a story to memorize these
four words, this passphrase is actually quite strong: it would take
185 years for current computers to crack it.

Note that only common words are used and the words are alphabetized.
This corrects a common problem with most XKCD 936 implementations:
they make overly strong passwords that are not easily memorizable,
which misunderstands the whole purpose of XKCD 936.

It is suggested, for best security, to accept the first passphrase
rather than running mkpass repeatedly to find something that suits you
better.

## Compliance with XKCD 936 Standard

There is are two differences between this implementation
and the method described in XKCD 936.

### 1. Alphabetized word list

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
second), but is actually compensated for by the second change, below.

### 2. Doubled dictionary size. 

The XKCD 936 standard states that four random words from a dictionary
is equal to 2^44 bits of entropy. This would be true if the dictionary
contains 2048 words (2^11), but typical dictionaries are much larger.

The default UNIX word list (`/usr/share/dict/words` on a GNU system)
contains over 2^16 words (65536). Using this list makes passphrases
that are almost useless because they are difficult to memorize. For
example,

    # Using /usr/share/dict/words
    cautionary continually departmentalizes intellectualizes

Since memorizability is the whole point, we need a list of _common_
words. The SCOWL package (`apt install scowl`) contains
`/usr/share/dict/scowl/english-words.10`, a list of the most frequent
10% of English words. As you can see, it makes much better
passphrases:

    # Scowl's /usr/share/dict/scowl/english-words.10.
    books ditto pushing stones

But are simple words like that too weak? Turns out, no, it's actually
_stronger_ than required. The top 10% of English words happens to be a
little over 2^12 (4096) words long, which is one bit more than the
2^11 words XKCD 936 calls for. Since we are picking four words, this
increases the total amount of entropy by 4 bits.

### The upshot? Equivalent for most people. 

Alphabetizing the passphrase (-4.58), but using a dictionary that is
twice as long (+4) results in a passphrase that is only slightly
weaker (-0.58 bits) than the XKCD 936 specification. This means instead
of taking 278 years, it'd take 185 years to crack (at 1000 guesses per
second).

# Other alternatives

If you don't like `mkpass`, maybe you'll like one of these other XKCD 936 inspired tools:

* Ben Finney's
  [`xkcdpass`](https://github.com/redacted/XKCD-password-generator). A
  command line tool with *lots* of options. For example, you could ask
  it to give you a phrase that spells out CHAOS and it'd tell you:
  `cradle helot axial ordure shale`. Easily installable using `apt
  install xkcdpass`.

* John Van Der Loo's
  [CorrectHorseBatteryStaple.net](CorrectHorseBatteryStaple.net). A
  Javascript web page. Great for people who aren't comfortable at the
  command line.

## Difference of mkpass from other implementations

* Alphabetized words makes the phrase more human friendly with little
  loss in security.

* Mkpass uses a smaller dictionary and only four words, as recommended
  in XKCD 936, for easily remembered passphrases.</br></br> _XKCD 936's
  purpose was to show that strong passwords could be memorizable. Some
  implementations defeat that purpose by trying to make the passwords
  overly strong. A real example: "fractious bustling fussy realm
  veining undying"._
  
* Mkpass does not add superfluous changes or require a minimum length.</br></br>
  _For example, correcthorsebatterystaple.net adds capitalization,
  dashes, and a random number. It also has a minimum length, which has
  negative security benefits. Normally, longer passwords are better,
  but when using a generator like this, you're actually restricting
  the set of possible passwords, thus reducing entropy and making the
  passwords both weaker *and* harder to memorize._

* While installation of mkpass is simple (just download the script and
  run it), it is not as easy to install as other tools which can be
  accessed on the web (correcthorsebatterystaple.net) or installed
  using the OS package manager (`apt install xkcdpass`).

| Password generator name       | Bits of Entropy | Example output               |
|-------------------------------|-----------------|------------------------------|
| XKCD 936 canonical example	| 44   	  	  | correct horse battery staple |
| mkpass   	     		| 43.42		  | evening live power suit 	 |
| correcthorsebatterystaple.net | 59.05		  | Sacrifice-Fashion-Repetition-Shine-8 |
| Ben Finney's xkcdpass         | 99.59		  | nonhuman boulevard covert hardcover tracer acrobat |


# TO DO

* Remove reliance on external dictionaries. Just include the wordlist
  in this shell script.

* Add options to allow different strength passwords.

* If I find a libre wordlist that has the words listed in frequency
  order instead of alphabetical, then I can let people choose how
  strong of a password they want. (Could select in terms of bits,
  years, or just "easy", "medium", "hard").

