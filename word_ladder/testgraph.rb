class Edge
  attr_accessor :src, :dst, :length
  
  def initialize(src, dst, length = 1)
    @src = src
    @dst = dst
    @length = length
  end
  def to_s 
  	"#{src} -> #{dst}   #{length}"
  end
end
 
class Graph < Array
  attr_reader :edges
  
  def initialize
    @edges = []
  end
  
  def add_edge(src, dst, length = 1)
    self.push src unless self.include?(src)
    self.push dst unless self.include?(dst)
    @edges.push Edge.new(src, dst, length)
  end
  
  def connect_mutually(vertex1, vertex2, length = 1)
    self.connect vertex1, vertex2, length
    self.connect vertex2, vertex1, length
  end
 
  def neighbors(vertex)
    neighbors = []
    @edges.each do |edge|
      neighbors.push edge.dst if edge.src == vertex
    end
    return neighbors.uniq
  end
 
  def length_between(src, dst)
    @edges.each do |edge|
      return edge.length if edge.src == src and edge.dst == dst
    end
    nil
  end
 
  def dijkstra(src, dst = nil)
    distances = {}
    previouses = {}
    self.each do |vertex|
      distances[vertex] = nil # Infinity
      previouses[vertex] = nil
    end
    #Sets the start node
    distances[src] = 0
    vertices = self.clone
    until vertices.empty?
      nearest_vertex = vertices.inject do |a, b|
        next b unless distances[a]
        next a unless distances[b]
        next a if distances[a] < distances[b]
        b
      end
      break unless distances[nearest_vertex] # Infinity
      if dst and nearest_vertex == dst
        path = get_path(previouses, src, dst)
        return { path: path, distance: distances[dst] }
      end
      puts nearest_vertex
      neighbors = vertices.neighbors(nearest_vertex)
      neighbors.each do |vertex|
        alt = distances[nearest_vertex] + vertices.length_between(nearest_vertex, vertex)
        if distances[vertex].nil? or alt < distances[vertex]
          distances[vertex] = alt
          previouses[vertex] = nearest_vertex
          # decrease-key v in Q # ???
        end
      end
      vertices.delete nearest_vertex
    end
    if dst
      return nil
    else
      paths = {}
      distances.each { |k, v| paths[k] = get_path(previouses, src, k) }
      return { paths: paths, distances: distances }
    end
  end
 
  private
  def get_path(previouses, src, dest)
    path = get_path_recursively(previouses, src, dest)
    path.is_a?(Array) ? path.reverse : path
  end
 
  # Unroll through previouses array until we get to source
  def get_path_recursively(previouses, src, dest)
    return src if src == dest
    raise ArgumentException, "No path from #{src} to #{dest}" if previouses[dest].nil?
    [dest, get_path_recursively(previouses, src, previouses[dest])].flatten
  end
end