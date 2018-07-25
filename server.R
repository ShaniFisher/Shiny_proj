library(DT)
library(shiny)
library(googleVis)

shinyServer(function(input, output,session){
  output$plot1<-renderPlot(
        ggplot(homes[which(homes$YearBuilt>1885),], 
         aes(YearBuilt, color=year_alter, fill=year_alter))+ 
          geom_histogram(alpha=.1))

    
  output$leaflet<-renderLeaflet(
      leaflet(data = homes[1:2500,]) %>%
        addTiles() %>% 
        addCircleMarkers(radius = ~sqrt(sale), fillOpacity = 0.00000001,weight =1.5))
  
  output$taxbar <- renderPlotly(
  homes[1:200,] %>% count(sale_range, tax_class_at_sale) %>%
    plot_ly(x = ~tax_class_at_sale, y = ~n, color = ~sale_range, type='bar'))
  
   output$taxcolor <- renderLeaflet(
     leaflet(data = homes[1:2500,]) %>%
       addProviderTiles("Hydda.Full") %>% 
       addCircleMarkers(radius =~ifelse(tax_class_at_sale=='1', 6,ifelse(tax_class_at_sale=='2', 9, 
                         ifelse(tax_class_at_sale=='4', 3, 10))), color=~pal(tax_class_at_sale), 
                          stroke =FALSE, fillOpacity=0.5) %>% 
     addLegend("bottomright", pal = pal, values = ~tax_class_at_sale,
               title = "Tax Classes"))
   
   observeEvent(input$show, {  
     proxy <- leafletProxy("taxcolor")  
     if(input$show) { 
     proxy %>% addMarkers(data=homes, clusterOptions = markerClusterOptions(),
                          label = ~ZipCode)
     } else {   
      proxy %>% clearMarkerClusters() 
      } 
     })
     
     
   output$plot2 <- renderPlot(
    ggplot(homes[which(homes$sale_price>45000000),], aes(x=sale_price, color=year_alter))+ 
     geom_density())
   
  
  
  })