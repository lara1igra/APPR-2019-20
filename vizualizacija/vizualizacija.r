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

evropski_blagovni_promet_2018 <- filter(evropski_blagovni_promet, Leto == '2018')
data(World)

evropa <- filter(World, continent == "Europe") %>% 
  rename(Države = name)



source("https://raw.githubusercontent.com/jaanos/APPR-2019-20/master/lib/uvozi.zemljevid.r")
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", mapa = "zemljevidi", pot.zemljevida = "", encoding = "UTF-8") %>% 
  fortify() %>% filter(CONTINENT == "Europe")



colnames(zemljevid)[11] <- 'drzava'
zemljevid$drzava <- as.character(zemljevid$drzava)



podatki <- merge(evropa, evropski_blagovni_promet_2018, by="Države", all.x=TRUE) %>% 
  rename(drzava=Države) 


  

zemljevid_blagovnega_prometa <- tm_shape(podatki) + tm_polygons("Blago")
print(zemljevid_blagovnega_prometa)

#poiskus <- ggplot() +
#  geom_polygon(data = podatki %>% right_join(zemljevid, by = c("drzava" = "drzava")), aes(x = long, y = lat, group = group, fill = Blago, alpha = 0.8, color = "black"))+
#  scale_fill_gradient2(low = "green", mid = "yellow", midpoint = 80) + 
#  xlab("") + ylab("") + ggtitle("Transport blaga v železniškem prometu")+
#  guides(fill=guide_legend(title="Povprečje")) + theme(plot.title = element_text(hjust = 0.5))


#primer iz vaj 
#source("https://raw.githubusercontent.com/jaanos/APPR-2019-20/master/lib/uvozi.zemljevid.r")
#data("World")
#svet <- tm_shape(World) + tm_polygons("HPI")
#print(svet)











  