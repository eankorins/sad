class Arc
	attr_accessor :src, :dest, :capacity

	def initialize(src, dest, capacity)
		@src = src
		@dest = dest
		@capacity = capacity
	end
end

class FlowNetwork
	attr_accessor :source, :sink, :network


	def initialize(source, sink, arcs)
		@source = source
		@sink = sink
		@network = {}
		arcs.each do |arc|
			@network[arc] = 0
		end
	end

	def ford_fulkerson
		path = augmenting_path

		while path 
			flow_augmentation(path)
			path = augmenting_path
		end
	end

	def augmenting_path
		labeled = { @source => nil }
		scanned = {}

		now_scanning = @source

		while not labeled.empty?
			if labeled.include?(@sink)
				backtrace = [@sink]
				parent = labeled[@sink]
				while parent != nil
					backtrace.push(parent)
					parent = scanned[parent]
				end
				return backtrace.reverse!
			end

			arcs = @network.select do |k,v|
				k.dest == now_scanning or k.src = now_scanning
			end

			arcs.each do |k,v|

				if k.dest == now_scanning
					if @network[k] < k.capacity
						labeled[k.src] = now_scanning
					end if not labeled.merge(scanned).include?(k.src)
				elsif k.src == now_scanning
					if @network[k] > 0 
						labeled[e.dest] = now_scanning
					end if not labeled.merge(scanned).include?(k.dest)
				end
			end
			scanned[now_scanning] = labeled[now_scanning]
			labeled.delete(now_scanning)
			now_scanning = labeled.keys[0]
		end	
		return nil
	end

	def query_arc(src, dest)
		@network.select do |k,v|
			k.src == src and k.dest == dest
		end
	end

	def flow_augmentation(path)
		flow = +1.0/0 #Infinity and BEYOND

		arcs = []

		

		path[0..path.length - 2].each_index do |i|
			forward = query_edge(path[i], path[i+1])
			backward = query_edge(path[i+1], path[i])

			if backward.empty?
				edge_flow = forward
				edge.push(edge_flow.keys[0])
				available = edge_flow.keys[0].capacity - edge_flow.values[0]
				if flow > available
					flow = available
				end
			elsif foward.empty?
				edge_flow = backward
				edge.push(edge_flow.keys[0])
				available = edge_flow.values[0]
				if flow > available
					flow = available
				end
			end
		end
		arcs.each do |arc|
			network[arc] += flow
		end
	end

	def report
    	print "Source: ", @source, "\n"
    	print "Sink: ", @sink, "\n"
    	@network.each_pair do |e, v|
    	  print e.dest, ' -> ', e.src, '; capacity: ', e.capacity, ', flow: ', v, "\n"
    end
    puts
  end

end