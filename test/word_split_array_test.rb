require File.dirname(__FILE__) + '/test_helper.rb'

class WordSplitArrayTest < Test::Unit::TestCase
  ### Initialization

  def test_initialize
    assert_equal ['boo',' ','ba',' ','bol'], DiffLCS::WordSplitArray.new('boo ba bol')
    assert_equal ['boo',' ','ba','   ','bol'], DiffLCS::WordSplitArray.new('boo ba   bol')
    assert_equal ['boo','. ','ba',' ','bol'], DiffLCS::WordSplitArray.new('boo. ba bol')
    assert_equal [' ','boo','. ','ba',' ','bol'], DiffLCS::WordSplitArray.new(' boo. ba bol')
    assert_equal ['boo','. ','ba',' ','bol',' '], DiffLCS::WordSplitArray.new('boo. ba bol ')
    assert_equal [' ','boo','. ','ba',' ','bol',' '], DiffLCS::WordSplitArray.new(' boo. ba bol ')
    assert_equal [' ','boo','. ','<ba>',' ','</bol>',' '], DiffLCS::WordSplitArray.new(' boo. <ba> </bol> ')
    assert_equal [' ','boo','. ','<ba>','moma','</bol>',' '], DiffLCS::WordSplitArray.new(' boo. <ba>moma</bol> ')
    assert_equal ['boo',' ',DiffLCS::WordSplitArray::SEPARATOR,' ','ba',' ','bol'],
        DiffLCS::WordSplitArray.new('boo ' + DiffLCS::WordSplitArray::SEPARATOR + ' ba bol')
  end

  ### Methods

  def test_translate_to_pos
    # normal
    assert_equal PositionRange::List.from_s('0,3:3,4:4,6:6,9:9,12'),
        DiffLCS::WordSplitArray.new('boo ba   bol').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4:4,5'))

    # scrambled
    assert_equal PositionRange::List.from_s('3,4:0,3'),
        DiffLCS::WordSplitArray.new('boo ').translate_to_pos(
            PositionRange::List.from_s('1,2:0,1'))

    # ends with space
    assert_equal PositionRange::List.from_s('0,3:3,4:4,7:7,8'),
        DiffLCS::WordSplitArray.new('boo baa ').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4'))

    # starts with space
    assert_equal PositionRange::List.from_s('0,1:1,4:4,5:5,8'),
        DiffLCS::WordSplitArray.new(' boo baa').translate_to_pos(
            PositionRange::List.from_s('0,1:1,2:2,3:3,4'))
  end
end
