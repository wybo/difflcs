= Diff Longest Common Sub String -- The diff sniffing out every move

A resonably fast diff algoritm using longest common substrings that
can also find text that has moved.

PositionRange is a library by the LogiLogi Foundation, extracted from
http://www.logilogi.org (http://foundation.logilogi.org).

== Usage

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
     },

As you see it can sniff out text that has moved too.

A minimum overlap size can be provided for speed purposes, and to
prevent too many matches;

  > DiffLCS.diff('123456789'.split(''), '120678934'.split(''), :minimum_lcs_size => 3)
  => {
       :matched_old => PositionRange::List.from_s('5,9'),
       :matched_new => PositionRange::List.from_s('3,7')
     },


Diff can be called directly on strings too, if 'diff_l_c_s/string' is required.

  > require 'diff_l_c_s/string'
  > '123'.diff('321')
  => {
       :matched_old=>[2...3, 1...2, 0...1],
       :matched_new=>[0...1, 1...2, 2...3]
     }

== Download

The latest version of Diff LCS can be found at:

* http://rubyforge.org/frs/?group_id=7565

Documentation can be found at:

* http://difflcs.rubyforge.org

== Installation

You can install Diff LCS with the following command:

  % [sudo] gem install difflcs

Or from its distribution directory with:

  % [sudo] ruby install.rb

== License

Diff LCS is released under the GNU Affero GPL licence.

* http://www.fsf.org/licensing/licenses/agpl-3.0.html

== Support

The Diff LCS homepage is http://difflcs.rubyforge.org.

For the latest news on Diff LCS:

* http://foundation.logilogi.org/tags/DiffLCS

Feel free to submit commits or feature requests. If you send a patch,
remember to update the corresponding unit tests.
