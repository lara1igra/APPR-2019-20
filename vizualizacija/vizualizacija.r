# 3. faza: Vizualizacija podatkov

library(ggplot2)
library(dplyr)
library(tmap)
library(rgdal)
library(rgeos)
library(ggpubr)



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
graf_let_uvoz_blaga <- ggplot(data = letalski_promet_uvoz, mapping = aes(x= Leto, y = Tone))+
  geom_line(stat = 'identity', col ='red') +
  ggtitle("Letalski promet uvoz blaga")


cestni_blagovni_promet_uvoz <- filter(cestni_blagovni_promet,`NOTRANJI / MEDNARODNI PREVOZ` == 'uvoz')

graf_ces_uvoz_blaga <- ggplot(data = cestni_blagovni_promet_uvoz, mapping = aes(x = cestni_blagovni_promet_uvoz$LETO, y = `Tone (1000)`)) +
  geom_line(stat = 'identity', col ='green') +
  ggtitle("Cestni promet uvoz blaga")




graf_zel_uvoz_blaga <- ggplot(data = zelezniski_uvoz, mapping = aes(x=zelezniski_uvoz$LETO , y=zelezniski_uvoz$`Tone (1000)`)) + 
  geom_line(stat = 'identity', col= 'blue') +
  ggtitle("Železniški promet uvoz blaga")
print(graf_zel_uvoz_blaga)
 
pristaniski_blagovni_promet <- filter(pristaniski_blagovni_promet, 'RAZLOŽENI IN NALOŽENI TOVOR' == 'uvoz') 

graf_pris_uvoz_blago <- ggplot(date= pristaniski_blagovni_promet, mapping = aes(x= pristaniski_blagovni_promet$LETO, y = pristaniski_blagovni_promet$`Tone [1000]`))+
  geom_line(stat = 'identity', col ='yellow') +
  ggtitle("Pristaniški promet uvoz blaga")

print(graf_pris_uvoz_blago)



#linijski grafi ZA IZVOZ BLAGA
x <- ggarrange(graf_let_uvoz, promet2) #dobimo na istem listu oba grafa 




