require 'open-uri'
require_relative 'closest_pairs'

def number
	/[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?/
end

#Runs each file
def run
	file = open('closest-pair.out')
	matcher = /(data\/.*):\s+(#{number})\s(#{number})/
	test_files = file.readlines.select{ |l| l.match(matcher) }.map!{ |l| l.scan(matcher) }.flatten(1)
	
	start = Time.now 

	#Tests if the distance pair count is the same as in the outputfile
	test_files.each do |name, size, distance|
		dist, pair, n = run_file(name)
		if size.to_f == n && distance.to_f.round(12) == dist.round(12)
			puts "#{name} passed with size #{n} and dist #{dist}"
		else
			puts "#{name} failed with size #{n} and dist #{dist}"
		end
	end

	puts "Total time: #{Time.now - start} seconds"
end

#Runs single files
def run_file(file)
	file = open(file)
	lines = file.readlines.map!{|l| l.gsub("\n", '')}
	matcher = /([\d|\w]+)\s+(#{number})\s+(#{number})/
	matches = lines.select{|l| l.match(matcher)}.map!{ |l| l.scan(matcher)}.flatten(1)
	distance, pair, count = ClosestPairs.new(matches).closest
end

start = Time.now
run_file('data/pla85900.tsp')
puts "#{Time.now - start}"