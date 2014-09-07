require 'open-uri'

def pair?(a,b)
	matchers = a[1..4].split('')
	to_match = b.split('')
	matches = matchers.map { |m| to_match.index(m) }
	if matches.include?(nil)
		false
	else
		matchers.each do |w|
			to_match.slice!(to_match.index(w)) rescue false
		end
		to_match.count == 1
	end
end

lines = open('words-10.dat').readlines.map { |m| m.gsub("\n", '')}

start = Time.now
c = []

for i in 0..lines.count - 1
	for j in 0..lines.count - 1
		c << [lines[i],lines[j]]
	end
end

threads = []
pairs = []
c.each_slice(10000).each do |slice|
	t = Thread.new { 
		s = slice.select {|a,b| a != b && pair?(a,b) }
		pairs << s
	 }
	 threads << t
	 if threads.count == 12
	 	threads.each { |thr| thr.join }
	 	threads = []
	 end
end
threads.each { |thr| thr.join }


pairs = pairs.flatten(1)
#pairs = c.select{ |a,b| pair?(a,b)}
to_write = pairs.map do |a,b |
	"#{a} #{b}"
end

open('words-10.out', 'w') { |f| f << to_write.each { |w| f.puts w} }
