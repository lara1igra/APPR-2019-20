# Analiza podatkov s programom R, 2019/20

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2019/20

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=shiny/APPR-2019-20/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=rstudio) RStudio

## Analiza transporta dobrin in ljudi v in iz Slovenije 

Izbrala sem si temo o transportu. Pri tem bom primerjala transport dobrin in ljudi v železniškem, cestnem, pristaniški in letalski promet.Kot prvo se bom osredotočila na uvoz. Želim ugotoviti s katerim prometom pridobimo največ dobrin oziroma kako ljudje najpogosteje prihajajo v našo državo. Potem bom analizirala izvoz dobrin in ljudi, enako kot prej po panogah  Zanimalo me bo spreminjanje transporta glede na časovno obdobje med 2010 in 2018 in s tem tudi kateri transport se je z leti okrepčal. Za konec bom primerjala uvoz in izvoz in s tem želim ugotoviti koliko je Slovenija skozi leta postala samooskrbna država. Transport z vlakom bom primerjala še z drugimi evropskimi državami od leta 2010 do 2018 in podatke prikazala z grafom. 

Podatke o transportu v in iz Sloveije za vse štiri promete imam v obliki CSV datotek. Za primerjavo s drugimi evropskimi državami pa imam podatke v HTML datoteki. 

TABELE: 

1.tabela- Letalski potniški in blagovni promet- čas, prihodni let, odhodni let, potniki, tone (gledali bomo vse države skupaj prav tako redne in posebne lete)
2.tabela - Pristaniški potniški promet - čas, prispeli potniki, odpotovani potniki
3.tabela - Pristaniški blagovni promet - čas, uvoz, izvoz, tone (skupaj gledamo vrsto blaga in vrsto tovora)
4.tabela - Cestni blagovni promet - čas, blago naloženo v Sloveniji, blago razloženo v Sloveniji, tone 
5.tabela - Cestni potniški promet - čas, medkrajevni linijski prevoz, blagovni linijski prevoz, potniki 
6.tabela - Želizniški blagovni promet - čas, blago naloženo v Sloveniji, blago razloženo v Sloveniji, tone 
7.tabela - Železniški potniški promet - čas, potniki vstopili v Slovenijo, potniki izstopili iz Slovenije, potniki  
8.tabela - Evropski železniški blagovni promet - čas, države, tisoč ton 
9.tabela - Evropski železniški potniški promet - čas, države, tisoč potnikov 

 

VIRI: 

SURS - https://pxweb.stat.si/pxweb/Database/Dem_soc/07_trg_dela/10_place/03_07113_strukt_statistika/03_07113_strukt_statistika.asp
EUROSTAT - https://appsso.eurostat.ec.europa.eu/nui/submitViewTableAction.do


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
