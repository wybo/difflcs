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

require 'position_range'
require 'diff/longest_common_sub_string'
require 'test/unit'

class CounterTest < Test::Unit::TestCase

  def test_stepping
    c = Diff::LongestCommonSubString::Counter.new(5,80)
    assert_equal PositionRange.new(5,5), c.in_old
    assert_equal PositionRange.new(80,80), c.in_new

    c2 = Diff::LongestCommonSubString::Counter.new(5,80)
    c2.step_up
    c2.step_up

    assert_equal PositionRange.new(5,7), c2.in_old
    assert_equal PositionRange.new(80,82), c2.in_new
  end

  def test_assignment
    c = Diff::LongestCommonSubString::Counter.new(5,80)
    5.times do c.step_up end

    assert_equal 6, c.size
    c.in_old = PositionRange.new(5,8)
    assert_equal 4, c.size
    assert_equal PositionRange.new(80,83), c.in_new

    c2 = Diff::LongestCommonSubString::Counter.new(5,80)
    3.times do c2.step_up end

    assert_equal 4, c2.size
    c2.in_new = PositionRange.new(80,81)
    assert_equal 2, c2.size
    assert_equal PositionRange.new(5,6), c2.in_old

    c3 = Diff::LongestCommonSubString::Counter.new(5,80)
    4.times do c3.step_up end

    assert_equal 5, c3.size

    c3.in_new = PositionRange.new(80,82)
    assert_equal 3, c3.size
    assert_equal PositionRange.new(5,7), c3.in_old

    c3.in_old = PositionRange.new(6,7)
    assert_equal 2, c3.size
    assert_equal PositionRange.new(81,82), c3.in_new
  end

  def test_comparison
    c1 = Diff::LongestCommonSubString::Counter.new(5,80)
    c2 = Diff::LongestCommonSubString::Counter.new(15,90)

    c1.step_up

    assert c1 > c2

    # cause of no step_ups after in_old => size => comparing
    c2 = Diff::LongestCommonSubString::Counter.new(15,90) 
    c2.step_up
    c2.step_up

    assert c1 < c2
  end
end
