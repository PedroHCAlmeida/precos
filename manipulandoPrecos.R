library(readr)
library(tidyverse)

precos_total = c("2022-10-21", "2022-10-24", "2022-10-31", "2022-11-03") %>%
  map(function(i) read.csv(file = sprintf("datasets/precos%s.csv", i),
                           sep = ",")) %>%
  bind_rows()

precos = precos_total %>%
  rename("Plano_detalhado" = Plano)  %>%
  mutate(Plano = ifelse(Plano_detalhado == "Internet",
                        "Internet", "Combo"))

precos %>% View()

write.table(precos, file = "datasets/precos_csv.csv", sep = ";",
            append = F, quote = FALSE, fileEncoding = "latin1",
            col.names = T, row.names = FALSE)




