library(jstager)
library(dplyr)
library(visNetwork)

d <- jstage_references("10.1241/johokanri.49.63", depth = 3)

edges <- d5 |>
  mutate(cited_doi = ifelse(is.na(cited_doi),
                            paste0("non-DOI ", row_number()),
                            cited_doi)) |>
  select(from = cited_doi, to = citing_doi)

nodes <- data.frame(id = unique(c(edges$from, edges$to))) |>
  left_join(
    d5 |>
      select(cited_doi, article_link) |>
      na.omit() |>
      distinct(),
    by = c("id" = "cited_doi")
  ) |>
  mutate(
    group = ifelse(!is.na(article_link), "J-Stage", "Outside J-Stage"),
    title = paste0("https://doi.org/", id)
  )
nodes$group[nodes$id == d5$citing_doi[1]] <- "J-Stage"

visNetwork(nodes, edges, width = "100%") |>
  visNodes(shape = "box", shadow = TRUE) |>
  visEdges(arrows = 'to', shadow = TRUE) |>
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) |>
  visLegend() |>
  visEvents(selectNode = "function(nodes) {
    var nodeId = nodes.nodes[0];
    var url = this.body.data.nodes.get(nodeId).title;
    if (url !== 'NA') {
      window.open(url, '_blank');
    }
  }") |>
  visLayout(randomSeed = 100)
