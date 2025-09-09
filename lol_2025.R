library(dplyr)
library(ggplot2)
# прочитати
lol_2025 <- read.csv('lol_2025.csv')

# продивитись перші рядки таблиці
readLines("lol_2025.csv", n = 10)

class(lol_2025)
str(lol_2025)
summary(lol_2025)

# фільтр за найнижчою складністю та універсальністю
lol_2025 %>% 
  filter(difficulty == 1) %>%
  filter(style <= 20) %>%
  group_by (herotype)

# гістограма за ціною героїв
ggplot(lol_2025,aes(x=rp)) + geom_histogram(bins=172, color="brown", fill="pink")