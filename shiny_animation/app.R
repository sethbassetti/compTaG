source("animation_helper.R")
source("ThreeDimPlot.R")
library("shiny")


ui <- fluidPage(
    titlePanel("PD visualizer"),
    tabsetPanel(
        tabPanel("2D", fluid=TRUE,
            sidebarLayout(
                sidebarPanel(
                    
                    sliderInput(inputId = "num",
                                label = "Choose a number between 0 and two pi",
                                value = 25, min = 0, max = round(2*pi, 2), step=.1, round= -2),
                    checkboxInput("diagonals", label = "Toggle Diagonals", value = FALSE),
                    checkboxInput("filtlines", label="Toggle Filtration lines", value=FALSE),
                    fileInput("graphfile", "Choose DOT File", accept = ".dot", multiple=FALSE)
                   
                ),
                
                
                
                mainPanel(plotOutput("PD")),
            ),
    ),
    tabPanel("3D", fluid=TRUE,
             sidebarLayout(
                 sidebarPanel(
                     sliderInput(inputId="theta", label="Choose a number between 0 and  pi for theta",
                                 value = 0, min=0, max=360, step=1, round=-2),
                     sliderInput(inputId="phi", label="Choose a number between 0 and two pi for phi",
                                 value = 0, min=0, max=180, step=1, round=-2),
                     checkboxInput("diagonals3d", label = "Toggle Diagonals", value = FALSE),
                     checkboxInput("filtlines3d", label="Toggle Filtration lines", value=FALSE),
                     fileInput("graphfile3d", "Choose DOT File", accept = ".dot", multiple=FALSE)
                 ),
                 mainPanel(fluidRow(column(1, offset=0, rglwidgetOutput("ThreePD",  width = 400, height = 150))),
                           fluidRow(plotOutput('plot1')))
                 #mainPanel(rglwidgetOutput("ThreePD", width=400, height=150))
        
             )
             
             
             
             )
    )
    
    
)

server <- function(input, output){
    
    
    output$PD <- renderCachedPlot({
        createPlot(input$num, input$diagonals, input$filtlines, input$graphfile)
        
        
        
    },
    cacheKeyExpr = {paste(toString(input$num),"Diagonals: ", input$diagonals, "filtlines: ", input$filtlines, "file: ", input$graphfile$datapath)}
    )
    output$plot1 <- renderPlot({plotPD3D(input$theta, input$phi, input$graphfile3d, input$diagonals3d)})
    output$ThreePD <- renderRglwidget({
        plot3d(input$phi, input$theta, input$graphfile3d, input$filtlines3d)
    }
    )
}
shinyApp(ui = ui, server = server)