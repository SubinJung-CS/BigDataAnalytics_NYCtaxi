# BigDataAnalytics_NYCtaxi
## Neo4j Assignment

Contents:

- [Scenario](#scenario)
- [Task details](#task-details)
- [Connection details](#connection-details)

## Scenario

A taxi company operating in New York City (NYC) is rethinking its fleet allocation strategy. Their
restructuring process is motivated by recent changes in passenger travel patterns (provoked by
Covid) and the arrival of new competitors. To minimise costs, the company wants to station its
fleet in a maximum of 20 city zones, spread across the city. At the same time, the company wants to
maximise trips served and therefore choose zones that have hub-like characteristics, i.e. that are
well-connected and near centres of high user activity. Lastly, the company considers operating
purely outside the Manhattan borough where there is less competition.

<center>
  <img src="images/plot_boroughs.png" alt="NYC Zones and Boroughs" width="600"/>
</center>

To help with this task, the taxi company contracts you to analyse its historical trip records and
recommend a list of city zones where they should station their fleets. To that end, the company
gives you a copy of its Neo4j graph database, available here, containing aggregate statistics of
taxi trips undertaken in 2021. There are two types of nodes: `borough` and `zone`. Two zones are
connected by a relationship of type `:CONNECTS` if a minimum of one trip was recorded between
them. In addition, `:CONNECTS` relationships have property `trips` representing the total number of
trips observed in the year. Lastly, a node is related to a borough via a relationship of type `:IN`. 

<center>
  <img src="images/capture_neo4j.png" alt="Subset of input neo4j graph" width="600"/>
</center>

Based on preliminary exploration of the database and the NYC zones and boroughs map (shown above),
you decide to tackle the challenge by combining two methods of _network analysis_ available in the
[Neo4j Data Science Library](https://neo4j.com/docs/graph-data-science/current/). Your action plan
is divided into three parts:

1. Perform [community
   detection](https://neo4j.com/docs/graph-data-science/current/algorithms/community/) to identify
   clusters of strongly connected zones.
2. Perform [centrality
   analysis](https://neo4j.com/docs/graph-data-science/current/algorithms/centrality/) to measure
   the hub-like features of each zone.
3. Combine the results above by identifying the **top 3 zones** with **highest centrality** score within
   each **community** cluster. This processed is done twice for the entire city:
   1. once including Manhattan, and
   2. once excluding Manhattan.

In addition to your Neo4j analysis, you will use the visualisation app below to help interpret the
results of your network analysis and present them to your client (the taxi company). To use the app,
export your results at the end of each stage to a csv file and load it into the app (more details
given in each task).

- http://csc8101-neo4j-shiny.uksouth.cloudapp.azure.com/

## Task details

There are four tasks:

0. Find isolated nodes
1. Compute the community cluster of each node
2. Compute the centrality score of each node
3. Find the top centrality zones within each community
