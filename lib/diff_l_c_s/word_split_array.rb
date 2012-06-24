class DiffLCS::WordSplitArray < Array
  ### Constants

  # Used as a separator
  SEPARATOR = "\031" # The Unit Separator character

  ### Constructors

  # Splits the words, and treats whitespace correctly.
  #
  def initialize(text)
    old_end = 0
    # splits for html-tags, for any non-word-characters & for SEPARATORs
    treated = text.scan(/<\/?\w+>|[^\w<\/>#{SEPARATOR}]+|#{SEPARATOR}/) do |literal|
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

  ### Methods

  # Translates word-positions to character-positions.
  #
  def translate_to_pos(positions)
    word_p = 0
    temp_array = [0]
    i = 0
    while i < self.size
      word_p += self[i].size
      temp_array.push(word_p)
      i += 1
    end
    return PositionRange::List.new(
        positions.collect {|position| position.new_dup(
            temp_array[position.begin], temp_array[position.end])})
  end
end
