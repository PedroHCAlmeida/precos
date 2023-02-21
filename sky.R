library("rvest")
library("RSelenium")
library("tidyverse")
library("netstat")
library("readxl")
library("stringr")

municipios_sky = readxl::read_excel(
  "datasets/Portal Billing.xlsx",
  skip = 1
) |>
  mutate(
    numero = str_split(municipios_sky$Endereço, ",") |> 
      lapply(last) |>
      unlist()
  )

str_split(municipios_sky$Endereço, ",") |>
  lapply(last) |> 
  unlist()

rs_driver_object = rsDriver(
  browser = "chrome",
  chromever = "108.0.5359.22",
  verbose = F,
  port = free_port(random = T)
)

# Definindo o cliente 
remDr = rs_driver_object$client

sky_link = "https://assine.sky.com.br/?utm_source=institucional&utm_medium=own&utm_content=quero-ser-sky&utm_campaign=menu-quero-ser-sky&_ga=2.29000892.104360819.1674593562-449345165.1672249804"

remDr$navigate(sky_link)  

df_sky = list()

for(city in municipios_sky$Cidade[-1]){
   
  dados_cidades = municipios_sky |>
    filter(
      Cidade == city
    )
  crit = NA
  i = 1
  while(is.na(crit)){
    alterar = remDr$findElement(
      using = "xpath", 
      '//*[@id="sky-component-regionalization-expanded-185e5a1709c"]/div[2]/div/a'
    )
    alterar$clickElement()
    
    cep =  dados_cidades$Cep[i]
    numero = dados_cidades$numero[i]
     
    cep_input = remDr$findElement(
     using = "xpath",
     "//*[contains(@id, 'regionalizationInputCepId')]"
    )
    cep_input$clickElement()
    cep_input$sendKeysToElement(list(as.vector(cep)))
     
    numero_input = remDr$findElement(
     using = "xpath",
     "//*[contains(@id, 'regionalizationInputNumber')]"
    )
     
    numero_input$clickElement()
    numero_input$sendKeysToElement(list(as.vector(numero)))
    
    button = remDr$findElement(
     using = "xpath",
     '//*[@id="submitFormRegionalizationExpanded"]'
    )
    button$clickElement()
    
    crit = 1
    
    source = remDr$getPageSource()[[1]] |>
      read_html()
  
    cards = source |>
      html_nodes(".box-clean")
    
    cards |>
      lapply(
        function(card)
          card |> 
            
      )
    
    }
}











