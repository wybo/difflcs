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

class Diff::LongestCommonSubString::Counter
  include Comparable

  # Creates a new counter and sets the initial positions and size
  #
  def initialize(old_i, new_i)
    @in_old_begin = old_i
    @in_new_begin = new_i
    @size = 1
  end

  # Increases the size
  #
  def step_up
    @size += 1
    return self
  end

  # Returns the PositionRange for the range in the old string.
  #
  # NOTE: No step_up's possible anymore after this function has been
  # called.
  #
  def in_old
    if !@in_old
      @in_old = PositionRange.new(@in_old_begin, @in_old_begin + @size)
    end
    return @in_old
  end

  # Returns the PositionRange for the range in the new string
  #
  # NOTE: No step_up's possible anymore after this function has been
  # called.
  #
  def in_new
    if !@in_new
      @in_new = PositionRange.new(@in_new_begin, @in_new_begin + @size)
    end
    return @in_new
  end

  # Sets the in_old PositionRange, and updates the in_new too
  #
  # If new_in_old is nil, the counter is set empty
  # 
  # NOTE: Assumed to be smaller than before, and not moved.
  #
  def in_old=(new_in_old)
    if new_in_old
      @in_new = self.adjust(self.in_new, self.in_old, new_in_old)
      @in_old = new_in_old
    else
      @empty = true
    end
  end

  # Sets the in_new PositionRange, and updates the in_old too
  #
  # If new_in_old is nil, the counter is set empty
  #
  # NOTE: Assumed to be smaller than before, and not moved.
  #
  def in_new=(new_in_new)
    if new_in_new
      @in_old = self.adjust(self.in_old, self.in_new, new_in_new)
      @in_new = new_in_new
    else
      @empty = true
    end
  end

  # Faster than size, but only tells the size to which was 
  # stepped.
  #
  def step_size
    return @size
  end

  # Returns the size of this Counter
  #
  def size
    if @empty
      return 0
    else
      return self.in_old.size
    end
  end

  # Compares it's own size with the size of the other
  #
  def <=> (other)
    return self.size <=> other.size
  end

  protected
  
  # Helper for in_new = and in_old =
  #
  def adjust(to_set, other_old, other_new)
    if other_new.end < other_old.end
      return to_set.new_dup(to_set.begin, to_set.end - (other_old.end - other_new.end))
    else
      return to_set.new_dup(to_set.begin + (other_new.begin - other_old.begin), to_set.end)
    end
  end
end
