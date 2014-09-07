require 'open-uri'
require_relative 'graph'

def parse_connection(line)
	line = line
	source, target = line.split('--')
	length = target.match(/\[(\d)*\]/)[0].gsub(/\[|\]/, '').to_i
	target = target.gsub(/ \[(\d)*\]/, '')
	Edge.new(source, target, length)
end

lines = open('USA-highway-miles.in').readlines.map{ |l| l.gsub(/\"|\n|/, '') }

cities = lines.select { |l| not l.include?('--') }.map{|c| c.strip}

connections = lines.select { |l| l.include?('--') }.map{ |c| parse_connection(c) }

sum = connections.inject(0) { |acc,x| acc + x.length }
puts sum
graph = Graph.new(cities, connections)

puts graph.kruskal