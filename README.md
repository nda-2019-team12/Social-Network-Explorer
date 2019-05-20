# Social-Network-Explorer

## Mapping and visualising the Subreddit Hyperlink Network  

This is a web application written in R using ShinyApp and Plotly. The application demonstrates some common network analysis approaches on a subset of the subreddit hyperlink network available from the Stanford SNAP project. http://snap.stanford.edu/data/soc-RedditHyperlinks.html

Due to the performance limitations of Shiny and strange behaviour of Plotly in R, some of the visualisations are interactive with limited functionality, while the rest are static ggplot2 elements. Likewise, due to the performance limitations of Shiny, most operations fetch precomputed static data rather than do transformations on the fly. This is also why most of the transformation functions in the library are not called, but their

The backend consists of the usual suspects of a ShinyApp, plus quite a few functions (denoted with f.something.R).

A dataflow diagram might be added later.

The application was built in about two weeks for a network data analytics course with four fellow students.
