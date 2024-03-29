# Preprocessing Tab

preprocessingBody <- function() {
  marker_sample_height <- "25em"
  panel_height <- "50em"
  plot_height <- "45em"
  
  # box with transformations: arcsinh, log or none
  transformationBox <- shinydashboard::box(
    div(
      id = "noTransformationWarning",
      shinydashboard::infoBox(
        title = "No Transformation Applied",
        subtitle = "You can ignore this warning if you supplied already transformed data.",
        value = "You should transform your raw cytometry data.",
        width = 12,
        color = "orange",
        fill = TRUE,
        icon = shiny::icon("exclamation-triangle")
      )
    ),
    textInput("cofactor", "Cofactor:", value = "5"),
    div(
      bsButton(
        "prepButton",
        "Start Transformation",
        icon = icon("tools"),
        style = "success"
      ),
      style = "float: right;"
    ),
    title = span(
      "Choose Cofactor for Arcsinh Transformation",
      icon("question-circle"),
      id = "cofactor"
    ),
    height = marker_sample_height,
    width = 4
  )
  
  cofactorPopover <-
    bsPopover(id = "cofactor",
              title = "Cofactor of the inverse hyperbolic sine transformation",
              content = "Recommended values for the cofactor parameter are 5 for mass cytometry (CyTOF) or 150 for fluorescence flow cytometry. Click on the Start Transformation button to do the arcsinh transformation.")
  
  downsamplingBoxPreprocessing <- shinydashboard::box(
    uiOutput("downsamplingBoxPreprocessing"),
    div(
      bsButton(
        "downsamplingButtonPreprocessing",
        "Perform Downsampling",
        icon = icon("filter"),
        style = "warning"
      ),
      style = "float: right;"
    ),
    title = span("Downsampling", icon("question-circle"), id="dsPrepPopover"),
    height = marker_sample_height,
    width = 4
  )
  
  dsPrepPopover <- bsPopover(
    id="dsPrepPopover",
    title = "Downsample your data",
    content = "If you have a big dataset and do not want to wait too long for your analyses, you can perform a downsampling on your dataset. If you choose to downsample per sample, the number of cells you specify will be randomly picked from each sample. Otherwise, the number you specify will be divided by the number of samples and this number will be randomly picked from each sample. If the number is bigger than the sample size, all cells from this sample will be taken."
  )
  
  # box with markers, samples and patients (all markers, patients, samples selected by default)
  selectingBox <- shinydashboard::box(
    #uiOutput("markersBox"),
    uiOutput("patientsBox"),
    uiOutput("samplesBox"),
    div(
      bsButton(
        "prepSelectionButton",
        "Visualize Selection",
        icon = icon("palette"),
        style = "success"
      ),
      style = "float: left;"
    ),
    div(
      bsButton(
        "filterSelectionButton",
        "Confirm Selection",
        icon = icon("filter"),
        style = "warning"
      ),
      style = "float: right;"
    ),
    title = span(
      "Selecting Samples and Patients",
      icon("question-circle"),
      id = "selecting"
    ),
    height = marker_sample_height,
    width = 4
  )
  
  selectingPopover <- bsPopover(id = "selecting",
                                title = "Analyse your data using all data or just a subclass.",
                                content = "After making a selection of markers, patients, and samples, press the <b>Visualize Selection</b> button to update the plots. By pressing the <b>Confirm Selection</b> button, the selection is applied to your data. <b>Unselected samples/patients are deleted permanently for further steps!</b>")
  
  
  # box for counts plots
  countsBox <- shinydashboard::box(
    uiOutput("designCounts"),
    title = span("Counts Plot", icon("question-circle"), id = "counts"),
    width = 12,
    height = plot_height
  )
  
  countsPopover <- bsPopover(id = "counts",
                             title = "Barplot showing the numbers of cells measured for each sample.",
                             content = "This plot can be used as a guide to identify samples where not enough cells were assayed.")
  
  
  # box for mds plots
  mdsBox <- shinydashboard::box(
    uiOutput("designMDS"),
    title = span("MDS Plot", icon("question-circle"), id = "mds"),
    width = 12,
    height = plot_height
  )
  
  mdsPopover <- bsPopover(id = "mds",
                          title = "Pseudobulk-level Multi-dimensional scaling plot.",
                          content = "Calculations are based on the median marker expression values. Ideally samples should cluster well within the same condition, although this depends on the magnitude of the difference between experimental conditions. With this diagnostic, outlier samples can be identified and eliminated if the circumstances warrant it.")
  
  
  # box for nrs plots
  nrsBox <- shinydashboard::box(
    uiOutput("designNRS"),
    title = span("NRS Plot", icon("question-circle"), id = "nrs"),
    width = 12,
    height = plot_height
  )
  
  nrsPopover <- bsPopover(id = "nrs",
                          title = "Plots non-redundancy scores (NRS) by feature in decreasing order of average NRS across samples.",
                          content = "The full points represent the per-sample NR scores, while empty black circles indicate the mean NR scores from all samples. Markers with higher score explain a larger portion of variability present in a given sample. The average NRS can be used to select a subset of markers that are non-redundant in each sample but at the same time capture the overall diversity between samples.")
  
  # box for exprs plots
  exprsBox <- shinydashboard::box(
    uiOutput("designExprs"),
    title = span("Expression Densities", icon("question-circle"), id = "exprs"),
    width = 12,
    height = plot_height
  )
  
  exprsPopover <- bsPopover(id = "exprs",
                            title = "Plots smoothed densities of marker intensities, with a density curve for each sample ID.",
                            content = "This plot helps to distinguish markers between conditions.")
  
  
  # box for exprs heatmpa plots
  exprsHeatmapBox <- shinydashboard::box(
    uiOutput("designExprsHeatmap"),
    title = span("Expression Heatmap", icon("question-circle"), id = "exprsHeatmap"),
    width = 12,
    height = plot_height
  )
  
  exprsHeatmapPopover <- bsPopover(id = "exprsHeatmap",
                                   title = "Heatmap of marker expressions aggregated by sample.",
                                   content = "Similar to the MDS plot, a heatmap gives insight into the structure of the data. The heatmap shows the median marker intensities with clustered columns (markers) and rows (samples). This plot shows which markers drive the observed clustering of samples.")
  
  
  # Preprocessing body
  preprocessingBody <- tabItem(
    tabName = "preprocessing",
    fluidRow(shinydashboard::box(
      div(
        "Preprocessing is essential in any mass cytometry analysis process. Usually, the raw marker intensities ready by a cytometer have stronly skewed distributions with varying of expression, thus making it difficult to distinguish between the negative and positive cell populations. The marker intensities are commonly transformed using arcsinh (inverse hyperbolic sine) to make the distributions more symmetric and  to map them to a comparable range of expression."
      ),
      div(
        "This step also includes some simple visualization plots to verify whether the data represents what we expect, for example, whether samples that are replicates of one condition are more similar and are distinct from samples from another condition. Depending on the situation, one can then consider removing problematic markers or samples from further analysis."
      ),
      title = h2("Data preprocessing"),
      width = 12
    )),
    
    # box for selecting transformation, markers, patients and samples
    fluidRow(
      transformationBox,
      cofactorPopover,
      downsamplingBoxPreprocessing,
      dsPrepPopover,
      selectingBox,
      selectingPopover
    ),
    
    # tabBox with simple visualization plots
    fluidRow(
      id = "plots",
      tabBox(
        tabPanel(
          fluidRow(countsBox, countsPopover),
          value = "plotCounts",
          title = "Counts"
        ),
        tabPanel(
          fluidRow(mdsBox, mdsPopover),
          value = "plotMDS",
          title = "MDS"
        ),
        tabPanel(
          fluidRow(nrsBox, nrsPopover),
          value = "plotNRS",
          title = "NRS"
        ),
        tabPanel(
          fluidRow(exprsBox, exprsPopover),
          value = "plotExpr",
          title = "Expr"
        ),
        tabPanel(
          fluidRow(exprsHeatmapBox, exprsHeatmapPopover),
          value = "plotHeatmapExpr",
          title = "Heatmap"
        ),
        id = "plots",
        title = "Simple Data Visualization",
        width = 12,
        height = panel_height
      )
    ),
    
    # possibility to reorder factors
    fluidRow(
      shinydashboard::box(
        uiOutput("reorderingTabs"),
        div(
          bsButton(
            "reorderButton",
            "Apply Reordering",
            icon = icon("sort"),
            style = "success"
          ),
          style = "float: right; margin-top: 5px; margin-right: 5px;"
        ),
        title = span("Column Reordering of Metadata", icon("question-circle"), id = "reorderingTabBoxTitle"),
        bsPopover(id = "reorderingTabBoxTitle",
                  title = "Reorder Metadata", 
                  placement = "top",
                  content = "You can reorder the columns of your metadata table. This can be helpfull if it has a natural order other than lexicographical."),
        width = 12,
        collapsible = TRUE,
        collapsed = TRUE
      ),
    )
  )
  return(preprocessingBody)
}
