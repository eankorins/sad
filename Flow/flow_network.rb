class Edge
  attr_accessor :src, :dest, :capacity, :reverse_edge

  def initialize(src, dest, capacity)
  	@src = src 
  	@dest = dest
  	@capacity = capacity
  end

  def to_s
  	"#{@src} -> #{dest}: #{capacity}"
  end
end

class FlowNetwork
  attr_accessor :source, :sink, :adj, :flow
  
  def initialize()
    @adj = {}
    @flow = {}
  end

  def add_vertex(vertex)
  	@adj[vertex] = []
  end

  def get_edges(vertex)
  	return @adj[vertex]
  end
  
  def add_edge(src, dest, c = 0)
  	if src == dest
  		puts "#{src} == #{dest}"
  	else
	  	edge = Edge.new(src, dest, c)
	  	reverse_edge = Edge.new(dest, src, 0)
	  	edge.reverse_edge = reverse_edge
	  	reverse_edge.reverse_edge = edge
	  	@adj[src] << edge
	  	@adj[dest] << reverse_edge
	  	@flow[edge] = 0
	  	@flow[reverse_edge] = 0
  	end
  end

  def find_path(source, sink, path)

		return path if source == sink
  	get_edges(source).each do |edge|
  		residual = edge.capacity - @flow[edge]
	 		if residual > 0 and not path.include?(edge)
  			result = find_path(edge.dest, sink, path + [edge])
  			return result if result != nil
  		end
  	end
  end

  def max_flow(source, sink)
  	path = find_path(source, sink, [])
  	puts "#{path}"
  	while path != nil
  		residuals = path.map { |edge| edge.capacity - @flow[edge] }
  		flow = residuals.min

  		path.each do |edge|
  			@flow[edge] += flow
  			@flow[edge.reverse_edge] -= flow
  		end
  		path = find_path(source, sink, [])

		end
		return get_edges(source).map { |edge| @flow[edge] }.sum
		
  end
end