
def read_grammar_defs(filename)
  filename = 'grammars/' + filename unless filename.start_with? 'grammars/'
  filename += '.g' unless filename.end_with? '.g'
  contents = open(filename, 'r') { |f| f.read }
  contents.scan(/{(.+?)}/m).map do |rule_array|
    rule_array[0]
  end
end


def split_definition(raw_def)
  raw_def.scan(/[^\n\t;]+/).collect { |x| x.strip || x }.delete_if(&:empty?)
end


def to_grammar_hash(split_def_array)
  temp_arr = Array.new
  split_def_array.each do |x|
    x.drop(1).each do |y|
      temp_arr.push([x[0], y.split(' ')])
    end
  end
  temp_arr.inject({}) { |c,i| (c[i.first] ||= []) << i.drop(1); c }
end


def is_non_terminal?(s)
  if s[/<(.*?)>/,1].to_s.empty?
    false
  else
    true
  end
end


def expand(grammar, non_term="<start>", sen)
  num1 = Random.rand(grammar[non_term].size)

  if is_non_terminal?(grammar[non_term][0][0][0][0])
    # print grammar[non_term][0][0][0][0]
    sen << grammar[non_term][0][0][0][0]
  else
    grammar[non_term][num1][0].each do |w|
      if is_non_terminal?(w)
        non_term = w
        expand(grammar, non_term, sen)
      else
        # print w + " "
        sen << w + " "
      end
    end
  end
  return sen
end


def rsg(filename)
  splits = read_grammar_defs(filename)
  hash_arr = Array.new
  splits.each do |x|
    hash_arr.push(split_definition(x))
  end
  hashed = to_grammar_hash(hash_arr)
  sen = ""
  return expand(hashed, sen)
end


# if __FILE__ == $0
#   puts "Enter the name of the sentence structure file you'd like to have generated:"
#   file = gets
#   begin
#     rsg(file[0..-2])
#   rescue
#     print "File not found, try again."
#   end
# end