import pandas as pd
import networkx as nx
from pyvis.network import Network

# Example DataFrame
data = {
    'node_1': ['A', 'B', 'C', 'D', 'E'],
    'node_2': ['B', 'C', 'D', 'E', 'A'],
    'edge': [1, 2, 3, 4, 5],
    'flag': [1, 0, 1, 0, 0],
    'flag_2': [0, 1, 0, 1, 0]  # Additional flag, not used in this example
}
df = pd.DataFrame(data)

# Create an empty graph
G = nx.Graph()

# Add edges and cluster info from the DataFrame
for _, row in df.iterrows():
    G.add_edge(row['node_1'], row['node_2'], weight=row['edge'], flag=row['flag'])

# Function to get color based on flag value
def get_edge_color(flag):
    return 'red' if flag == 1 else 'grey'

# Create a Pyvis network
net = Network(notebook=True)

# Add nodes and edges from the NetworkX graph to the Pyvis network
for node in G.nodes():
    net.add_node(node, label=node, color='lightblue')

for source, target, data in G.edges(data=True):
    edge_color = get_edge_color(data['flag'])
    net.add_edge(source, target, value=data['weight'], color=edge_color)

# Generate the HTML file
net.show('graph_with_flag.html')
