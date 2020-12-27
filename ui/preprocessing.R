# Preprocessing Tab

preprocessingBody <- function() {
  transform_height <- "15em"
  marker_sample_height <- "20em"
  panel_height <- "40em"
  plot_height <- "35em"
  
  # box with transformations: arcsinh, log or none
  transformationBox <- shinydashboard::box(
    prettyRadioButtons(
      inputId = "transformation",
      label = "Possible transformations:",
      choices = c("no", "log", "arcsinh"),
      selected = "no",
      icon = icon("check"),
      outline = TRUE
    ),
    div(
      bsButton(
        "prepButton",
        "Start Transformation",
        icon = icon("border-none"),
        style = "success"
      ),
      style = "float: right;"
    ),
    title = "Choose Transformation",
    height = transform_height,
    width = 6
  )
  
  # box for specifying cofactor when selecting arcsinh transformation
  cofactorBox <- conditionalPanel(
    condition = "input.transformation=='arcsinh'",
    shinydashboard::box(
      textInput("cofactor", "Cofactor:", value =
                  "5"),
      title = "Choose Cofactor of Arcsinh transformation",
      height = transform_height,
      width = 6
    )
  )
  
  # box with markers (all markers selected by default)
  markersBox <- shinydashboard::box(
    uiOutput("markersBox"),
    title = "Select Markers",
    height = marker_sample_height,
    width = 6
  )
  
  # box with samples (all samples selected by default)
  samplesBox <- shinydashboard::box(
    uiOutput("samplesBox"),
    title = "Select Samples",
    height = marker_sample_height,
    width = 6
  )
  
  # box for counts plots
  countsBox <- shinydashboard::box(
    uiOutput("designCounts"),
    title = "Barplot showing the numbers of cells measured for each sample",
    width = 12,
    height = plot_height
  )
  
  # box for mds plots
  mdsBox <- shinydashboard::box(
    uiOutput("designMDS"),
    title = "MDS plot",
    width = 12,
    height = plot_height
  ) 
  
  # box for nrs plots
  nrsBox <- shinydashboard::box(
    uiOutput("designNRS"),
    title = "NRS plot",
    width = 12,
    height = plot_height
  ) 
  
  # box for exprs plots
  exprsBox <- shinydashboard::box(
    uiOutput("designExprs"),
    title = "Exprs",
    width = 12,
    height = plot_height
  ) 
  
  # box for exprs heatmpa plots
  exprsHeatmapBox <- shinydashboard::box(
    uiOutput("designExprsHeatmap"),
    title = "Heatmap",
    width = 12,
    height = plot_height
  )
  
  # Preprocessing body
  preprocessingBody <- tabItem(
    tabName = "preprocessing",
    fluidRow(shinydashboard::box(
      div(
        "Preprocessing is essential in any mass cytometry analysis process. You have to choose a transformation to make the distributions more symmetric and to map them to a comparable range of expression."
      ),
      title = h2("Data preprocessing"),
      width = 12
    )),
    
    # box for selecting transformations
    fluidRow(transformationBox, cofactorBox),
    
    # box selecting markers and box selecting samples
    fluidRow(markersBox, samplesBox),
    
    # tabBox with simple visualization plots
    fluidRow(
      id = "plots",
      tabBox(
        tabPanel(fluidRow(countsBox), value = "plotCounts", title = "Counts"),
        tabPanel(fluidRow(mdsBox), value = "plotMDS", title = "MDS"),
        tabPanel(fluidRow(nrsBox), value = "plotNRS", title = "NRS"),
        tabPanel(fluidRow(exprsBox), value = "plotExpr", title = "Expr"),
        tabPanel(fluidRow(exprsHeatmapBox),value = "plotHeatmapExpr",title = "Heatmap"),
        id = "plots",
        title = "Simple Data Visualization",
        width = 12,
        height = panel_height
      )
    ),
  )
  return(preprocessingBody)
}