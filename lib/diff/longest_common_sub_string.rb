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

module Diff
  # = Diff::LongestCommonSubString 0.1.0
  # Computes the difference between two strings based on their Longest
  # Common Substrings (not Subsequences).
  #
  module LongestCommonSubString
    VERSION = '0.1.0'
  end
end

require 'diff/longest_common_sub_string/counter'
require 'diff/longest_common_sub_string/word_split_array'

module Diff::LongestCommonSubString
  # Diffs self with other, see Diff::LongestCommonSubString#diff
  #
  def diff(other, options = {})
    Diff::LongestCommonSubString.diff(self.split(''), other.split(''), options)
  end
  
  # Diffs words in self with other, see Diff::LongestCommonSubString#diff
  #
  # Words are non-spaces or groups of spaces delimited by either 
  # spaces or the beginning or the end of the string.
  #
  def word_diff(other, options = {})
    Diff::LongestCommonSubString.word_diff(self, other, options)
  end
end

module Diff::LongestCommonSubString
  class << self
    # Diffs the current logi_version and the logi's body_text with the
    # linkless_textile given and returns a hash containing:
    # 
    # <tt>:matched_old</tt> = the position_ranges in the old text for 
    #     the places where the new matches the old.
    # <tt>:remaining_new</tt> = the position-ranges for the part of 
    #     the new text that remains unmatched in the old
    # 
    # Valid options are:
    # * <tt>:minimum_lcs_size</tt> = the minimum size of LCS-es to allow
    #
    def diff(old_arr, new_arr, options = {})
      minimum_lcs_size = options[:minimum_lcs_size] || 0
      diff_hash = Diff::LongestCommonSubString.longest_common_sub_strings(old_arr, new_arr,
          :minimum_lcs_size => minimum_lcs_size)
      original_matched_old = diff_hash[:matched_old]
      matched_old = PositionRange::List.new
      original_matched_new = diff_hash[:matched_new]
      matched_new = original_matched_new.sort
      i = 0
      while i < original_matched_old.size
        matched_old[matched_new.index(original_matched_new[i])] = 
            original_matched_old[i]
        i += 1
      end

      return {:matched_old => matched_old,
              :matched_new => matched_new}
    end

    # Words are non-spaces or groups of spaces delimited by either 
    # spaces or the beginning or the end of the string.
    #
    def word_diff(old_string, new_string, options = {})
      old_w_s_arr = Diff::LongestCommonSubString::WordSplitArray.new(old_string)
      new_w_s_arr = Diff::LongestCommonSubString::WordSplitArray.new(new_string)
      diff = Diff::LongestCommonSubString.diff(old_w_s_arr, new_w_s_arr, options)
      return {:matched_old => old_w_s_arr.translate_to_pos(diff[:matched_old]),
              :matched_new => new_w_s_arr.translate_to_pos(diff[:matched_new])}
    end

    # Returns a PositionRange::List containing pointers to the Longest 
    # Common Substrings (not Subsequences) of the Arrays or an empty
    # PositionRange::List if none was found.
    # 
    # Valid options are:
    # * <tt>:minimum_lcs_size</tt> = the minimum size of LCS-es to allow
    #
    # The returned List is sorted by LCS-size.
    #
    def longest_common_sub_strings(old_arr, new_arr, options = {})
      minimum_lcs_size = options[:minimum_lcs_size] || 0

      counter_hash = Hash.new
      counter_array = Array.new
      old_arr.each_with_index do |old_el, old_i|
        counter_hash[old_i] = Hash.new
        new_arr.each_with_index do |new_el, new_i|
          if old_el == new_el
            if new_i > 0 and old_i > 0 and counter_hash[old_i - 1][new_i - 1]
              counter_hash[old_i][new_i] = counter_hash[old_i - 1][new_i - 1]
              counter_hash[old_i][new_i].step_up
            else
              counter = Counter.new(old_i, new_i)
              counter_hash[old_i][new_i] = counter
              counter_array.push(counter)
            end
          end
        end
      end

      in_old_p_r_list = PositionRange::List.new
      in_new_p_r_list = PositionRange::List.new

      counter_array = counter_array.select {|co| co.step_size > minimum_lcs_size}

      while counter = counter_array.sort!.pop
        i = 0
        while i < counter_array.size
          if counter_array[i].in_old === counter.in_old
            counter_array[i].in_old = counter_array[i].in_old - counter.in_old
          end
          if counter_array[i].in_new === counter.in_new
            counter_array[i].in_new = counter_array[i].in_new - counter.in_new
          end
          if counter_array[i].size <= minimum_lcs_size
            counter_array.delete_at(i)
          else
            i += 1
          end
        end
        in_old_p_r_list.push(counter.in_old)
        in_new_p_r_list.push(counter.in_new)
      end
      return {:matched_old => in_old_p_r_list,
          :matched_new => in_new_p_r_list}
    end
  end
end
