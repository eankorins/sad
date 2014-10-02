class Vertex
  attr_accessor :name, :edges, :incoming
  def initialize(name)
    @name = name
    @edges = []
    @incoming = nil
  end

  def to_s
    "#{@name} - Incoming #{@incoming}"
  end
end

class Edge
  attr_accessor :src, :dest, :capacity, :reverse_edge

  def initialize(src, dest, capacity)
  	@src = src 
  	@dest = dest
  	@capacity = capacity
    @incoming = nil
  end

  def to_s
  	"#{@src} -> #{dest}: #{capacity}"
  end
end

class FlowNetwork
  attr_accessor :adj, :flow, :min_cut
  
  def initialize()
    @adj = {}
    @flow = {}
    @min_cut = []
  end

  def add_vertex(vertex)
  	@adj[vertex] = Vertex.new(vertex)
  end

  def get_vertex(vertex)
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
	  	@adj[src].edges << edge
	  	@flow[edge] = 0
	  	@flow[reverse_edge] = 0
  	end
  end

  def bfs(source, sink)

    @adj.each do |key, v|
      @adj[key].incoming = nil
    end
    @min_cut = []

    path = [source]
    currentNode = source
    edges = get_vertex(currentNode).edges
    while currentNode != sink
      edges.each do |edge|
        puts edge
        if @min_cut.include?(edge.dest) || edge.capacity - @flow[edge] == 0
          next
        end
        min_cut << edge.dest
        path << edge
        currentNode = edge.dest
        dest = get_vertex(edge.dest)
        dest.incoming = edge
        edges = dest.edges
      end
    end
    augmentation_path = []
    sleep(2)
    current = sink

    while current != source
      augmentation_path << @adj[current].incoming
      current = @adj[current].incoming.src
    end
    puts augmentation_path.reverse.join(' |> ')
    augmentation_path.reverse
  end

  def max_flow(source, sink)
  	path = bfs(source, sink)
  	while path != nil
  		residuals = path.map { |edge| edge.capacity - @flow[edge] }
    	flow = residuals.min

  		path.each do |edge|
  			@flow[edge] += flow
  			@flow[edge.reverse_edge] -= flow
  		end
  		path = bfs(source, sink)

		end
		return get_vertex(source).map { |edge| @flow[edge] }.sum
		
  end
end