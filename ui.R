library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin = 'purple',
  dashboardHeader(title = "Contribution of Sales"),
  dashboardSidebar(
   sliderInput(inputId="slider1",
                label = "Slider Based on Years",
                min = 1,
                max = 50,
                value = 30),
    sidebarMenu(
      menuItem('Plots',tabName='alteration',icon=icon('signal')),
      menuItem('Map_1', tabName='map',icon=icon('map')),
      menuItem('Map_2',tabName = 'plot', icon = icon('map')),
      menuItem('Bar Plot', tabName= 'graph', icon = icon('bar-chart-o'))
    )),
  dashboardBody(tabItems(
    tabItem(tabName='alteration', titlePanel('If Renevated'),
      box(plotOutput('plot1'),height = 300),
      box(plotOutput('plot2'), height=300)),
                         
    tabItem(tabName ='map', titlePanel('Size by Price'),
      fluidRow(box(leafletOutput('leaflet')))),
                         
    tabItem(tabName='plot', titlePanel('Color by Tax Class'),
      box(leafletOutput('taxcolor'),
          height = 300, 
          br(),
          checkboxInput('show', 'Add Zips', value=FALSE))),
    
    tabItem(tabName='graph', titlePanel('Tax Class by Price'),
      fluidRow(box(plotlyOutput('taxbar'), height = 300)))
        
                         
  ))))
  
