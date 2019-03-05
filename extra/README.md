# Using a corpus

Some words are easier to remember, particularly words we've personally
used when writing in our e-mail or books read to us as children. With
out losing any strength in the passphrase, we can make a dictionary of
those words (called a _corpus_) and use that to make a passwords from.
Just create a file of words, one per line, then specify that filename
as an argument to `mkpass`. For a reasonably strong passphrase, you'll
need at least 2048 words, but 4096 is preferred.

Note that choosing your own corpus is not done to increase security,
but neither does it reduce security. This program will generate secure
passphrases even presuming everyone knows what corpus you are using.

# Example: Andrew Lang's "The {Blue,Brown,Crimson,Green,Grey,Lilac,Olive,Orange,Pink,Red,Violet,Yellow} Fairy Book"

I grew up listening and reading fairy tales, so words from those books
are much easier for me to remember. Here is what passphrases look like
if we use Andrew Lang's _${COLOR}_ Fairybooks as a corpus.

    $ ./mkpass extra/wordlist.2048	# Strength:  11 years
    fishes leave mice welcome

    $ ./mkpass extra/wordlist.4096	# Strength: 185 years
    goat hero hideous horrible

As usual, it's a bad idea to use a wordlist that is too long. In this
case it is even more important as there will be nonce words (words
used only once). Here is a particularly poor example that I was able
to generate (although most weren't this bad) using list with 21765
words.

    $ ./mkpass extra/wordlist.all	# Strength: 40,291 years
    imagined ravaged shunneth times

# Generating your own corpus and wordlists

There are two steps to generating a corpus:

1. download ASCII versions of all the books (or email messages or whatever has words you are familiar with), and 
2. create a list of the top 4096 most frequent words.

There are two scripts to help with those tasks:
[`getcorpus.sh`](getcorpus.sh) and [`wordfreq`](wordfreq).

## getcorpus.sh

In this directory, you will find a shell script called
[`getcorpus.sh`](getcorpus.sh) which searches [Project
Gutenburg](http://www.gutenburg.org) for public domain books. Just
edit the variables at the top of the file to search for what you want:

    language="english"
    author="andrew lang"
    title="fairy"
    subject=""

Running the script does the following steps:

1. Downloads the first 25 books, creating files named like `503.txt`.
1. Transcodes Latin-1 and UTF-8 to plain ASCII, if needbe.
1. Strips boilerplate headers and footers. (Without this step, one of
the most common words would be "Gutenburg"!)

## wordfreq

The script named [`wordfreq`](wordfreq) creates wordlists usable by
`mkpass` from every `.txt` file in the current directory.

When run `wordfreq` does the following:

1. Reads words from `*.txt` in the current directory 1. Cleans up
characters in the file (removing non-letters, but trying to leave in
hyphens and apostrophes

By default
it creates two: [`wordlist.4096`](wordlist.4096),
[`wordlist.2048`](wordlist.2048), which are the top 4096 and the top
2048 most frequent words.


### wordlist.all (optional)

`wordfreq` also creates a file with a list of all words sorted by
frequency, [`wordlist.all`](wordlist.all). Remember, don't use it
directly for password creation as it contains hard to remember nonce
words. It also includes words that have capital letters, apostrophes,
or hyphens. (Note: `mkpass` automatically ignores such words).

`wordlist.all` exists so you can, if you feel like it, create a customized
length wordlist. You can balance convenience versus security by taking
the top _n_ words using the `head` command:

    $  grep '^[a-z]*$' extra/wordlist.all | head -3000 >extra/wordlist.3000

    $ ./mkpass -v extra/wordlist.3000 
    Debug: Size of extra/wordlist.3000 is 3000
    Debug: Number of words is 4
    Debug: Bits of entropy in dictionary: >=46
    Debug: Bits lost from sorting 4 words: <=5
    Debug: Total bits of entropy in pass: >=41
    Debug: Average time to crack (@ 1000 guesses/s): >=53 years
    amused hut palace shoe

