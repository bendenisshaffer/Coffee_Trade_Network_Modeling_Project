import igraph

def to_igraph(G):
        g = igraph.Graph(directed = True)
        g.add_vertices(G.nodes())
        g.add_edges(G.edges())
        
        return(g)

all_graphs = [gasG05,gasG10,gasG15,coffeeG05,coffeeG10,coffeeG15,sugarG05,sugarG10,sugarG15]
igraphs = [to_igraph(gg) for gg in all_graphs]

igraphs[0].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/gasG05.gml")
igraphs[1].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/gasG10.gml")
igraphs[2].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/gasG15.gml")
igraphs[3].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/coffeeG05.gml")
igraphs[4].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/coffeeG10.gml")
igraphs[5].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/coffeeG15.gml")
igraphs[6].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/sugarG05.gml")
igraphs[7].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/sugarG10.gml")
igraphs[8].write_gml("/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/CoffeeTradeNetworkProject/Data/iGraphs/sugarG15.gml")
