class Vertex 
	attr_accessor :name, :edges, :incoming

	def initialize(name)
		@name = name
		@edges = []
	end

	def to_s
		"#{@name}"
	end
end

class Edge
	attr_accessor :src, :dest, :capacity, :flow, :reverse_edge

	def initialize(src, dest, capacity)
		@src = src
		@dest = dest
		@capacity = capacity
		@flow = 0
	end

	def residual_flow
		capacity - flow
	end

	def to_s
		"#{src.name} -> #{dest.name} (#{flow}/#{capacity})"
	end
end

class FlowNetwork
	attr_accessor :vertices, :edges, :min_cut

	def initialize
		@vertices = []
		@edges = []
		@min_cut = []
	end


	def find_path(source, sink)
		@min_cut = []
		@min_cut << source
		path = []
		path << source
		vertices.each { |v| v.incoming = nil }
		is_path = false
		queue = Array.new
		queue << source
		while (current = queue.shift) != nil
			current.edges.each do |edge|
				dest = edge.dest

				if edge.residual_flow > 0 and not path.include?(dest)
					dest.incoming = edge
					min_cut << dest
					path << dest
					if dest == sink
						is_path = true
						break
					end
					queue << dest
				end
			end
		end

		augmentation_path = []
		
		if is_path
			current = sink
			while current != source
				augmentation_path << current.incoming
				current = current.incoming.src
			end
			augmentation_path.reverse!
			
		end
		if augmentation_path.length > 0
			return augmentation_path
		else 
			return nil
		end
	end

	def max_flow(source, sink)
		source_vertex = @vertices[source]
		sink_vertex = @vertices[sink]
		max_flow = 0
		augmentation_path = []

		while (augmentation_path = find_path(source_vertex, sink_vertex)) != nil
			
			bottleneck = 10000000
			augmentation_path.each do |edge|
				bottleneck = [edge.residual_flow, bottleneck].min
			end
			augmentation_path.each do |edge|
				edge.flow += bottleneck
				edge.reverse_edge.flow -= bottleneck
			end
			max_flow += bottleneck
		end
        edges.each do |e|
            if (min_cut.include?(e.src) and not  min_cut.include?(e.dest))
                puts "#{e.src} -> #{e.dest} Capacity #{e.capacity}"
            end
        end
		max_flow
	end

	def add_vertex(vertex)
		vertices << Vertex.new(vertex)
	end

	def add_edge(src, dest, capacity)
		edge = Edge.new(@vertices[src], @vertices[dest], capacity)
		reverse_edge = Edge.new(@vertices[dest], @vertices[src], capacity)
		edge.reverse_edge = reverse_edge
		reverse_edge.reverse_edge = edge
		@vertices[src].edges << edge
		@vertices[src].edges << reverse_edge
		@vertices[dest].edges << edge
		@vertices[dest].edges << reverse_edge

		@edges << edge
		@edges << reverse_edge
	end


end