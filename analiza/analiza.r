# 4. faza: Analiza podatkov

library(GGally)
library(mgcv)
#podatki <- obcine %>% transmute(obcina, povrsina, gostota,
#                                gostota.naselij=naselja/povrsina) %>%
#  left_join(povprecja, by="obcina")
#row.names(podatki) <- podatki$obcina
#podatki$obcina <- NULL

# Število skupin
#n <- 5
#skupine <- hclust(dist(scale(podatki))) %>% cutree(n)


#napoved za naprej letalski promet v odvisnosti od železniškega (uvoz, blago)
lbuvoz <- letalski_blagovni_promet %>% filter( tovor == 'uvoz') %>% rename(letalski = tone)
zbuvoz <- zelezniski_blagovni_promet %>% filter( tovor == 'uvoz') %>% rename(zelezniski = tone)
e <- inner_join(lbuvoz, zbuvoz)[, -c(2)]

g <- ggplot(e, aes(x=letalski, y= zelezniski))+ xlim(500, 1100) + geom_point() + 
  geom_smooth(method="loess", se= FALSE,
              fullrange= TRUE, color = 'red') +
  geom_smooth(method = 'lm', formula = y ~ x +I(x^2),
               se = FALSE, fullrange=TRUE, color= 'green')+
  ggtitle('Uvoz blaga letalskega prometa v odvisnosti od železniškega')




#napoved za naprej letalski promet v odvisnosti od zeležniškega (uvoz, ljudi)
lpuvoz <- letalski_potniski_promet %>% filter( tovor == 'uvoz') %>% rename(letalski = potniki)
zpuvoz <- zelezniski_potniski_promet %>% filter( tovor == 'uvoz') %>% rename(zelezniski = potniki)
e2 <- inner_join(lpuvoz, zpuvoz)[, -c(2)]

g2 <- ggplot(e2, aes(x=letalski, y= zelezniski))+ xlim(3000, 9000) + geom_point() + 
  geom_smooth(method="loess", se= FALSE,
              fullrange= TRUE, color = 'red') +
  geom_smooth(method = 'lm', formula = y ~ x +I(x^2),
              se = FALSE, fullrange=TRUE, color= 'blue')+
  ggtitle('Uvoz potnikov letalskega prometa v odvisnosti od železniškega')




#napoved kako se bo spreminjal cestni blagovni promet uvoz

cuvoz <- cestni_blagovni_promet %>%  filter(tovor == 'uvoz') %>% rename(cestni = tone)
prilagajanje <- lm(data = cuvoz, cestni~I(leto^2) +leto + 0)
gg <- data.frame(leto = seq(2010, 2020, 1))
napoved <- mutate(gg, cestni=predict(prilagajanje, gg))


graf_regresije_uvoz <- ggplot(cuvoz, aes(x=leto, y=cestni))+
  geom_point() + geom_smooth(method = lm, formula =y~ x + I(x^2), fullrange = TRUE, color = 'blue')+
  geom_point(data = napoved, aes(x= leto, y=cestni), color='red', size = 2) +
  ggtitle('Napoved rasti uvoza cestnega blagovnega prometa v Sloveniji')+
  ylab('cestni promet v tonah (1000)')





#napoved kako se spreminja cestni blagovni promet izvoz

cizvoz <- cestni_blagovni_promet %>%  filter(tovor == 'izvoz') %>% rename(cestni = tone)
prilagajanje2 <- lm(data = cizvoz, cestni~I(leto^2) +leto + 0)
gg2 <- data.frame(leto = seq(2010, 2020, 1))
napoved2 <- mutate(gg2, cestni=predict(prilagajanje2, gg2))


graf_regresije_izvoz <- ggplot(cizvoz, aes(x=leto, y=cestni))+
  geom_point() + geom_smooth(method = lm, formula =y~ x + I(x^2), fullrange = TRUE, color = 'green')+
  geom_point(data = napoved2, aes(x= leto, y=cestni), color='red', size = 2) +
  ggtitle('Napoved rasti izvoza cestnega blagovnega prometa v Sloveniji')+
  ylab('cestni promet v tonah (1000)')




