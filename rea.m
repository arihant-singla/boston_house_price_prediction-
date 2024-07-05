import pandas as pd
import networkx as nx
from pyvis.network import Network

# Original DataFrame
data = {
    'node_1': ['A', 'B', 'C', 'D', 'E'],
    'node_2': ['B', 'C', 'D', 'E', 'A'],
    'edge': [1, 2, 3, 4, 5],
    'cluster number': [1, 2, 1, 2, 1]
}
df = pd.DataFrame(data)

# New DataFrame with additional triplets
new_data = {
    'node_1': ['A', 'F', 'G', 'D', 'H'],
    'node_2': ['F', 'G', 'H', 'E', 'A'],
    'edge': [1, 2, 3, 4, 5],
    'cluster number': [1, 1, 2, 2, 1]  # assuming new clusters or original clusters
}
new_df = pd.DataFrame(new_data)

# Create an empty graph
G = nx.Graph()

# Add edges and cluster info from the original DataFrame
for _, row in df.iterrows():
    G.add_edge(row['node_1'], row['node_2'], weight=row['edge'])
    G.nodes[row['node_1']]['cluster'] = row['cluster number']
    G.nodes[row['node_2']]['cluster'] = row['cluster number']

# Create a Pyvis network
net = Network(notebook=True)

# Add nodes and edges from the NetworkX graph to the Pyvis network
for node, data in G.nodes(data=True):
    net.add_node(node, label=node, color='grey')

for source, target, data in G.edges(data=True):
    net.add_edge(source, target, value=data['weight'], color='grey')

# Add new nodes and edges from the new DataFrame
for _, row in new_df.iterrows():
    G.add_edge(row['node_1'], row['node_2'], weight=row['edge'])
    G.nodes[row['node_1']]['color'] = 'red'
    G.nodes[row['node_2']]['color'] = 'red'

# Update the Pyvis network with the new nodes and edges
for node, data in G.nodes(data=True):
    color = data.get('color', 'grey')
    net.add_node(node, label=node, color=color)

for source, target, data in G.edges(data=True):
    if (source, target) in [(row['node_1'], row['node_2']) for _, row in new_df.iterrows()] or \
       (target, source) in [(row['node_1'], row['node_2']) for _, row in new_df.iterrows()]:
        net.add_edge(source, target, value=data['weight'], color='red')
    else:
        net.add_edge(source, target, value=data['weight'], color='grey')

# Generate the updated HTML file
net.show('updated_clustered_graph_with_red_and_grey.html')
