library(tidyverse)
library(DBI)

precos = read.csv2("datasets/precos_csv.csv", fileEncoding = "latin1")

con = dbConnect(RSQLite::SQLite(), "~/Fibrasil/BD/Acessos.db")
cidades = tbl(con, "Municipios")
acessos = tbl(con, "Cidades")

precos_500 = precos |>
  filter(Data == max(Data),
         Provedora == "VIVO", 
         Velocidade == 500) |>
  pull(`Código.IBGE`) |>
  unique()

precos_600 = precos |>
  filter(Data == max(Data),
         Provedora == "VIVO", 
         Velocidade == 600) |>
  pull(`Código.IBGE`) |>
  unique()

precos_list = list(p500 = precos_500,
                   p600 = precos_600)

sapply(precos_list, length)

codigo_vivo = precos |>
  filter(Data == max(Data),
         Provedora == "VIVO")  |>
  pull(`Código.IBGE`) |>
  unique()

cidades_groups = cidades |>
  filter(codigo_ibge %in% !!(codigo_vivo)) |>
  mutate(
    group = as.character(ifelse(
      codigo_ibge %in% !!(precos_500), 
      500, 
      600
    ))
  )

medias = cidades_groups |>
  collect() |>
  group_by(group) |>
  summarise_if(
    is.numeric, 
    mean
  )
medias |>
  View()

acessos_groups = acessos |>
  filter(
    codigo_ibge_municipio %in% !!(codigo_vivo),
    mes == 10,
    ano == 2022
    ) |>
  mutate(
    group = as.character(ifelse(
      codigo_ibge_municipio %in% !!(precos_500), 
      500, 
      600
    ))
  ) |>
  collect()


medias_mercado = acessos_groups |>
  group_by(group) |>
  summarise_if(
    is.numeric, 
    mean
  )
medias_mercado |>
  View()

###########################################

acessos_groups |>
  ggplot() +
  aes(
    y = municipio, 
    x = acessos_vivo,
    fill = group
    ) |>
  geom_col() +
  facet_wrap(~group)

x = empresas |> distinct(uf) |> collect() |> c()
x
##################################################################################

acessos_bruto = tbl(con, "acessos")
net_adds_vel = acessos_bruto |>
  filter(codigo_ibge_municipio %in% !!(cidades_vivo$Código.IBGE)) |>
  group_by(codigo_ibge_municipio, velocidade, empresa, ano, mes) |>
  mutate(
    acessos = sum(acessos)
  ) |>
  mutate(
    net_adds = acessos - lag(acessos)
  ) |> 
  filter(
    ano == 2022,
    mes == 10
    ) |>
  ungroup() |>
  collect()

net_adds_vel




















