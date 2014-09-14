import java.util.HashMap;

public class SpanningUSA {
	// will represent the
	private HashMap<String, Integer> usaCities = new HashMap<String, Integer>();
	// will represent a weighted undirected graph
	private EdgeWeightedGraph weightedGraph;
	// prim algo for calculating min spanning tree
	private Prim primMinSpanTree;

	public SpanningUSA(String fileName) {
		In reader = new In(fileName);
		String line;
		int cityCounter = 0;
		int edgeWeight;
		// will represent the source node
		String sourceNodde;
		// will represent the destination node
		String destinationNode;
		// used to split the lines properly
		String lineSplitArray[];
		// measure time execution
		Stopwatch stopwatch = new Stopwatch();
		// read a line
		while (reader.hasNextLine()) {
			line = reader.readLine();
			// match regular expression for the connection and weights --> any
			// char except a line break 0 or more times, followed by a number,
			// followed by any char except a line break 0 or more times
			if (!line.matches(".*\\d.*")) {
				// add an entry to the usaCities HashMap, representing keys as
				// cities and values as integers from the cityCounter
				usaCities.put(line.trim(), cityCounter++);
			} else {
				// all of the cities are in the usaCities Hashmap and we can now
				// build a graph and add the edges and their weights based on
				// the second part of the input file
				if (weightedGraph == null)
					// use the cityCounter to represents the number of vertices
					// in the graph
					weightedGraph = new EdgeWeightedGraph(cityCounter);
				// split the line --
				lineSplitArray = line.split("\\--");
				// get the first node
				sourceNodde = lineSplitArray[0].trim();
				// split the second part of the line to extract the destination
				// node
				lineSplitArray = lineSplitArray[1].split("\\[");
				// destination node
				destinationNode = lineSplitArray[0].trim();
				// get the value/cost of the edge between the nodes
				edgeWeight = Integer.parseInt(lineSplitArray[1].substring(0,
						lineSplitArray[1].length() - 1));
				// get the source node, get the destination node, get the cost
				// of the edge and make a new edge in the graph
				weightedGraph.addEdge(new Edge(usaCities.get(sourceNodde),
						usaCities.get(destinationNode), edgeWeight));
			}
		}
		// run prim on the already created graph
		primMinSpanTree = new Prim(weightedGraph);
		System.out.println(stopwatch.elapsedTime());
		System.out.println(primMinSpanTree.getTotalWeight());
	}

	public static void main(String[] args) {
		// hardcode the file
		new SpanningUSA(
				"F:\\Workspaces\\workspaceITU\\Algorithms_DataStructures\\src\\USA-highway-miles.in");
		// taking the file as an argument from the comand line
		new SpanningUSA(args[0]);
	}

	// Sedgewick implementation from algs4. Implementation -->
	// http://algs4.cs.princeton.edu/43mst/EdgeWeightedGraph.java.html
	public class EdgeWeightedGraph {
		// number of vertices
		private final int V;
		// number of edges
		private int E;
		// adjacency lists
		private Bag<Edge>[] adj;

		@SuppressWarnings("unchecked")
		public EdgeWeightedGraph(int V) {
			this.V = V;
			this.E = 0;
			adj = (Bag<Edge>[]) new Bag[V];
			for (int v = 0; v < V; v++)
				adj[v] = new Bag<Edge>();
		}

		public int V() {
			return V;
		}

		public int E() {
			return E;
		}

		// add an edge
		public void addEdge(Edge e) {
			int v = e.either(), w = e.other(v);
			adj[v].add(e);
			adj[w].add(e);
			E++;
		}

		public Iterable<Edge> adj(int v) {
			return adj[v];
		}

	}

	// Sedgewick implementation from algs4. Implementation -->
	// http://algs4.cs.princeton.edu/43mst/Edge.java.html
	public class Edge implements Comparable<Edge> {
		// one vertex
		private final int v;
		// the other vertex
		private final int w;
		// edge weight
		private final double weight;

		// edge constructor
		public Edge(int v, int w, double weight) {
			this.v = v;
			this.w = w;
			this.weight = weight;
		}

		// return the weight of the edge
		public double weight() {
			return weight;
		}

		public int either() {
			return v;
		}

		// Returns the endpoint of the edge that is different from the given
		// vertex
		public int other(int vertex) {
			if (vertex == v)
				return w;
			else if (vertex == w)
				return v;
			else
				throw new RuntimeException("Inconsistent edge");
		}

		public int compareTo(Edge that) {
			if (this.weight() < that.weight())
				return -1;
			else if (this.weight() > that.weight())
				return +1;
			else
				return 0;
		}

		public String toString() {
			return String.format("%d-%d %.2f", v, w, weight);
		}
	}

	// Sedgewick implementation from algs4. Implementation -->
	// http://algs4.cs.princeton.edu/43mst/PrimMST.java.html
	public class Prim {
		// shortest edge from tree vertex to non-tree vertex
		private Edge[] edgeTo;
		// weight of shortest such edge
		private double[] distTo;
		// true if v on tree
		private boolean[] marked;
		// eligible crossing edges
		private IndexMinPQ<Double> pq;
		private double totalWeight = 0;

		// compute a minimum spanning tree (or forest) of an edge-weighted
		// graph.
		public Prim(EdgeWeightedGraph G) {
			edgeTo = new Edge[G.V()];
			distTo = new double[G.V()];
			marked = new boolean[G.V()];
			// set the current distance to infinity to all nodes
			for (int v = 0; v < G.V(); v++)
				distTo[v] = Double.POSITIVE_INFINITY;
			pq = new IndexMinPQ<Double>(G.V());
			distTo[0] = 0.0;
			// Initialize pq with 0 which is our source node ;), weight 0.
			pq.insert(0, 0.0);
			while (!pq.isEmpty())
				// Add closest vertex to tree.
				visit(G, pq.delMin());
			for (int i = 1; i < edgeTo.length; i++)
				// calculate the total weight of all edges
				totalWeight += edgeTo[i].weight();
		}

		// Add v to tree; update data structures.
		private void visit(EdgeWeightedGraph G, int v) {
			marked[v] = true;
			// for every edge adjacent to v we pick the smallest weight
			// otherwise this edge is ineligible
			for (Edge e : G.adj(v)) {
				int w = e.other(v);
				if (marked[w])
					continue;
				// v-w is ineligible.
				if (e.weight() < distTo[w]) {
					// Edge e is new best connection from tree to w.
					edgeTo[w] = e;
					distTo[w] = e.weight();
					if (pq.contains(w))
						pq.changeKey(w, distTo[w]);
					else
						pq.insert(w, distTo[w]);
				}
			}
		}

		// return the total weight of the MST
		public double getTotalWeight() {
			return totalWeight;
		}
	}
}