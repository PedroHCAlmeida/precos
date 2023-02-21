library(tidyverse)

data = "2022-11-21"

df_oi_ibge2 = df_oi_ibge %>%
  group_by(Velocidade, Municípios, 
           UF, `Código IBGE`) %>%
  mutate(Valor_num = as.numeric(gsub(",", ".", Valor))) %>%
  group_modify(~.x %>%
                 mutate(Plano_detalhado = ifelse(Valor_num == min(Valor_num), "Internet", "oiplayTV"))) %>%
  mutate(Plano = ifelse(Plano_detalhado == "Internet",
                        "Internet", "Combo"))

df_oi_ibge2 %>% View()

precos_total = read.csv(file = "datasets/precos_csv.csv", 
                        sep = ";",
                        fileEncoding = "latin1")

precos_total %>% 
  filter((Provedora == "Oi" & Data == data)) %>%
  View()

precos = precos_total %>% 
  filter(!(Provedora == "Oi" & Data == data)) %>%
  bind_rows(df_oi_ibge2 %>% 
              mutate(Data = as.character(Data)) %>% 
              rename("Código.IBGE" = "Código IBGE") %>% 
              select(-Valor_num))

write.table(precos_total, file = "datasets/precos_Backup_csv.csv", sep = ";",
            append = F, quote = FALSE, fileEncoding = "latin1",
            col.names = T, row.names = FALSE)

write.table(precos, file = "datasets/precos_csv.csv", sep = ";",
            append = F, quote = FALSE, fileEncoding = "latin1",
            col.names = T, row.names = FALSE)












