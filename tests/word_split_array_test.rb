#! /usr/bin/env ruby
#
#--#
# Author: Wybo Wiersma <wybo@logilogi.org>
#
# Copyright: (c) 2006 Wybo Wiersma
#
# License:
#   This file is part of the Diff-LongestCommonSubString library. Diff-
#   LongestCommonSubString is free software. You can run/distribute/modify Diff-
#   LongestCommonSubString under the terms of the GNU General Public License 
#   version 3, or any later version, with the extra copyleft provision (covered 
#   by subsection 7b of the GPL v3) that running a modified version or a
#   derivative work also requires you to make the sourcecode of that work 
#   available to everyone that can interact with it, this to ensure that Diff-
#   LongestCommonSubString remains open and libre (doc/LICENSE.txt contains the
#   full text of the legally binding license, including that of the extra 
#   restrictions).
#++#

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib",
    "#{File.dirname(__FILE__)}/../../position_range/lib") if __FILE__ == $0

require 'diff/longest_common_sub_string'
require 'position_range'
require 'test/unit'

class WordSplitArrayTest < Test::Unit::TestCase

  def test_initialize
    assert_equal ['boo',' ','ba',' ','bol'], Diff::LongestCommonSubString::WordSplitArray.new('boo ba bol')
    assert_equal ['boo',' ','ba','   ','bol'], Diff::LongestCommonSubString::WordSplitArray.new('boo ba   bol')
    assert_equal ['boo','. ','ba',' ','bol'], Diff::LongestCommonSubString::WordSplitArray.new('boo. ba bol')
    assert_equal [' ','boo','. ','ba',' ','bol'], Diff::LongestCommonSubString::WordSplitArray.new(' boo. ba bol')
    assert_equal ['boo','. ','ba',' ','bol',' '], Diff::LongestCommonSubString::WordSplitArray.new('boo. ba bol ')
    assert_equal [' ','boo','. ','ba',' ','bol',' '], Diff::LongestCommonSubString::WordSplitArray.new(' boo. ba bol ')
    assert_equal ['boo',' ',Diff::LongestCommonSubString::WordSplitArray::SEPARATOR,' ','ba',' ','bol'], 
        Diff::LongestCommonSubString::WordSplitArray.new('boo ' + Diff::LongestCommonSubString::WordSplitArray::SEPARATOR + ' ba bol')
  end

  def test_translate_to_pos
    # normal
    assert_equal PositionRange::List.from_s('0,2:3,3:4,5:6,8:9,11'), 
        Diff::LongestCommonSubString::WordSplitArray.new('boo ba   bol').translate_to_pos(
            PositionRange::List.from_s('0,0:1,1:2,2:3,3:4,4'))

    # ends with space
    assert_equal PositionRange::List.from_s('0,2:3,3:4,6:7,7'), 
        Diff::LongestCommonSubString::WordSplitArray.new('boo baa ').translate_to_pos(
            PositionRange::List.from_s('0,0:1,1:2,2:3,3'))

    # starts with space
    assert_equal PositionRange::List.from_s('0,0:1,3:4,4:5,7'), 
        Diff::LongestCommonSubString::WordSplitArray.new(' boo baa').translate_to_pos(
            PositionRange::List.from_s('0,0:1,1:2,2:3,3'))
  end
end
