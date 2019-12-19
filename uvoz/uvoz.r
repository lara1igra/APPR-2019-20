# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(tidyr)
library(rvest)
library(gsubfn)

#sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    if (is.character(tabela[[col]])) {
      tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
    }
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# 1. tabela  

letalski_potniski_in_blagovni_promet <- read_csv2("podatki/letalski_potniški_in_blagovni_promet.csv", skip=2,
                    locale=locale(encoding="CP1250")) %>% separate(MESEC, sep="M", c("Leto", "Mesec")) %>%
    mutate(Leto=parse_number(Leto), Mesec=parse_number(Mesec))

letalski_potniski_in_blagovni_promet <- letalski_potniski_in_blagovni_promet[,-c(4,5)] 

# 2. tabela 

zelezniski_potniski_promet <- read_csv2("podatki/zelezniski_potniski_promet.csv", skip = 1, locale=locale(encoding="CP1250")) 
zelezniski_potniski_promet <- zelezniski_potniski_promet[,-c(4)]

zelezniski_blagovni_promet <- read_csv2('podatki/zelezniski_blagovni_promet.csv', skip= 1,locale=locale(encoding="CP1250"))

zelezniski_promet <- inner_join(zelezniski_blagovni_promet, zelezniski_potniski_promet)[, -c(4)] # %>% rename(TRANSPORT = NOTRANJI / MEDNARODNI PREVOZ)

#nova  <- filter(zelezniski_promet, `NOTRANJI / MEDNARODNI PREVOZ`== 'Mednarodni prevoz - potniki vstopili v Sloveniji')

# 3. tabela 

cestni_blagovni_promet <- read_csv2('podatki/cestni_blagovni_promet.csv', skip= 1,locale=locale(encoding="CP1250"))
cestni_blagovni_promet <- cestni_blagovni_promet[,-c(4, 5)]

# 4. tabela 

pristaniski_potniski_promet <- read_csv2 ('podatki/pristaniski_potniski_promet.csv', skip = 1, locale=locale(encoding="CP1250"), na = '0') 

pristaniski_blagovni_promet <- read_csv2('podatki/pristaniski_blagovni_promet.csv', skip = 1, locale = locale(encoding="CP1250"), na = '0')
#pristaniski_promet <- inner_join(pristaniski_blagovni_promet, pristaniski_potniski_promet)

# 5. tabela 
#lin <- 'file:///C:/Users/Lara/Downloads/rail_pa_total%20(1).html'
#stran <- html_session(lin) %>% read_html()
#tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#  .[[1]] %>% html_table(dec=",")

evropski_potniski_promet <- read_csv('podatki/evropa_ljudje.csv' ,  locale=locale(encoding="CP1250"), na = ':') %>% select('TIME', 'GEO', 'Value') %>% rename(Leto = TIME, Države = GEO, Potniki = Value )

evropski_blagovni_promet <- read_csv('podatki/evropa_dobrine.csv' ,  locale=locale(encoding="CP1250"), na = ':') %>% select('TIME', 'GEO', 'Value') %>% rename(Leto = TIME, Države = GEO, Blago = Value )

evropa_promet <- inner_join(evropski_blagovni_promet, evropski_potniski_promet)

#filter(evropa_promet, Blago != 'NA', Potniki != 'NA' )

# Zapišimo podatke v razpredelnico obcine
#obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
