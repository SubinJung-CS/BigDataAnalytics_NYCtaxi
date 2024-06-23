// [NYC PROJECT]

// ------
// Task 0 - Find Isolated Nodes
// ------

// 1. Self-pointing relationships
MATCH (z1:zone)-[r:CONNECTS]->(z2:zone) WHERE z1.id=z2.id RETURN z1.id,count(r),z2.id

// 2. Isolated nodes
MATCH (z:zone) WHERE NOT (z)-[: CONNECTS]-(:zone) RETURN z, z.id


// ------
// Task 1 - Community Detection using Louvain algorithm
// ------

// 1. Graph Projection of type UNDIRECTED
CALL gds.graph.create(
    'b9039814-communities',
    'zone',
    {
        CONNECTS: {
            orientation: 'UNDIRECTED'
        }
    },
    {
        relationshipProperties: 'trips'
    }
)

// 2. Report the number of communities (stats mode)
CALL gds.louvain.stats('b9039814-communities', {relationshipWeightProperty: 'trips'})
YIELD communityCount

// 3. Return the Id and Community properties of each zone (stream mode)
CALL gds.louvain.stream('b9039814-communities', {relationshipWeightProperty: 'trips'})
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).id AS zone, communityId as community
ORDER BY zone ASC


// ------
// Task 2 - Centrality Analysis using Page Rank algorithm
// ------

// 1. Graph Projection of type DIRECTED
CALL gds.graph.create(
    'b9039814-centrality',
    'zone',
    {
        CONNECTS: {
            orientation: 'NATURAL'
        }
    },
    {
        relationshipProperties: 'trips'
    }
)

// 2. Report the Maximum and Minimum centrality score (stats mode)
CALL gds.pageRank.stats('b9039814-centrality', {
  dampingFactor: 0.75,
  relationshipWeightProperty: 'trips'
})
YIELD centralityDistribution
RETURN centralityDistribution.max AS max, centralityDistribution.min AS min

// 3. Return the Id and Centrality properties of each zone (stream mode)
CALL gds.pageRank.stream('b9039814-centrality', {
  dampingFactor: 0.75,
  relationshipWeightProperty: 'trips'
})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS zone, score
ORDER BY zone ASC


// ------
// Task 3 - Zone Recommendation
// ------

// 1. Top 3 highest centrality zones per each community (including Manhattan)
MATCH (z:zone)
WITH z
ORDER BY z.community ASC, z.centrality DESC
WITH z.community AS community_id, COLLECT(z.id)[0..3] AS zones_id
UNWIND zones_id AS zone_id
RETURN zone_id, community_id

// 2. Top 3 highest centrality zones per each community (excluding Manhattan)
MATCH (z:zone)-[:IN]->(b:borough)
WHERE b.name <> "Manhattan"
WITH z
ORDER BY z.community ASC, z.centrality DESC
WITH z.community AS community_id, COLLECT(z.id)[0..3] AS zones_id
UNWIND zones_id AS zone_id
RETURN zone_id, community_id


















