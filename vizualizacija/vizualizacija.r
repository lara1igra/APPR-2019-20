# 3. faza: Vizualizacija podatkov

library(ggplot2)
library(dplyr)
library(tmap)
library(rgdal)
library(tidyr)
library(rgeos)
library(ggpubr)
library(digest)
library(mosaic)
library(maptools)






# Uvozimo zemljevid.
#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                             pot.zemljevida="OB", encoding="Windows-1250")
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
#zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
#povprecja <- druzine %>% group_by(obcina) %>%
#  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))

# stolpični graf POVPREČNI TRANSPORT V 9 LETIH PO DRŽAVAH 

povprecje_blaga <- evropa_promet  %>% group_by(Države) %>%
  summarise(`povprecje blaga` = sum(Blago)/9)

povprecje_potnikov <- evropa_promet  %>% group_by(Države) %>%
  summarise(`povprecje potnikov` = sum(Potniki)/9)

graf_evropa_blago <- ggplot(data = povprecje_blaga, mapping = aes(x= Države, y= `povprecje blaga`)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  ggtitle('Povprečni transport blaga v 9 letih po državah') 

graf_evropa_potniki <- ggplot(data = povprecje_potnikov, mapping = aes(x= Države, y= `povprecje potnikov`)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  ggtitle('Povprečni transport potnikov v 9 letih po državah')

graf_evropa <- ggarrange(graf_evropa_blago, graf_evropa_potniki) 




# linijski grafi za UVOZ BLAGA


#cestni_blagovni_promet_uvoz <- filter(cestni_blagovni_promet,`NOTRANJI / MEDNARODNI PREVOZ` == 'uvoz')

#graf_ces_uvoz_blaga <- ggplot(data = cestni_blagovni_promet_uvoz, mapping = aes(x = cestni_blagovni_promet_uvoz$LETO, y = `Tone (1000)`)) +
#  geom_line(stat = 'identity', col ='green') +
#  ggtitle("Cestni promet uvoz blaga")


#graf_zel_uvoz_blaga <- ggplot(data = zelezniski_uvoz, mapping = aes(x=zelezniski_uvoz$LETO , y=zelezniski_uvoz$`Tone (1000)`)) + 
#  geom_line(stat = 'identity', col= 'blue') +
#  g("Železniški promet uvoz blaga")gtitle

 
#pristaniski_blagovni_promet <- filter(pristaniski_blagovni_promet, `RAZLOŽENI IN NALOŽENI TOVOR` == 'uvoz') 

#graf_pris_uvoz_blago <- ggplot(pristaniski_blagovni_promet %>% filter(tovor == "uvoz"),
#                               aes(x=leto, y=tone))+
#  geom_line(stat = 'identity', col ='yellow') +
#  ggtitle("Pristaniški promet uvoz blaga")



graf_uvoz_blago <- ggplot(blagovni_promet %>% filter(tovor == "uvoz"),
                          aes(x=leto, y=tone, color=tip)) + geom_line() +
  ggtitle("Uvoz blaga")


graf_izvoz_blago <- ggplot(blagovni_promet %>% filter(tovor == "izvoz"),
                          aes(x=leto, y=tone, color=tip)) + geom_line() +
  ggtitle("Izvoz blaga")

graf_uvoz_potnikov <- ggplot(potniski_promet %>% filter(tovor == 'uvoz'),
                              aes(x=leto, y = potniki, color = tip))+ geom_line() +
  ggtitle('Izvoz potnikov')


graf_izvoz_potnikov <- ggplot(potniski_promet %>% filter(tovor == 'izvoz'),
                              aes(x=leto, y = potniki, color = tip))+ geom_line() +
  ggtitle('Izvoz potnikov')


  


#ZEMLJEVIDI

data(World)
evropa <- filter(World, continent == "Europe") %>% 
  rename(Države = name)

podatki <- left_join(evropski_blagovni_promet, evropa, by = c('Države')) %>% filter(Leto == '2018')

