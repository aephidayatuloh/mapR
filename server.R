library(rgdal)     # R wrapper around GDAL/OGR
library(ggplot2)   # for general plotting
library(ggmap)    # for fortifying shapefiles
library(gridExtra)

# First read in the shapefile, using the path to the shapefile and the shapefile name minus the
# extension as arguments
# shpfiledist <- readOGR("D://Project/Shiny/mapR/map", "map")
# shpfileprov <- readOGR("D://Project/Shiny/mapR/map", "IDN_adm1")
# shpfiledist <- readRDS("D://Project/Shiny/mapR/map/IDN_adm2.rds")
# shpfileprov <- readRDS("D://Project/Shiny/mapR/map/IDN_adm1.rds")

# Next the shapefile has to be converted to a dataframe for use in ggplot2
# shpfiledist_df <- fortify(shpfiledist)
# shpfiledist_df$long <- round(shpfiledist_df$long, 3)
# shpfiledist_df$lat <- round(shpfiledist_df$lat, 3)
# shpfiledist_df <- shpfiledist_df[!duplicated(shpfiledist_df[,names(shpfiledist_df)!="order"]),]

# shpfileprov_df <- fortify(shpfileprov)
# shpfileprov_df$long <- round(shpfileprov_df$long, 2)
# shpfileprov_df$lat <- round(shpfileprov_df$lat, 3)
# shp_df <- shpfileprov_df[!duplicated(shpfileprov_df[,names(shpfileprov_df)!="order"]),]

# mapProv <- ggplot(data = shp_df,
#               aes(x = long, y = lat, group = group, fill = id)) +
#   geom_polygon() +
#   theme_classic() +
#   coord_equal() +
#   # ggtitle("Peta Sebaran Penduduk Indonesia 2015") +
#   theme(axis.line=element_blank(),axis.text.x=element_blank(),
#         axis.text.y=element_blank(),axis.ticks=element_blank(),
#         axis.title.x=element_blank(),
#         axis.title.y=element_blank())
#   scale_fill_gradient(low = "white", high = "blue") 
# 
# mapDistrict <- ggplot(data = shapefiledist_df,
#                   aes(x = long, y = lat, group = group, fill = as.numeric(group))) +
#   geom_polygon() +
#   theme_classic() +
# #   # ggtitle("Peta Sebaran Penduduk Indonesia 2015") +
#   theme(axis.line=element_blank(),axis.text.x=element_blank(),
#         axis.text.y=element_blank(),axis.ticks=element_blank(),
#         axis.title.x=element_blank(),
#         axis.title.y=element_blank()) +
#   coord_equal() +
#   scale_fill_gradient(low = "white", high = "blue")

# save.image("D://Project/Shiny/mapR/data/mapR.RData")

load("data/mapR.RData")

# Now the shapefile can be plotted as either a geom_path or a geom_polygon.
# Paths handle clipping better. Polygons can be filled.
# You need the aesthetics long, lat, and group.
shinyServer(function(input, output, session){
  
  fil_labs <- reactive({
    ifelse(input$tahun=="Select", "Provinsi", paste("Tahun", input$tahun))
  })
  fil_value <- reactive({
    ifelse(input$tahun=="Select", "NAME_1", paste("tahun", input$tahun, sep = "_"))
  })
  
    datasetInput <- reactive({
      shp_df
    })
    
    output$mapTitle <- renderUI({
      h4(paste(input$data, "Tahun", input$tahun))
    })
    plotInput <- reactive({
      mapProv <- ggplot(data = df2,
                    aes_string(x = "long", y = "lat", group = "group", 
                               # fill = paste("tahun", input$tahun, sep = "_"))) +
                               fill = fil_value())) +
        geom_polygon() +
        theme_classic() +
        coord_equal() +
        theme(axis.line=element_blank(),axis.text.x=element_blank(),
              axis.text.y=element_blank(),axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank()) +
        labs(fill = fil_labs(),
             caption = paste("Sumber: BPS, 2017")) +
          scale_fill_gradient(low = input$collo, high = input$colhi)
    })
    
    output$mapPlot <- renderPlot({
      print(plotInput())
    })
    
    output$downloadData <- downloadHandler(
      filename = function() { 
        paste(input$data, "_", input$tahun, '.csv', sep='') 
      },
      content = function(file) {
        write.csv(datatasetInput(), file)
      }
    )
    output$downloadMap <- downloadHandler(
      filename = function() { paste(input$data, "_", input$tahun, '.png', sep='') },
      content = function(file) {
        device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
        ggsave(file, plot = plotInput(), device = device)
      }
    )
})
