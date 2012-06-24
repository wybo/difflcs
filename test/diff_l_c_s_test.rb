require File.dirname(__FILE__) + '/test_helper.rb'

require 'diff_l_c_s/string'

class DiffLCSTest < Test::Unit::TestCase
  ### Class methods

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

  def test_longest_common_sub_strings
    old_arr = 'abcde'.split('')
    new_arr = 'acdbe'.split('')

    diff_hash = DiffLCS.longest_common_sub_strings(old_arr,new_arr)

    assert_equal PositionRange.new(2,4),
        diff_hash[:matched_old].first
    assert_equal PositionRange.new(1,3),
        diff_hash[:matched_new].first

    old_arr = 'aaaaablabbbbbbccccc'.split('')
    new_arr = 'aaaaakbbbbbbk'.split('')

    assert_equal({:matched_old => PositionRange::List.from_s('8,14:0,5'),
            :matched_new => PositionRange::List.from_s('6,12:0,5')},
        DiffLCS.longest_common_sub_strings(old_arr,new_arr))
  end

  def test_string
    assert_equal({:matched_old => PositionRange::List.from_s('0,2:5,9:2,4'),
            :matched_new => PositionRange::List.from_s('0,2:3,7:7,9')},
        '123456789'.diff('120678934'))
  end

  ### Test helpers

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
        DiffLCS.diff(old_arr, new_arr, :minimum_lcs_size => 15))
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
        DiffLCS.word_diff(old, new, :minimum_lcs_size => 3))
  end

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
