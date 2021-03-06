require 'pry'
NOUNS = ["abcd", "c", "def", "h", "ij", "cde"]
VERBS = ["bc", "fg", "g", "hij", "bcd"]
ARTICLES = ["a", "ac", "e"]
DICTIONARY = NOUNS + VERBS + ARTICLES
NOT_VERBS = NOUNS + ARTICLES
def sentence_maker(input)
  sentences = []
  potential_sentences = []
  partials = []
  front_partials = []
  back_partials = []
  VERBS.each do |v|
    if input.include?(v)
      sentence = input.partition(v)
      if DICTIONARY.include?(sentence.first) && DICTIONARY.include?(sentence.last)
        if ARTICLES.include?(sentence.first) && ARTICLES.include?(sentence.last)
          potential_sentences << sentence
        elsif NOUNS.include?(sentence.first) || NOUNS.include?(sentence.last)
          potential_sentences << sentence
        end
      elsif DICTIONARY.include?(sentence.first)
        DICTIONARY.each do |word|
          last_word = sentence.last
          if last_word.include?(word)
            back = last_word.partition(word)
            sentence.pop
            sentence.push(back)
            potential_sentences << sentence.flatten
            break
          end
        end
      elsif DICTIONARY.include?(sentence.last)
        DICTIONARY.each do |word|
          first_word = sentence.first
          if first_word.include?(word)
            front = first_word.partition(word)
            sentence.shift
            sentence.unshift(front)
            potential_sentences << sentence.flatten
            break
          end
        end
      else
        NOT_VERBS.each do |word|
          first_word = sentence.first
          last_word = sentence.last
          if first_word.include?(word)
            front = first_word.partition(word)
            sentence.shift
            sentence.unshift(front)
            potential_sentences << sentence.flatten
            break
          elsif last_word.include?(word)
            back = last_word.partition(word)
            sentence.pop
            sentence.push(back)
            potential_sentences << sentence.flatten
            break
          end
        end
      end
    end
  end
  potential_sentences.each do |sentence|
    sentence.delete_if { |word| word == "" }
    if sentence.all? { |word| DICTIONARY.include?(word) }
      s_verbs = VERBS.select { |verb| sentence.include?(verb) }
      s_nouns = NOUNS.select { |noun| sentence.include?(noun) }
      s_articles = ARTICLES.select { |article| sentence.include?(article) }
      verb_count = s_verbs.length
      noun_count = s_nouns.length
      article_count = s_articles.length
      if verb_count > 0 && (noun_count > 0 || article_count > 1)
        sentences << sentence.join(" ")
      end
    end
  end
  puts "done: #{sentences.inspect}"
end

puts '---------------------------------------'
puts "Welcome to Nick's Sentence Maker (NSM)."
puts '---------------------------------------'
puts "\nNSM checks your input against the Annkissam Dictionary,
and returns all possible sentences contained within your input.
All inputs need to only contain letters from 'a' to 'j'."
puts "\nWhat string of letters would you like to the check for possible sentences?"
print "Please enter your input: "
input = gets.chomp.downcase.to_s
while input.count("k-z0-9") > 0
  print "I said, 'All inputs need to only contain letters from 'a' to 'j'', PLEASE try again: "
  input = gets.chomp.downcase.to_s
end

sentence_maker(input)
