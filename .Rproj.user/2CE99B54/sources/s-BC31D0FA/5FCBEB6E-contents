library("shiny")
library("tidyverse")
library("stringr")
library('stringi')
####################################################
#      Basic-Text-An-Emoji                    #
####################################################
library('tidyverse')
library('ggimage')
library('rwhatsapp')

options(shiny.maxRequestSize=30*1024^2) 

shinyUI(fluidPage(
  # Header:
  #headerPanel("Segmentation Analysis"),
  title = "Basic Text An (Emoji)",
  titlePanel(title=div(img(src="logo.png",align='right'),"Basic Text An (Emoji)")),
  # Input in sidepanel:
  sidebarPanel(
  fileInput("file", "Upload data (csv/text file with header)"),
  sliderInput("obs", "Top-N Emojis",
              min = 0, max = 20, value = 5
  )
  ),
  # Main:
  mainPanel( 
    
    tabsetPanel(type = "tabs",
             
                tabPanel("Overview",
                         h4(p("Data input")),
                         p("This shiny application requires input text which contains emojis (tweets, whatsapp chat etc.) data from the user. To do so, click on the Browse (in left side-bar panel) and upload the text file.
                            Note that this application can read csv file(comma delimited file)/ txt, so if you don't have required input format, first convert your data in csv format 
                            and then proceed. Make sure you have top row as variable name text"
                           ,align="justify"),
                         
                         br(),
                         
                         p("Once csv file is uploaded successfully, by-default application will show Top-5 emojis in text. In left-side bar panel you can change the number of emojis to display by moving slider.",
                           align="justify"),
                         br(),
                        h4(p("Download Sample files")), br(),
                         downloadButton('downloadData1', 'Download Sample file'), br(),br(),
                         
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -",
                           align="justify"),
                         img(src = "example1.png")),
                #tabPanel("Data",h3(textOutput("caption"),tableOutput("table"))),
                
                tabPanel("Summary Report",
                         plotOutput("plotsummary",height = 400, width = 500)),
                
                
                tabPanel("Top Emojis",h3("Top Emojis"), plotOutput("plotemoji",height = 700, width = 840))
         
                
                
    )
  ) 
) 
)
# tabPanel("PCA Variance Plot",plotOutput("plot1", width = "100%")),
# tabPanel("JSM Plot",plotOutput("plot", height = 800, width = 840)),