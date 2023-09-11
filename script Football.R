library(readr)
df<- read.csv("C:/Users/ryanm/Downloads/Laurent soulat table - Tableaux final.csv", sep=",")
View(df)
summary(df)
##library(readxl)
##Laurent_Soulat_table_Tableaux_final <- read_excel("C:/Users/ryanm/Downloads/Laurent soulat table - Tableaux final.csv")
##View(Laurent_soulat_table_Tableaux_final)



attach(df)


##Découpage des saisons##
df2122 <- subset(df, df$annee == "2021-2022")
df2021 <- subset(df, df$annee == "2020-2021")
df1920 <- subset(df, df$annee == "2019-2020")
df1819 <- subset(df, df$annee == "2018-2019")




##Graph sur l'affluence en fonction du nombre de points
reg1 <- lm(point ~ moy_affluence , data = df1819)
plot(point ~ moy_affluence , xlab="Affluence moyenne",ylab="Points", data=df1819)
abline(reg1, col = "red", lwd = 2)

reg2 <- lm(point ~ moy_affluence , data = df1920)
plot(point ~ moy_affluence , xlab="Affluence moyenne",ylab="Points", data=df1920)
abline(reg2, col = "red", lwd = 2)

reg3 <- lm(moy_affluence ~ point , data = df2021)
plot(point ~ moy_affluence , xlab="Affluence moyenne",ylab="Points", data=df2021)
abline(reg3, col = "red", lwd = 2)

#reg3 <- lm(point ~ moy_affluence , data = df2021)
#plot(moy_affluence ~ point , xlab="Affluence moyenne",ylab="Points", data=df2021)
plot(moy_affluence ~ point , xlab="Affluence moyenne",ylab="Points", data=df2021)
#abline(reg3, col = "red", lwd = 2)


reg4 <- lm(moy_affluence ~ point , data = df2122)
plot(point ~ moy_affluence , xlab="Affluence moyenne",ylab="Points", data=df2122)
plot(moy_affluence ~ point , xlab="Affluence moyenne",ylab="Points", data=df2122)
abline(reg4, col = "red", lwd = 2)



