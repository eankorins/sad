class Edge 
	attr_accessor :source, :target, :length

	def initialize(source, target, length)
		@source = source
		@target = target	
		@length = length
	end

	def to_s
		"#{source} - #{target} (#{length})"
	end
end

class UnionFind
	attr_reader :leaders
	def initialize(nodes)
		@leaders = Hash.new
		nodes.each { |n| @leaders[n] = n}
	end

	def connected?(a,b)
		
		@leaders[a] == @leaders[b]
	end

	def union(source,target)
		a, b = @leaders[source], @leaders[target]
		@leaders.each do |k,v| 
			@leaders[k] = b if @leaders[k] == a  
		end
		
	end
end

class Graph < Array
	attr_reader :edges

	def initialize(nodes = [], edges = [])
		nodes.each { |n| self.push n}
		@edges = edges.sort_by! { |e| e.length }
	end

	def add_connection(source, target, length)
		@edges.push Edge.new(source, target, length)
		self.push source unless self.include?(source)
		self.push target unless self.include?(target)
	end

	def kruskal
		union_find = UnionFind.new self
		mst = []

		puts "MST#{mst}"
		@edges.each do |edge|

			unless union_find.connected?(edge.source, edge.target)
				mst << edge
				union_find.union(edge.source, edge.target)
			end
		end

		cost = mst.inject(0) { |acc, x| acc+x.length }
		{ :mst => mst, :cost => cost }
	end
end