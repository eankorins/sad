/**
 * Created by Mind on 10/1/2014.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.Queue;

public class FlowBehindEnemyLines {
    //will contain the nodes (55) from the rail.txt file
    private ArrayList<Node> nodes = new ArrayList<Node>();
    //will contain the edges (238) in both directions from source to destination
    private ArrayList<Edge> edges = new ArrayList<Edge>();
    //contain min cut nodes
    private ArrayList<Node> minCutNodes = new ArrayList<Node>();

    public static void main(String[] args) throws IOException {
        //pass a buffered reader to the FlowBehindEnemyLines constructor
        String filePath = args[0];
//        String filePath = "F:\\Workspaces\\IntelliJWorkspace\\Algo1\\FlowBehindEnemyLines\\rail.txt";
        BufferedReader br = new BufferedReader(new FileReader(filePath));
        new FlowBehindEnemyLines(br);
        //close buffered reader
        br.close();
    }

    /*will represent a single node in the graph*/
    private class Node {
        public String name;
        public ArrayList<Edge> edges = new ArrayList<Edge>();
        // temporary for holding data, overwritten in each bfs call
        public Edge incoming_path;
        public Node(String name) {
            this.name = name;
        }

    }

    /*will represent an edge in the graph*/
    private class Edge {
        public Integer capacity = 0;
        public Integer flow = 0;
        public Node sourceNode;
        public Node destinationNode;
        //will represent the opposite edge/residual ?!?!?!?!?
        public Edge oppositeEdge;

        public Edge(Node origin, Node destination, Integer capacity, Edge originalEdge) {
            this.destinationNode = destination;
            this.sourceNode = origin;
            this.capacity = capacity;
            //will create an opposite edge if it is null
            if (originalEdge == null)
                this.oppositeEdge = new Edge(destination, origin, capacity, this);
            else
                this.oppositeEdge = originalEdge;
        }

        /*increase the flow of an edge*/
        public void increaseFlow(int flow) {
            this.flow += flow;
            //each time we push flow through an edge we will have to increase the capacity of the reverse edge!!!!!
            this.oppositeEdge.flow -= flow;
        }

        /*will return the remaining capacity of the edge*/
        public int remainingCapacity() {
            return capacity - flow;
        }

    }

    public FlowBehindEnemyLines(BufferedReader br) throws IOException {
        //parse the data
        parseData(br);
        //run FordFulkerson max flow algo
        FordFulkerson();

    }

    /*BFS implementation to find an augmentation path*/
    private ArrayList<Edge> bfs(Node sourceNode, Node sinkNode) {

        Queue<Node> queue = new LinkedList<Node>();
        queue.add(sourceNode);

        minCutNodes.clear();
        minCutNodes.add(sourceNode);
        boolean isPath = false;

        // for debugging, clear the path_in
        for (Node n : nodes)
            n.incoming_path = null;

        while (!queue.isEmpty()) {
            //get an item from the queue
            Node currentNode = queue.poll();
            //for each edge in the current node
            for (Edge edge : currentNode.edges) {
                //get the destination node of each edge
                Node destinationNode = edge.destinationNode;
                //if there is no remaining capacity
                if (minCutNodes.contains(destinationNode) || edge.remainingCapacity() == 0)
                    continue;
                // store the incoming path in order to traverse backwards
                destinationNode.incoming_path = edge;
                minCutNodes.add(destinationNode);
                // path found
                if (destinationNode.equals(sinkNode)) {
                    isPath = true;
                    break;
                }
                queue.add(destinationNode);
            }

        }

        ArrayList<Edge> path_edges = new ArrayList<Edge>();
        // only a path in finish was included in the processed nodes
        if (isPath) {

            Node v = sinkNode;
            while (!v.equals(sourceNode)) {

                path_edges.add(v.incoming_path);
                v = v.incoming_path.sourceNode;
            }
            // go from start to end
            Collections.reverse(path_edges);
        }
        //return the edges  in the path
        return path_edges.size() > 0 ? path_edges : null;
    }

    private void FordFulkerson() {
        //initialize flow to 0
        int maxFlow = 0;
        //specify source and sink
        Node sourceNode = nodes.get(0);
        Node sinkNode = nodes.get(54);

        ArrayList<Edge> augmentationPath;
        //while there is a path from source to sink, get the edges in this path
        while ((augmentationPath = bfs(sourceNode, sinkNode)) != null) {

            int bottleneck = Integer.MAX_VALUE;
            //for each edge in the path we found via bfs
            for (Edge e : augmentationPath)
                //calculate the bottleneck
                bottleneck = Math.min(e.remainingCapacity(), bottleneck);
            //increase the flow of each edge by the bottleneck
            for (Edge e : augmentationPath)
                e.increaseFlow(bottleneck);
            //increase the max flow by the current added flow
            maxFlow += bottleneck;
        }
        //output the max flow
        System.out.println("Maximum Flow: " + maxFlow);

        System.out.println("Minimal cut: ");
        for (Edge e : edges) {

            // min cut = origin is in last bfs but destination is not
            if (minCutNodes.contains(e.sourceNode) == true && minCutNodes.contains(e.destinationNode) == false)
                System.out.println(nodes.indexOf(e.sourceNode) + " " + nodes.indexOf(e.destinationNode) + " " + e.capacity);
        }

    }

    /*   will parse the rail.txt file and extract the nodes, edges and their capacities*/
    private void parseData(BufferedReader reader) throws IOException {
        int lineNumber = 0;
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            lineNumber++;
            //if line number is 1 or 57 (which indicate nodes and edges count) continue
            if (line.length() == 0 || lineNumber == 1 || lineNumber == 57)
                continue;
            //if the lines are below 56, extract the names and make a node for each and add it to the nodes arraylist
            if (lineNumber <= 56)
                nodes.add(new Node(line.trim()));
                //if line number is above 57
            else {
                //split the line on a whitespace
                String[] split = line.split(" ");
                //get the source node
                Node sourceNode = nodes.get(Integer.parseInt(split[0]));
                //get the destination node
                Node destinationNode = nodes.get(Integer.parseInt(split[1]));
                //get the capacity
                int capacity = Integer.parseInt(split[2]);
                //if the capacity is -1 then use Integer.MAX_VALUE to represent infinity/very large value
                if (capacity == -1)
                    capacity = Integer.MAX_VALUE;
                //make an edge based on source, destination and capacity
                Edge edge = new Edge(sourceNode, destinationNode, capacity, null);
                //add edge in one direction
                sourceNode.edges.add(edge);
                destinationNode.edges.add(edge);
                //add the edge in the opposite direction
                sourceNode.edges.add(edge.oppositeEdge);
                destinationNode.edges.add(edge.oppositeEdge);
                //add the edges to the edge array list
                edges.add(edge);
                edges.add(edge.oppositeEdge);
            }

        }

    }
}