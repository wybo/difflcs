# Diff Longest Common Sub String
  "The diff sniffing out texts every move"

A resonably fast diff algoritm using longest common substrings that
can also detect text that has moved.

## Usage

First require it.

  $ irb

  > require 'rubygems'
  > require 'difflcs'

Then it can be used on any set of arrays, in this example 123456789
and 120678934, of which the first '12' overlaps, '0' is new, '34' has 
moved to the end, and '6789' overlaps too, but moved 2 positions to
the left.

NOTE: They are arrays, not strings.

  > DiffLCS.diff('123456789'.split(''), '120678934'.split('')) 
  => {
       :matched_old=>[0...2, 5...9, 2...4],
       :matched_new=>[0...2, 3...7, 7...9]
     }

As you see it can sniff out text that has moved too.

A minimum overlap size can be provided for speed purposes, and to
prevent too many matches;

  > DiffLCS.diff('123456789'.split(''), '120678934'.split(''), :minimum_lcs_size => 3)
  => {
       :matched_old => PositionRange::List.from_s('5,9'),
       :matched_new => PositionRange::List.from_s('3,7')
     }

Diff can be called directly on strings too, if 'diff_l_c_s/string' is required.

  > require 'diff_l_c_s/string'
  > '123'.diff('321')
  => {
       :matched_old=>[2...3, 1...2, 0...1],
       :matched_new=>[0...1, 1...2, 2...3]
     }

## Installation

Add this line to your application's Gemfile:

    gem 'difflcs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install difflcs

Feel free to report issues and to ask questions. For the latest news on
DiffLCS:

* http://foundation.logilogi.org/tags/DiffLCS

## Contributing

If you wish to contribute, please create a pull-request and remember to update
the corresponding unit test(s).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
