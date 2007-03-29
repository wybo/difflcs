#--#
# Copyright: (c) 2006, 2007 The LogiLogi Foundation <foundation@logilogi.org>
#
# License:
#   This file is part of the Diff-LongestCommonSubString library. Diff-
#   LongestCommonSubString is free software. You can run/distribute/modify 
#   Diff-LongestCommonSubString under the terms of the Affero General Public 
#   License version 1 or any later version. The Affero GPL states that running 
#   a modified version or a derivative work also requires you to make the 
#   sourcecode of that work available to everyone that can interact with it. 
#   We chose the Affero GPL to ensure that Diff-LongestCommonSubString remains 
#   open and libre (doc/LICENSE.txt contains the full text of the legally 
#   binding license).
#++#

class Diff::LongestCommonSubString::WordSplitArray < Array

  ### Constants
  
  # Used as a separator
  SEPARATOR = "\031" # The Unit Separator character

  ### Methods

  # Splits the words, and treats whitespace correctly.
  #
  def initialize(text)
    old_end = 0
    treated = text.scan(/[^\w#{SEPARATOR}]+|#{SEPARATOR}/) do |literal| 
      match = $~
      if match.begin(0) > old_end
        self.push(text[old_end...match.begin(0)])
      end
      self.push(literal)
      old_end = match.end(0)
    end
    if old_end < text.size
      self.push(text[old_end...text.size])
    end
  end

  # Translates word-positions to character-positions.
  #
  def translate_to_pos(positions)
    word_p = 0
    temp_array = Array.new
    i = 0
    while i < self.size
      temp_array.push([word_p])
      word_p += self[i].size - 1
      temp_array.last.push(word_p)
      word_p += 1
      i += 1
    end
    return PositionRange::List.new(
        positions.collect {|position| position.new_dup(
            temp_array[position.begin][0], temp_array[position.end][1])})
  end
end
