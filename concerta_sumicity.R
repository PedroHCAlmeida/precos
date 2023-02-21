
precos = read.csv2(
  "datasets/precos_csv.csv",
  fileEncoding = "latin1"
)  |>
  select(-`Código.IBGE`) |>
  rename(
    "Código.IBGE" = "Código.IBGE.1"
  ) 

sumicity = precos |>
  filter(Provedora == "SUMICITY")

df_sumicity_clean = df_sumicity_ibge |> 
  mutate(Provedora = str_to_upper(Provedora),
         Plano_detalhado = str_replace(Plano_detalhado, "HBOMax", "Hbo"),
         Plano = ifelse(Plano_detalhado == "Internet", "Internet", "Combo")) %>% 
  distinct_all() %>%
  filter(!is.na(Velocidade), !is.na(Valor), Valor != "")

df_sumicity_clean_total = df_sumicity_clean |>
  mutate(
    Data = "2023-01-23"
  ) |>
  rbind(
    df_sumicity_clean |>
      mutate(Data = "2023-01-16")
  )

precos_clean = precos |>
  filter(
    Provedora != "SUMICITY" | (Provedora == "SUMICITY" & Data < as.Date("2023/01/15"))
  ) |>
  mutate(Valor = as.character(Valor)) |>
  bind_rows(
    df_sumicity_clean_total |>
      rename(
        "Código.IBGE" = `Código IBGE`
      )
  ) |>
  arrange(Data, Provedora, Velocidade) |>
  mutate(
    Valor = gsub("\\.", ",", Valor)
  )

precos_clean |> 
  write.table(file = "datasets/precos_csv.csv", sep = ";",
              append = F, quote = FALSE, fileEncoding = "latin1",
              col.names = T, row.names = FALSE)

