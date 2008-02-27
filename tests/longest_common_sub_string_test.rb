#! /usr/bin/env ruby
#--#
# Copyright: (c) 2006-2008 The LogiLogi Foundation <foundation@logilogi.org>
#
# License:
#   This file is part of the Diff-LongestCommonSubString library. Diff-
#   LongestCommonSubString is Free Software. You can run/distribute/modify 
#   Diff-LongestCommonSubString under the terms of the GNU Affero General 
#   Public License version 3. The Affero GPL states that running a modified
#   version or a derivative work also requires you to make the sourcecode of
#   that work available to everyone that can interact with it. We chose the
#   Affero GPL to ensure that Diff-LongestCommonSubString remains open and
#   libre (doc/LICENSE.txt contains the full text of the legally binding
#   license).
#++#

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib",
    "#{File.dirname(__FILE__)}/../../position_range/lib") if __FILE__ == $0

require 'position_range'
require 'diff/longest_common_sub_string'
require 'diff/longest_common_sub_string/string'
require 'test/unit'

class LongestCommonSubStringTest < Test::Unit::TestCase
  def test_longest_common_sub_strings
    old_arr = 'abcde'.split('')
    new_arr = 'acdbe'.split('')
    
    diff_hash = Diff::LongestCommonSubString.longest_common_sub_strings(old_arr,new_arr)
    
    assert_equal PositionRange.new(2,4),
        diff_hash[:matched_old].first
    assert_equal PositionRange.new(1,3),
        diff_hash[:matched_new].first

    old_arr = 'aaaaablabbbbbbccccc'.split('')
    new_arr = 'aaaaakbbbbbbk'.split('')

    assert_equal({:matched_old => PositionRange::List.from_s('8,14:0,5'),
            :matched_new => PositionRange::List.from_s('6,12:0,5')},
        Diff::LongestCommonSubString.longest_common_sub_strings(old_arr,new_arr))
  end

  def test_diff
    similar = ['This is the first small diff test. Isn\'t it nice ? ']
    old_chunk_arr = similar.dup
    new_chunk_arr = [similar[0], 'Yes it is! Look! It works.']
    do_diff_test(similar, old_chunk_arr, new_chunk_arr)

    similar = [
        'We are now really into testing ',
        ' of hand-written - or is it typed ? - texts ',
        ' diffing (finding differences between two rows) ']
    old_chunk_arr = [similar[0], 'the sound process of', similar[2],
        'beauties of wizzardly', similar[1], '~']
    new_chunk_arr = [similar[0], 'all of it. We are happy with our world',
        similar[1], '&', similar[2], '=']
    do_diff_test(similar, old_chunk_arr, new_chunk_arr)
  end

  def do_diff_test(similar_chunk_arr, old_chunk_arr, new_chunk_arr)
    old = old_chunk_arr.join
    new = new_chunk_arr.join
    old_arr = old.split('')
    new_arr = new.split('')
    target_matched_old =
        self.get_position_range_list_for_ranges_of_in(
            similar_chunk_arr, old)
    target_matched_new =
        self.get_position_range_list_for_ranges_of_in(
            new_chunk_arr - (new_chunk_arr - similar_chunk_arr), new)
    assert_equal({:matched_old => target_matched_old,
            :matched_new => target_matched_new},
        Diff::LongestCommonSubString.diff(old_arr, new_arr, :minimum_lcs_size => 15))
  end

  def test_word_diff
    similar = ['This is the first small diff test. Isn\'t it nice ? ']
    old_chunk_arr = similar.dup
    new_chunk_arr = [similar[0], 'Yes it is! Look! It works.']
    do_word_diff_test(similar, old_chunk_arr, new_chunk_arr)

    similar = [
        'We are now really into testing ',
        ' of hand-written - or is it typed ? - texts ',
        ' diffing (finding differences between two rows) ']
    old_chunk_arr = [similar[0], 'the sound process of', similar[2],
        'beauties of wizzardly', similar[1]]
    new_chunk_arr = [similar[0], 'all of it. We are happy with our world',
        similar[1], 'Und', similar[2]]
    do_word_diff_test(similar, old_chunk_arr, new_chunk_arr)
  end

  def do_word_diff_test(similar_chunk_arr, old_chunk_arr, new_chunk_arr)
    old = old_chunk_arr.join
    new = new_chunk_arr.join
    target_matched_old =
        self.get_position_range_list_for_ranges_of_in(
            similar_chunk_arr, old)
    target_matched_new =
        self.get_position_range_list_for_ranges_of_in(
            new_chunk_arr - (new_chunk_arr - similar_chunk_arr), new)
    assert_equal({:matched_old => target_matched_old,
            :matched_new => target_matched_new},
        Diff::LongestCommonSubString.word_diff(old, new, :minimum_lcs_size => 3))
  end

  def test_string
    assert_equal({:matched_old => PositionRange::List.from_s('0,2:5,9:2,4'),
            :matched_new => PositionRange::List.from_s('0,2:3,7:7,9')},
        '123456789'.diff('120678934'))
  end

  ### Test helpers

  def get_position_range_list_for_ranges_of_in(substrings, string)
    p_r_l = PositionRange::List.new
    substrings.each {|substring|
      pos = string.index(substring)
      if pos
        p_r_l.push(PositionRange.new(pos, pos + substring.size))
      else
        raise StandardError, ' Substring not found'
      end
    }
    return p_r_l
  end
end
