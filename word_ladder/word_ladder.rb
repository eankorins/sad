require_relative 'graph'


lines = open('words-250.out').readlines.map { |l| l.split(' ')}
tests = open('words-250-test.in').readlines.map { |l| l.split(' ') }

if __FILE__ == $0
	gr = Graph.new

	lines.each do |a,b|
		gr.add_edge(a,b)
	end
	puts "Ready"

	tests.each do |a,b|
		puts "From #{a} to #{b}\n\n"

		puts gr.bfs(a,b)
	end
end