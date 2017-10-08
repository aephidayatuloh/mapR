library(shiny)
library(shinythemes)
library(shinyjs)
library(colourpicker)

mycss <- "
#plot-container {
  position: relative;
}
#loading-spinner {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 10%;
  z-index: -1;
  margin-top: -33px;  /* half of the spinner's height */
  margin-left: -33px; /* half of the spinner's width */
}
#plot.recalculating {
  z-index: -2;
}
navbarPage {
  weight: bold;
}
h3 {
  color: red;
  weight: bold;
}
h4 {
  text-align: center;
}
colourInput {
  width: 50%;
}
"
PAGE_TITLE <- "Sebaran Spasial Kondisi Indonesia"
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(tags$style(HTML(mycss))),
  theme = shinytheme("cerulean"),
  titlePanel(windowTitle = PAGE_TITLE,
             title =
               div(
                 img(
                   src = "ipb.png",
                   height = 70,
                   width = 70,
                   style = "margin:10px 10px"
                 ),
                 PAGE_TITLE 
               )
  ),
  # Application title
  navbarPage("Disiapkan oleh : Departemen Statistika IPB"),
  fluidRow(
    column(3,
           selectInput(inputId = "data", "Sektor", 
                       choices = list("Indeks Pembangunan Manusia", 
                                      "Kemiskinan dan Ketimpangan",
                                      "Pendidikan")),
           selectInput(inputId = "tahun", "Tahun", 
                       choices = c(2010:2016)),
           column(6,
                  colourInput("collo", "Rendah", value = "white")
                ),
           column(6,
                  colourInput("colhi", "Tinggi", value = "blue")
                  ),
           br(),
           br(),
           br(),
           br(),
           br(),
           br(),
           br(),
           br(),
           
           h3("Tahukah Anda?"),
           p("Hingga tahun 2017 Indonesia terdiri dari 34 provinsi dan 444 kabupaten/kota.")
           ),
    column(9,
           # tableOutput("preview"),
           div(id = "plot-container",
               tags$img(src = "mapLoading.gif",
                        id = "loading-spinner"),
               uiOutput("mapTitle"),
               plotOutput("mapPlot")
              ),
                downloadLink("downloadData", "Data"),
                downloadLink("downloadMap", "Peta")
           )
    )
  
  )
)
