import pandas as pd
import networkx as nx
from pyvis.network import Network

# Example DataFrame
data = {
    'node_1': ['A', 'B', 'C', 'D', 'E'],
    'node_2': ['B', 'C', 'D', 'E', 'A'],
    'edge': [1, 2, 3, 4, 5],
    'cluster number': [1, 2, 1, 2, 1]
}
df = pd.DataFrame(data)

# Create an empty graph
G = nx.Graph()

# Add edges and cluster info
for _, row in df.iterrows():
    G.add_edge(row['node_1'], row['node_2'], weight=row['edge'])
    G.nodes[row['node_1']]['cluster'] = row['cluster number']
    G.nodes[row['node_2']]['cluster'] = row['cluster number']

# Function to get color based on cluster number
def get_cluster_color(cluster_number):
    cluster_colors = {
        1: 'red',
        2: 'green',
        # Add more colors if you have more clusters
    }
    return cluster_colors.get(cluster_number, 'black')  # Default to black if no cluster found

# Create a Pyvis network
net = Network(notebook=True)

# Add nodes and edges from the NetworkX graph to the Pyvis network
for node, data in G.nodes(data=True):
    net.add_node(node, label=node, color=get_cluster_color(data['cluster']))

for source, target, data in G.edges(data=True):
    net.add_edge(source, target, value=data['weight'])

# Generate the HTML file
net.show('clustered_graph.html')
