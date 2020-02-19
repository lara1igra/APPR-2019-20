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
library(readr)
library(tmaptools)
library(RColorBrewer)







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
  ggtitle('Povprečni transport blaga v 9 letih po državah') +
  ylab('Povprečje blaga')

graf_evropa_potniki <- ggplot(data = povprecje_potnikov, mapping = aes(x= Države, y= `povprecje potnikov`)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  ggtitle('Povprečni transport potnikov v 9 letih po državah')+
  ylab('Povprečje potnikov')

graf_evropa <- ggarrange(graf_evropa_blago, graf_evropa_potniki) 




# linijski grafi za UVOZ BLAGA


graf_uvoz_blago <- ggplot(blagovni_promet %>% filter(tovor == "uvoz"),
                          aes(x=leto, y=tone, color=tip)) + geom_line() +
  ggtitle("Uvoz blaga")


graf_izvoz_blago <- ggplot(blagovni_promet %>% filter(tovor == "izvoz"),
                          aes(x=leto, y=tone, color=tip)) + geom_line() +
  ggtitle("Izvoz blaga")

graf_uvoz_potnikov <- ggplot(potniski_promet %>% filter(tovor == 'uvoz'),
                              aes(x=leto, y = potniki, color = tip))+ geom_line() +
  ggtitle('Uvoz potnikov')


graf_izvoz_potnikov <- ggplot(potniski_promet %>% filter(tovor == 'izvoz'),
                              aes(x=leto, y = potniki, color = tip))+ geom_line() +
  ggtitle('Izvoz potnikov')




#ZEMLJEVIDI

evropski_blagovni_promet_2018 <- filter(evropski_blagovni_promet, Leto == '2018')
evropski_potniski_promet_2018 <- filter(evropski_potniski_promet, Leto == '2018')
data(World)

evropa <- filter(World, continent == "Europe") %>% 
  rename(Države = name)



podatki <- merge(evropa, evropski_blagovni_promet_2018, by="Države", all.x=TRUE) %>% 
  rename(drzava=Države) 
podatki2 <- merge(evropa, evropski_potniski_promet_2018, by='Države', all.x=TRUE) %>%
  rename(drzava = Države)



zemljevid_blagovnega_prometa <- tm_shape(podatki %>% set_projection("latlong"),
                                         xlim=c(-15, 35), ylim=c(32, 72)) +
  tm_polygons("Blago") + tm_legend(legend.position=c("left", "top"))

zemljevid_potniskega_prometa <- tm_shape(podatki2 %>% set_projection("latlong"),
                                         xlim=c(-15, 35), ylim=c(32, 72)) +
  tm_polygons("Potniki") + tm_legend(legend.position=c("left", "top"))






#primer iz vaj 
#source("https://raw.githubusercontent.com/jaanos/APPR-2019-20/master/lib/uvozi.zemljevid.r")
#data("World")
#svet <- tm_shape(World) + tm_polygons("HPI")
#print(svet)











  