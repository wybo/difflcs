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
    assert_equal [' ','boo','. ','<ba>',' ','</bol>',' '], Diff::LongestCommonSubString::WordSplitArray.new(' boo. <ba> </bol> ')
    assert_equal [' ','boo','. ','<ba>','moma','</bol>',' '], Diff::LongestCommonSubString::WordSplitArray.new(' boo. <ba>moma</bol> ')
    assert_equal ['boo',' ',Diff::LongestCommonSubString::WordSplitArray::SEPARATOR,' ','ba',' ','bol'], 
        Diff::LongestCommonSubString::WordSplitArray.new('boo ' + Diff::LongestCommonSubString::WordSplitArray::SEPARATOR + ' ba bol')
  end

  def test_translate_to_pos
    # normal
    assert_equal PositionRange::List.from_s('0,3:3,4:4,6:6,9:9,12'), 
        Diff::LongestCommonSubString::WordSplitArray.new('boo ba   bol').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4:4,5'))

    # scrambled
    assert_equal PositionRange::List.from_s('3,4:0,3'), 
        Diff::LongestCommonSubString::WordSplitArray.new('boo ').translate_to_pos(
            PositionRange::List.from_s('1,2:0,1'))

    # ends with space
    assert_equal PositionRange::List.from_s('0,3:3,4:4,7:7,8'), 
        Diff::LongestCommonSubString::WordSplitArray.new('boo baa ').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4'))

    # starts with space
    assert_equal PositionRange::List.from_s('0,1:1,4:4,5:5,8'), 
        Diff::LongestCommonSubString::WordSplitArray.new(' boo baa').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4'))
  end
end
