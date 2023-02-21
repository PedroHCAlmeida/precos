library(DBI)
library(tidyverse)

con = dbConnect(RSQLite::SQLite(), "~/Fibrasil/BD/Acessos.db")
empresas = tbl(con, "empresas")

rank_empresas = empresas |>
  filter(
    ano == 2022
  ) |>
  select(
    ano, 
    mes, 
    empresa,
    codigo_ibge_municipio,
    acessos_empresa,
    municipio
  ) |>
  group_by(
    ano, 
    mes,
    codigo_ibge_municipio,
    empresa,
    municipio
  ) |>
  summarise(
    acessos_empresa = sum(acessos_empresa)
  ) |>
  ungroup() |>
  group_by(
    ano, 
    mes,
    codigo_ibge_municipio,
    municipio
  ) |>
  mutate(
    rank = rank(-acessos_empresa)
  ) 

empresas_top_1 = rank_empresas |>
  group_by(
    empresa,
    ano,
    mes
  ) |>
  summarise(
    top_1_cidades = sum(ifelse(rank == 1, 1, 0))
  ) 

claro = rank_empresas |>
  filter(empresa == "CLARO", rank == 1, mes == 10) |>
  collect()

claro |>
  arrange(desc(acessos_empresa)) |>
  View()

empresas_top_1 |> 
  filter(mes == 10) |>
  arrange(desc(top_1_cidades))

empresas_top_1 |> 
  filter(mes == 9) |>
  arrange(desc(top_1_cidades))

empresas_top_1 |> 
  filter(mes == 8) |>
  arrange(desc(top_1_cidades))












