require 'open-uri'

def isPair?(a,b)
	matchers = count_by a[1..4].split('')
	to_match = count_by b.split('')

	matchers.all? do | key, value |
		to_match[key] == value
	end
end

def count_by(arr)
	arr.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
end

file = open('words-5757.dat')
matched_words = {}
current_words = []

file.each_line do |line|
	current_words << line
	matched_words = matched_words.merge({ line => [] })
	(current_words - [line]).each do |w|
		matched_words[line] << w if isPair?(line, w)

		reverse_match = matched_words[w]
		unless reverse_match.nil? || reverse_match.include?(line)
			matched_words[w] << line if isPair?(line, w)
		end
	end
end

matched_words.each { |a,b| puts "#{a} #{b}" }