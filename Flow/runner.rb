require 'open-uri'
require_relative 'flow_network'


def run_file(file)
	lines = open(file).readlines.map! { |x| x.gsub("\n",'')}
	length = lines.slice!(0).to_i
	nodes = lines.slice!(0, length)

	edgesLength = lines.slice!(0).to_i

	puts "Vertices #{nodes.count} Edges #{edgesLength}"
	edges = lines.slice!(0, edgesLength).map do |edge|
		a, b, capacity =  edge.split(' ').map!(&:to_i)
		capacity = 1000000 if capacity == -1
		[nodes[a], nodes[b], capacity]
	end
	network = FlowNetwork.new
	nodes.each do |v|
		network.add_vertex(v)
	end

	edges.each do |a,b,c|
		network.add_edge(a,b,c)
	end
	puts network.max_flow('ORIGINS', 'DESTINATIONS')
end

g = FlowNetwork.new()
"sopqrt".split('').each do |v|
  g.add_vertex(v)
end
# g.add_edge('s','o',3)
# g.add_edge('s','p',3)
# g.add_edge('o','p',2)
# g.add_edge('o','q',3)
# g.add_edge('p','r',2)
# g.add_edge('r','t',3)
# g.add_edge('q','r',4)
# g.add_edge('q','t',2)
# puts g.max_flow('s','t')


run_file('rail.txt')