ggplot(data=df2122, aes(x=moy_affluence, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + ggtitle("Classement 21/22 en fonction de l'affluence moyenne") +
  theme_minimal() +
  scale_fill_grey()


ggplot(data=df2021, aes(x=moy_affluence, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + ggtitle("Classement 20/21 en fonction de l'affluence moyenne") + 
  theme_minimal() +
  scale_fill_grey()


ggplot(data=df1920, aes(x=moy_affluence, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + ggtitle("Classement 19/20 en fonction de l'affluence moyenne") +
  theme_minimal() +
  scale_fill_grey()


ggplot(data=df1819, aes(x=moy_affluence, y=reorder(club, - classement),  fill = as.numeric(as.ordered(classement)))) +
  geom_bar(stat="identity") + ggtitle("Classement 18/19 en fonction de l'affluence moyenne") +
  theme_minimal() +
  scale_fill_gradient(low="#000080", high="#ADD8E6")





##Graph sur le nombre de championnats gagnés en fonction du nombre de points
df2122$point <- as.numeric(df2122$point)
class(df2122$championnats)
df2122$championnats <- as.numeric(df2122$championnats)



ggplot(data=df2122, aes(y=championnats, x=reorder(classement, - point),  fill = as.ordered( - championnats))) +
  geom_bar(stat="identity") + ggtitle("Classement 21/22 en fonction du nombre de championnats gagnés") + 
  scale_fill_grey()

ggplot(data=df2021, aes(y=championnats, x=reorder(classement, - point),  fill = as.ordered( - championnats))) +
  geom_bar(stat="identity") + ggtitle("Classement 20/21 en fonction du nombre de championnats gagnés") + 
  scale_fill_grey()

ggplot(data=df1920, aes(y=championnats, x=reorder(classement, - point),  fill = as.ordered( - championnats))) +
  geom_bar(stat="identity") + ggtitle("Classement 19/20 en fonction du nombre de championnats gagnés") + 
  scale_fill_grey()

ggplot(data=df1819, aes(y=championnats, x=reorder(classement, - point),  fill = as.ordered( - championnats))) +
  geom_bar(stat="identity") + ggtitle("Classement 18/19 en fonction du nombre de championnats gagnés") +
  scale_fill_grey()



ggplot(data=df1819, aes(y=championnats, x=reorder(classement, - point),  fill = as.ordered( - championnats))) +
  geom_bar(stat="identity") + ggtitle("Classement 18/19 en fonction du nombre de championnats gagnés") +
  scale_fill_grey()


barplot(championnats ~ point, data = df2122,
     main= "Graph sur le nombre de championnats gagnés en fonction du nombre de points",
     xlab= "Points",
     ylab= "Championnats gagnés",
     col= "blue", pch = 19, lty = "solid", lwd = 2)
text(labels=club, cex= 0.8)



p<-ggplot(data=df2122, aes(x=point, y=championnats)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()
p





##Graph sur la valeur marché
df2122$total_valeur_marche <- as.numeric(df2122$total_valeur_marche)

ggplot(data=df2122, aes(x=moy_valeur_marche, y=reorder(club, - classement), fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey()

class(df2122$classement)

ggplot(data=df2122, aes(x=total_valeur_marche, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey()




####  Valeur moyenne ### 

# 2021-2022
ggplot(data=df2122, aes(x=moy_valeur_marche, y=reorder(club, - classement), fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_colour_gradient2() + ggtitle("Valeur moyenne 2021-2022")

# 2020-2021
ggplot(data=df2021, aes(x=moy_valeur_marche, y=reorder(club, - classement), fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_colour_gradient2() + ggtitle("Valeur moyenne 2020-2021")

# 2019-2020
ggplot(data=df1920, aes(x=moy_valeur_marche, y=reorder(club, - classement), fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_colour_gradient2() + ggtitle("Valeur moyenne 2019-2020")

# 2018-2019
ggplot(data=df1819, aes(x=moy_valeur_marche, y=reorder(club, - classement), fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_colour_gradient2() + ggtitle("Valeur moyenne 2018-2019")




####Valeur totale

ggplot(data=df2122, aes(x=total_valeur_marche, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey() + ggtitle("Valeur totale 2021-2022")

ggplot(data=df2021, aes(x=total_valeur_marche, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey()+ ggtitle("Valeur totale 2020-2021")

ggplot(data=df1920, aes(x=total_valeur_marche, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey()+ ggtitle("Valeur totale 2019-2020")

ggplot(data=df1819, aes(x=total_valeur_marche, y=reorder(club, - classement),  fill = as.ordered(classement))) +
  geom_bar(stat="identity") + 
  theme_minimal() +
  scale_fill_grey()+ ggtitle("Valeur totale 2018-2019")


ggplot(data=df1920, aes(x=moy_affluence, y=reorder(club, - classement),  fill = as.numeric(as.ordered(classement)))) +
  geom_bar(stat="identity") + 
  ggtitle("Classement 18/19 en fonction de l'affluence moyenne") +
  theme_minimal() +
  scale_fill_gradient(low="#000080", high="#ADD8E6")




###Effectif par classsement d'équipe

ggplot(data=df, aes(fill=effectif, y=effectif, x=classement)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_gradient(low="lightblue", high="darkblue") +
  ggtitle("Effectif par classement d'équipe") +
  facet_wrap(~annee) +
  theme(legend.position="none") +
  xlab("Classement") +
  ylab("Effectif")




####Moyenne d'age

ggplot(df, aes(fill=moy_age, y=moy_age, x=classement)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_gradient(low="cyan", high="darkblue") +
  ggtitle("Moyenne d'age par classement d'équipe") +
  facet_wrap(~annee) +
  theme(legend.position="none") +
  xlab("Classement") +
  ylab("Moyenne d'age")




#####Nombre d'étranger

ggplot(df, aes(fill=nbr_etrangers, y=nbr_etrangers, x=classement)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_gradient(low="cadetblue1", high="darkblue") +
  ggtitle("Nombre d'étrangers par classement d'équipe") +
  facet_wrap(~annee) +
  theme(legend.position="none") +
  xlab("Classement") +
  ylab("Nombre d'étrangers")






###MATRICE DES CORRELATIONS###
df2$classement <- 21 - df2$classement

library(dplyr)
df2_num <- select_if(df2, is.numeric) # Sélectionne les colonnes numériques
correlation <- cor(df2_num) # Calcule la matrice de corrélation des colonnes numériques

#Créer une matrice de corrélation
correlation <- cor(df2_num, use="complete.obs", method="pearson")

#Afficher la matrice de corrélation
print(correlation)

#Visualisation de la matrice de corrélation
library(corrplot)
corrplot(correlation, method = "color", type = "upper", order = "hclust", tl.col="black", tl.srt=45)





##AFDM##
df2$classement <- 21 - df2$classement 

res.FAMD<-FAMD(df2,graph=FALSE)
plot.FAMD(res.FAMD,title="Graphe des individus et des modalités")
plot.FAMD(res.FAMD,axes=c(1,2),choix='var',title="Graphe des variables")
plot.FAMD(res.FAMD, choix='quanti',title="Cercle des corrélations")


get_eigenvalue(res)

# Contribution des variables sur les deux premiers axes
contrib_var <- get_famd_var(res.FAMD)$contrib[,1:2]
contrib_var




###Régression Linéaire###

anova(reg1, test="Chisq")


fit <- lm(point ~ annee  + effectif + moy_age + nbr_etrangers + 
            moy_valeur_marche + total_valeur_marche + moy_affluence + diff_but + 
            championnats + meilleur_buteur, data = df)
fit
summary(fit)

#Step
step(fit)

##Meilleur modèle après Step
fit <- lm(formula = point ~ effectif + moy_valeur_marche + total_valeur_marche + 
            diff_but + championnats, data = df)

# Analyse de variance (ANOVA) pour vérifier l'importance de chaque variable dans le modèle de régression
anova(fit)

# Test de normalité pour vérifier si les résidus suivent une distribution normale
shapiro.test(residuals(fit))


#Graphique résiduel
plot(fit$residuals, main="Résidus du modèle", ylab="Résidus", xlab="Observation Number")
abline(h=0, col="red")



###Prédictions###


#Ajout de l'année 2023
df_2023 <- data.frame(
  club = c("Manchester City", "Chelsea FC", "Arsenal FC", "FC Liverpool", "Manchester United", 
                "Tottenham Hotspur", "Newcastle United", "West Ham United", "Leicester City", 
                "Aston Villa", "Wolverhampton Wanderers", "FC Southampton", "Brighton & Hove Albion", 
                "FC Everton", "Nottingham Forest", "FC Brentford", "Leeds United", "Crystal Palace", 
                "FC Fulham", "AFC Bournemouth"),
  effectif = c(26.8, 25.4, 25.2, 26.7, 26.0, 26.7, 27.4, 28.2, 27.0, 27.2, 26.2, 25.5, 24.8, 27.4, 28.1, 25.6, 25.6, 27.0, 28.1, 26.5),
  moy_age = c(16, 21, 16, 21, 20, 17, 17, 16, 19, 16, 24, 21, 18, 11, 23, 19, 19, 15, 22, 16),
  nbr_etrangers = c(43.80, 31.73, 38.70, 29.30, 24.87, 27.21, 17.04, 20.52, 16.41, 19.00, 14.24, 13.23, 14.35, 14.12, 9.50, 12.72, 13.25, 12.40, 10.56, 9.03),
  moy_valeur_marche = c(1005, 1002, 890, 879, 795.7, 680.3, 494.3, 451.5, 443.1, 437, 398.7, 397, 358.7, 352.9, 332.65, 318.1, 318, 309.95, 253.5, 243.7),
  total_valeur_marche = c(53.236, 39.997, 60.200, 53.230, 73.868, 61.589, 52.126, 62.459, 31.850, 41.650, 31.487, 30.461, 31.475, 39.222, 29.170, 17.078, 36.525, 25.030, 23.646, 10.308)
)

# Affiche le dataframe
print(df_2023)


# Ajout des colonnes pour 'diff_but_2023' et 'meilleur_buteur_2023' à df_2023
df_2023$diff_but <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) # remplacez par les valeurs réelles
df_2023$meilleur_buteur <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) # remplacez par les valeurs réelles

df_2023$championnats <- c(8, 6, 13, 19, 20, 2, 4, 0, 1, 7, 3, 0, 0, 9, 0, 0, 3, 0, 0, 0)

# Prédictions pour 2023
predictions_2023 <- predict(fit, newdata = df_2023)

# ajout les prédictions à df_2023
df_2023$predictions_2023 <- predictions_2023

print(df_2023)

# Trouve l'équipe avec la prédiction la plus élevée
equipe_max_points <- df_2023$club_2023[which.max(df_2023$predictions_2023)]

# Affiche l'équipe
print(paste("L'équipe qui aura le plus de points en 2023 est :", equipe_max_points))

# Trie le DataFrame par les prédictions des points dans un ordre décroissant
df_2023_sorted <- df_2023[order(-df_2023$predictions_2023),]

# Crée une nouvelle colonne pour le classement
df_2023_sorted$classement_2023 <- 1:nrow(df_2023_sorted)

# Affiche le DataFrame
print(df_2023_sorted)


