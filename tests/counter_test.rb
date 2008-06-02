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
require 'test/unit'

class CounterTest < Test::Unit::TestCase

  ### Initialization

  def test_initialize
    c = Diff::LongestCommonSubString::Counter.new(1,2)
    assert_equal 1, c.step_size
  end

  ### Methods

  def test_step_up_in_old_and_in_new
    c = Diff::LongestCommonSubString::Counter.new(5,80)
    assert_equal PositionRange.new(5,6), c.in_old
    assert_equal PositionRange.new(80,81), c.in_new

    c2 = Diff::LongestCommonSubString::Counter.new(5,80)
    c2.step_up
    c2.step_up

    assert_equal PositionRange.new(5,8), c2.in_old
    assert_equal PositionRange.new(80,83), c2.in_new
  end

  def test_size_in_old_and_in_new_assignment
    c = Diff::LongestCommonSubString::Counter.new(5,80)
    5.times do c.step_up end

    assert_equal 6, c.size
    c.in_old = PositionRange.new(5,9)
    assert_equal 4, c.size
    assert_equal PositionRange.new(80,84), c.in_new

    c2 = Diff::LongestCommonSubString::Counter.new(5,80)
    3.times do c2.step_up end

    assert_equal 4, c2.size
    c2.in_new = PositionRange.new(80,82)
    assert_equal 2, c2.size
    assert_equal PositionRange.new(5,7), c2.in_old

    c3 = Diff::LongestCommonSubString::Counter.new(5,80)
    4.times do c3.step_up end

    assert_equal 5, c3.size

    c3.in_new = PositionRange.new(80,82)
    assert_equal 2, c3.size
    assert_equal PositionRange.new(5,7), c3.in_old

    c3.in_old = PositionRange.new(6,7)
    assert_equal 1, c3.size
    assert_equal PositionRange.new(81,82), c3.in_new
  end

  def test_step_size
    c = Diff::LongestCommonSubString::Counter.new(1,5)
    assert_equal 1, c.step_size
    c.step_up
    assert_equal 2, c.step_size
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
