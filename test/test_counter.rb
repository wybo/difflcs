['rubygems', 'require_relative'].each {|g| require g} if RUBY_VERSION =~ /1\.8/
require_relative 'helper'

class CounterTest < Test::Unit::TestCase

  ### Initialization

  def test_initialize
    c = DiffLCS::Counter.new(1,2)
    assert_equal 1, c.step_size
  end

  ### Methods

  def test_step_up_in_old_and_in_new
    c = DiffLCS::Counter.new(5,80)
    assert_equal PositionRange.new(5,6), c.in_old
    assert_equal PositionRange.new(80,81), c.in_new

    c2 = DiffLCS::Counter.new(5,80)
    c2.step_up
    c2.step_up

    assert_equal PositionRange.new(5,8), c2.in_old
    assert_equal PositionRange.new(80,83), c2.in_new
  end

  def test_size_in_old_and_in_new_assignment
    c = DiffLCS::Counter.new(5,80)
    5.times do c.step_up end

    assert_equal 6, c.size
    c.in_old = PositionRange.new(5,9)
    assert_equal 4, c.size
    assert_equal PositionRange.new(80,84), c.in_new

    c2 = DiffLCS::Counter.new(5,80)
    3.times do c2.step_up end

    assert_equal 4, c2.size
    c2.in_new = PositionRange.new(80,82)
    assert_equal 2, c2.size
    assert_equal PositionRange.new(5,7), c2.in_old

    c3 = DiffLCS::Counter.new(5,80)
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
    c = DiffLCS::Counter.new(1,5)
    assert_equal 1, c.step_size
    c.step_up
    assert_equal 2, c.step_size
  end

  def test_comparison
    c1 = DiffLCS::Counter.new(5,80)
    c2 = DiffLCS::Counter.new(15,90)

    c1.step_up

    assert c1 > c2

    # cause of no step_ups after in_old => size => comparing
    c2 = DiffLCS::Counter.new(15,90)
    c2.step_up
    c2.step_up

    assert c1 < c2
  end
end
