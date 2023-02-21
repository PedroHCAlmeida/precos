library(tidyverse)

precos = read.csv2("datasets/precos_csv.csv", fileEncoding = "latin1")


precos |>
  filter(
    Provedora == "CLARO",
    Plano_detalhado == "Internet",
    Velocidade == 500,
    Valor < 50
  ) |> pull(Municípios) |> n_distinct()

precos |>
  filter(
    Provedora == "CLARO",
    Velocidade == 500,
    Valor < 50,
    Data == as.Date("2022-11-03")
  ) |> pull(Municípios) |> n_distinct()
