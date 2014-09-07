class Edge
	attr_accessor :source, :target, :weight

	def initialize(source, target, weight = 1)
		@source = source
		@target = target
		@weight = weight
	end

	def to_s
		"#{source} -> #{target} Weight #{weight}"
	end
end

class Graph < Array
	attr_reader :edges

	#Constructor
	def initialize()
		@edges = []
	end

	#Adds every edges as well as the individual unique nodes to the graph's array.
	def add_edge(source, target, weight = 1)
		self.push source unless self.include?(source)
		self.push target unless self.include?(target)
		@edges.push Edge.new(source, target, weight)
	end

	# Finds all neightboring nodes to the passed node, and returns a set of these
	def neighbors(node)
		neighbors = []
		@edges.each do |edge|
			neighbors.push edge.target if edge.source == node
		end
		return neighbors.uniq
	end

	#Retrieves weight of specific edge, if it doesn't exist returns nil
	def edge_weight(source, target)
		@edges.each do |edge|
			return edge.weight if edge.source == source and edge.target == target
		end
		nil
	end

	def bfs(source, target = nil)
		distances = {}
		previous = {}

		#Creates entry in hashes for each node, starting at nil
		self.each do |vertex|
			distances[vertex] = nil
			previous[vertex] = nil
		end
		distances[source] = 0

		#Clones all nodes 
		queue = self.clone

		until queue.empty?
			#Finds the next target node 
			nearest_vertex = queue.inject do |source,target|
				next target unless distances[source]
				next source unless distances[target]
				next source if distances[source] < distances[target]
				target
			end


			break unless distances[nearest_vertex]

			#If a target was passed, and that target is the current nearest vertex
			if target and nearest_vertex == target
				#Build the path
				path = get_path(previous, source, target)
				#And return it as a hash with the distance count
				return {path: path, distances:distances[target] }
			end

			#Gets neighbors to the nearest vertex
			neighbors = queue.neighbors(nearest_vertex)

			#For each neighbor
			neighbors.each do |vertex|
				#It proposes an alternate path
				alt = distances[nearest_vertex] + queue.edge_weight(nearest_vertex, vertex)

				#Choses the heavier path
				if distances[vertex].nil? or alt < distances[vertex]
					distances[vertex] = alt
					previous[vertex] = nearest_vertex
				end
			end

			#Deletes the latest traveresed node from the queue
			queue.delete nearest_vertex
		end

		if target
			#No path was found
			return { distance: -1 }
		else
			# No target was given, and all final paths are returned 
			paths = {}
			distances.each { |k,v| paths[k] = get_path(previous, source, target) }
			return { paths: paths, dsistances: distances}
		end
	end

	private

	def get_path(previous, source, target)
		puts "Previously visited: #{previous.select { |k,v| v != nil }}"
		path = get_path_recursively(previous, source, target)
		path.is_a?(Array) ? path.reverse : path
	end

	def get_path_recursively(previous, source, target)
		return source if source == target
		raise ArgumentException, "No path from #{source} to #{target}" if previous[target].nil?
		[target, get_path_recursively(previous, source, previous[target])].flatten
	end
end