library(rvest)
library(RSelenium)
library(tidyverse)
library(netstat)
library(stringr)

ceps = read_delim(
  "~/Fibrasil/Datasets/ceps.txt",
  col_names = F
)

colnames(ceps) = c("Cep", "Cidade", "Bairro", "Endereço")

ceps_manaus = ceps |>
  filter(
    Cidade == "Manaus/AM"
  )


# Iniciando a sessão 
rs_driver_object = rsDriver(
  browser = "chrome",
  chromever = "108.0.5359.22",
  verbose = F,
  port = free_port(random = T)
)

# Definindo o cliente 
remDr = rs_driver_object$client

# Link do site
link = "https://busqnet.com/planos-internet/am/manaus/?operadora=oi&tecnologia=fibra-fibracabo"

remDr$navigate(link)

coberturas = list()

for(cep in ceps_manaus$Cep){

  cep_input = remDr$findElement(
    using = "xpath",
    "//*[@id='cep']"
  )
  
  num = "100"
  
  cep_input$clickElement()
  cep_input$sendKeysToElement(list(paste0(as.character(cep), num)))
  
  pesquisar_button = remDr$findElement(
    using = "xpath",
    "//*[text()='Pesquisar']"
  )
  pesquisar_button$clickElement()
  
  Sys.sleep(2)
  remDr$navigate(link)
  Sys.sleep(2)
  source = remDr$getPageSource()[[1]]
  
  cobertura = source |>
    read_html() |>
    html_nodes(xpath = "//*[contains(@class, 'info_oi')]") |>
    html_text()
  
  append(coberturas, cobertura)
  
}



