require 'open-uri'
require_relative 'flow_network'


def run_file(file)
	lines = open(file).readlines.map! { |x| x.gsub("\n",'')}
	puts lines
	length = lines.slice!(0).to_i

	nodes = lines.slice!(0, length)
	
	arcLength = lines.slice!(0).to_i

	arcs = lines.slice!(1, arcLength -1).map do |arc|
		a, b, capacity =  arc.split(' ').map!(&:to_i)
		Arc.new(nodes[a],nodes[b],capacity)
	end
	puts "#{arcs}"
	network = FlowNetwork.new(nodes.first, nodes.last, arcs)
	network.ford_fulkerson

	network.report
end
run_file('rail.txt')