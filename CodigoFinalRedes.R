install.packages('igraph')
install.packages('network') 
install.packages('sna')
install.packages('ndtv')
install.packages('visNetwork')

library(igraph)
library(network)
library(sna)
library(ndtv)
library(visNetwork)


###Abrir las matrices de las diferentes redes

base_1 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red1.csv", sep=";")
base_2 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red2.csv", sep=";")
base_3 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red3.csv", sep=";")
base_4 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red4.csv", sep=";")
base_5 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red5.csv", sep=";")
base_6 <- read.csv("C:/Users/camila.valencia/Desktop/Efectos Pares/red6.csv", sep=";")
Atributos2 <- read.csv ("C:/Users/camila.valencia/Desktop/Efectos Pares/Atributos2.csv", sep=";")


#La red como una matriz
network_1 <- as.matrix(base_1)
#Crea el grafico de la matriz con el cual se pueden hacer todo tipo de analisis
g_1 <- graph.adjacency(network_1)
#Betweenness es la frecuencia que un nodo actúa como puente en el camino mas corto entre otros dos nodos
(b_1 <- betweenness(g_1, directed = FALSE))
#closeness es el promedio de las distancias mas cortas desde uno nodo hacia los demás (menor es mas cercano al centro de la red)
(c_1 <- closeness(g_1, mode = "out"))
#degree es Numero de enlaces que posee un nodo con los demás
(d_1 <- degree(g_1, mode = "out"))
#Hace un objeto en formato red para que 
red_1 <-as.network.matrix(network_1)
#grafica la red 
plot.network(red_1)
title(main = "Red de estudio fuera de clase (min 1 x semana)")


## Adjuntar la matriz de la primera base

m=as.matrix(base_1)
net=graph.adjacency(m,mode="undirected",weighted=NULL,diag=FALSE)


########descripcion de la red



##DENSIDAD

edge_density (net, loops=F)

## la densidad es 0.06314732

## RECIPROCIDAD

reciprocity(net)
# la reprocidad es igual a 1

dyad_census(net) 
##mutual 1006
## asym 0
##null 14925

2*dyad_census(net)$mut/ecount(net)
#la reprocidad es 2

####### TRANSITIVIDAD
##Global= radio de triangulos que estan conectados a tripletas
##Local = igual que global pero conectado a los vetices

transitivity(net, type="global")
# [1] 0.3772564

transitivity(net, type="local") #arroja la transitividad de cada vertice


#######DIAMETRO
# El diametro de la red es la mas larga distancia(tamaño del camino mas corto que coneta dos nodos)

diameter(net, directed=F, weights=NA)
## [1] 5

diameter(net, directed = F)
## [1] 5


diam <- get_diameter(net, directed=T)
diam
##+ 6/179 vertices, named:
##  [1] X2   X3   X110 X90  X97  X119
class(diam)
as.vector(diam)
## [1]   2   3 110  90  97 119


### GRADO DE LOS NODOS
deg <- degree(net, mode="all")
#Hace la grafica cambiando el tamaño de los vertices
plot(net, vertex.label=NA, vertex.size=deg*1)

hist(deg, breaks=1:vcount(net)-1, main="Histograma del grado de los nodos")

##DISTRIBUCION DE LOS GRADOS

deg.dist <- degree_distribution(net, cumulative=T, mode="all")
plot( x=0:max(deg), y=1-deg.dist, pch=19, cex=1.2, col="orange",
      xlab="Grado", ylab="Frecuencia Acumulada", main="Distribución de los grados")


##Grado (numero de conexiones)

degree(net, mode="in")
centr_degree(net, mode="in", normalized=T)
##$centralization
#[1] 0.1896617

#$theoretical_max
#[1] 31862

##Cercania (centralidad basada en la distancia con otros nodos)


closeness(net, mode="all", weights=NA)
centr_clo(net, mode="all", normalized=T)
##$centralization
#[1] 0.08858979

#$theoretical_max
#[1] 88.7493


##Betweenness (centralidad basada en la conectividad con los demas)
#Numero de veces que por el nodo para conectar con los demas
betweenness(net, directed=T, weights=NA)
edge_betweenness(net, directed=T, weights=NA)
centr_betw(net, directed=T, normalized=T)

#$centralization
#[1] 0.1594054

#$theoretical_max
#[1] 2804034

##########DISTANCIAS Y CAMINOS
##la longitud promedio del camino, la media de la mascorta distancia entre nodos

mean_distance(net, directed=F)
## [1] 2.666025
mean_distance(net, directed=T)
## [1] 2.666025
##la distancia de las caminos mas cortos
distances(net) # con los pesos de los nodos
distances(net, weights=NA) # sin los pesos


#### Grupos

net.sym <- as.undirected(net, mode= "collapse",
                         edge.attr.comb=list(weight="sum", "ignore"))
# encuentra los subgrupos de la red
cliques(net.sym) # lista de subgrupos
sapply(cliques(net.sym), length) # tamaño de los subgrupos
largest_cliques(net.sym) # grupos con la mayor cantidad de nodos
vcol <- rep("grey80", vcount(net.sym))
vcol[unlist(largest_cliques(net.sym))] <- "gold"
plot(as.undirected(net.sym), vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)


#####Deteccion de Comunidades


ceb <- cluster_edge_betweenness(net)
dendPlot(ceb, mode="hclust", xlab="", ann = FALSE)

###### Graficar la Red con sus atributos 

#Importar los atributos de los individuos

##Crea la red sin distinguir los atributos
V(net)$Sex=as.character(Atributos2$Genero[match(V(net)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net)$Sex # Este imprime el atributo
V(net)$color=V(net)$Sex #Asigna el atributo genero al color de los vertices
V(net)$color=gsub("0","red",V(net)$color) #Mujeres seran moradas
V(net)$color=gsub("1","red",V(net)$color) #Hombres seran verdes
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de estudio fuera de clase (min 1 x semana)")

## Crea la red distinguiendo el atributo de la distribucion del promedio academico
#Muestra el grado de los nodos
V(net)$promedio=as.character(Atributos2$nota3[match(V(net)$name,Atributos2$Ind)]) # This code says to create a vertex attribute called "Sex" by extracting the value of the column "Sex" in the attributes file when the Bird ID number matches the vertex name.
V(net)$promedio 
V(net)$color=V(net)$promedio 
V(net)$color=gsub("1","red",V(net)$color) 
V(net)$color=gsub("2","yellow",V(net)$color) 
V(net)$color=gsub("3","green",V(net)$color) 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
#Hace que el tamano del nodo cambie segun su grado
V(net)$size=degree(net)*0.5 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold)
title(main = "Red de estudio fuera de clase (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Bajo","Medio","Alto")
             , title="Desempeño académico", pt.bg = c("red", "yellow", "green")
             , pch = c(21,21,21))

## La misma red pero ahora cambia el color segun el genero
V(net)$Sex=as.character(Atributos2$Genero[match(V(net)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net)$Sex # Este imprime el atributo
V(net)$color=V(net)$Sex #Asigna el atributo genero al color de los vertices
V(net)$color=gsub("0","purple",V(net)$color) #Mujeres seran moradas
V(net)$color=gsub("1","lightgreen",V(net)$color) #Hombres seran verdes
V(net)$size=degree(net)*0.5 #Hace la grafica segun el grado de conectividad
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold)
title(main = "Red de estudio fuera de clase (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Mujeres","Hombres")
             , title="Genero", pt.bg = c("purple",  "lightgreen")
             , pch = 21)

##El atributo que se tiene en cuenta ahora es el Estrato socioeconomico
V(net)$estrato=as.character(Atributos2$Estrato[match(V(net)$name,Atributos2$Ind)]) # This code says to create a vertex attribute called "Sex" by extracting the value of the column "Sex" in the attributes file when the Bird ID number matches the vertex name.
V(net)$estrato 
V(net)$color=V(net)$estrato 
V(net)$color=gsub("1","darkblue",V(net)$color) 
V(net)$color=gsub("2","darkblue",V(net)$color) 
V(net)$color=gsub("3","blue1",V(net)$color) 
V(net)$color=gsub("4","blue1",V(net)$color) 
V(net)$color=gsub("5","lightblue",V(net)$color) 
V(net)$color=gsub("6","lightblue",V(net)$color) 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
#Hace que el tamano del nodo cambie segun su grado
V(net)$size=degree(net)*0.5 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold)
title(main = "Red de estudio fuera de clase (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("1 y 2","3 y 4","5 y 6")
             , title="Estratos Socioeconómicos", pt.bg = c("darkblue", "blue1", "lightblue")
             , pch = c(21,21,21))

#El atributo que se quiere ver a ahora es si es beneficiaro del program ser pilo paga
V(net)$pilo=as.character(Atributos2$pilopaga[match(V(net)$name,Atributos2$Ind)]) 
V(net)$color=V(net)$pilo 
V(net)$color=gsub("0","red",V(net)$color) 
V(net)$color=gsub("1","darkred",V(net)$color) 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
V(net)$size=degree(net)*0.5 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold)
title(main = "Red de estudio fuera de clase (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Si","No")
             , title="Beneficiario ser pilo paga", pt.bg = c("darkred",  "red")
             , pch = 21)

## Como es la red cuando se distingue por programa academico
V(net)$programa=as.character(Atributos2$programa[match(V(net)$name,Atributos2$Ind)]) 
V(net)$color=V(net)$programa 
V(net)$color=gsub("0","green",V(net)$color) #Programa de Finanzas
V(net)$color=gsub("1","blue",V(net)$color) #Programa de economia
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
V(net)$size=degree(net)*0.5 
plot.igraph(net,vertex.label=NA,layout=layout.fruchterman.reingold)
title(main = "Red de estudio fuera de clase (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Finanzas y Comercio Internacional","Economía")
             , title="Programa Academico", pt.bg = c("green",  "blue")
             , pch = 21)

###########Ahora repliacre lo mismo con la red de actividades sociales

network_2 <- as.matrix(base_2)
g_2 <- graph.adjacency(network_2)
(b_2 <- betweenness(g_2, directed = FALSE))
(c_2 <- closeness(g_2, mode = "out"))
(d_2 <- degree(g_2, mode = "out"))
red_2 <-as.network.matrix(network_2)
plot.network(red_2) 
title(main = "Red de planes sociales (min 1 x semana)")


m1=as.matrix(base_2)
net1=graph.adjacency(m1,mode="undirected",weighted=NULL,diag=FALSE)


#Importar los atributos de los individuos

##Crea la red sin distinguir los atributos
V(net1)$Sex=as.character(Atributos2$Genero[match(V(net1)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net1)$Sex # Este imprime el atributo
V(net1)$color=V(net1)$Sex #Asigna el atributo genero al color de los vertices
V(net1)$color=gsub("0","red",V(net1)$color) #Mujeres seran moradas
V(net1)$color=gsub("1","red",V(net1)$color) #Hombres seran verdes
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades sociales (min 1 x semana)")



V(net1)$promedio=as.character(Atributos2$nota3[match(V(net1)$name,Atributos2$Ind)]) # This code says to create a vertex attribute called "Sex" by extracting the value of the column "Sex" in the attributes file when the Bird ID number matches the vertex name.
V(net1)$promedio 
V(net1)$color=V(net1)$promedio 
V(net1)$color=gsub("1","red",V(net1)$color) 
V(net1)$color=gsub("2","yellow",V(net1)$color) 
V(net1)$color=gsub("3","green",V(net1)$color) 
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades sociales (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Bajo","Medio","Alto")
             , title="Desempeño académico", pt.bg = c("red", "yellow", "green")
             , pch = c(21,21,21))

V(net1)$Sex1=as.character(Atributos2$Genero[match(V(net1)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net1)$Sex1 # Este imprime el atributo
V(net1)$color=V(net1)$Sex1 #Asigna el atributo genero al color de los vertices
V(net1)$color=gsub("0","purple",V(net1)$color) #Mujeres seran moradas
V(net1)$color=gsub("1","lightgreen",V(net1)$color) #Hombres seran verdes
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
V(net1)$size=degree(net1)* 0.5 #Hace la grafica segun el grado de conectividad
title(main = "Red de actividades sociales (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Mujeres","Hombres")
             , title="Genero", pt.bg = c("purple",  "lightgreen")
             , pch = 21)


V(net1)$estrato=as.character(Atributos2$Estrato[match(V(net1)$name,Atributos2$Ind)]) 
V(net1)$estrato 
V(net1)$color=V(net1)$estrato 
V(net1)$color=gsub("1","darkblue",V(net1)$color) 
V(net1)$color=gsub("2","darkblue",V(net1)$color) 
V(net1)$color=gsub("3","blue1",V(net1)$color) 
V(net1)$color=gsub("4","blue1",V(net1)$color) 
V(net1)$color=gsub("5","lightblue",V(net1)$color) 
V(net1)$color=gsub("6","lightblue",V(net1)$color) 
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades sociales (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("1 y 2","3 y 4","5 y 6")
             , title="Estratos Socioeconómicos", pt.bg = c("darkblue", "blue1", "lightblue")
             , pch = c(21,21,21))

V(net1)$pilo=as.character(Atributos2$pilopaga[match(V(net1)$name,Atributos2$Ind)]) 
V(net1)$color=V(net1)$pilo 
V(net1)$color=gsub("0","red",V(net1)$color) 
V(net1)$color=gsub("1","darkred",V(net1)$color) 
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades sociales (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Si","No")
             , title="Beneficiario ser pilo paga", pt.bg = c("darkred",  "red")
             , pch = 21)

V(net1)$programa=as.character(Atributos2$programa[match(V(net1)$name,Atributos2$Ind)]) 
V(net1)$color=V(net1)$programa 
V(net1)$color=gsub("0","green",V(net1)$color) #Programa de Finanzas
V(net1)$color=gsub("1","blue",V(net1)$color) #Programa de economia
plot.igraph(net1,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)

title(main = "Red de actividades sociales (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Finanzas y Comercio Internacional","Economía")
             , title="Programa Academico", pt.bg = c("green",  "blue")
             , pch = 21)



##############Ahora trabajare con la red de actividades deportivas


network_3 <- as.matrix(base_3)
g_3 <- graph.adjacency(network_3)
(b_3 <- betweenness(g_3, directed = FALSE))
(c_3 <- closeness(g_3, mode = "out"))
(d_3 <- degree(g_3, mode = "out"))
red_3 <-as.network.matrix(network_3)
plot.network(red_3)
title(main = "Red de actividades deportivas")


m2=as.matrix(base_3)
net2=graph.adjacency(m2,mode="undirected",weighted=NULL,diag=FALSE)

#Importar los atributos de los individuos

##Crea la red sin distinguir los atributos
V(net2)$Sex=as.character(Atributos2$Genero[match(V(net2)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net2)$Sex # Este imprime el atributo
V(net2)$color=V(net2)$Sex #Asigna el atributo genero al color de los vertices
V(net2)$color=gsub("0","red",V(net2)$color) #Mujeres seran moradas
V(net2)$color=gsub("1","red",V(net2)$color) #Hombres seran verdes
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades deportivas (min 1 x semana)")

V(net2)$promedio=as.character(Atributos2$nota3[match(V(net2)$name,Atributos2$Ind)]) # This code says to create a vertex attribute called "Sex" by extracting the value of the column "Sex" in the attributes file when the Bird ID number matches the vertex name.
V(net2)$promedio 
V(net2)$color=V(net2)$promedio 
V(net2)$color=gsub("1","red",V(net2)$color) 
V(net2)$color=gsub("2","yellow",V(net2)$color) 
V(net2)$color=gsub("3","green",V(net2)$color) 
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades deportivas (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Bajo","Medio","Alto")
             , title="Desempeño académico", pt.bg = c("red", "yellow", "green")
             , pch = c(21,21,21))

V(net2)$Sex=as.character(Atributos2$Genero[match(V(net2)$name,Atributos2$Ind)]) 
#Crea el atributo genero haciendo match en las dos bases por el Ind
V(net2)$Sex # Este imprime el atributo
V(net2)$color=V(net2)$Sex #Asigna el atributo genero al color de los vertices
V(net2)$color=gsub("0","purple",V(net2)$color) #Mujeres seran moradas
V(net2)$color=gsub("1","lightgreen",V(net2)$color) #Hombres seran verdes
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades deportivas (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Mujeres","Hombres")
             , title="Genero", pt.bg = c("purple",  "lightgreen")
             , pch = 21)


V(net2)$estrato=as.character(Atributos2$Estrato[match(V(net2)$name,Atributos2$Ind)]) 
V(net2)$estrato 
V(net2)$color=V(net2)$estrato 
V(net2)$color=gsub("1","darkblue",V(net2)$color) 
V(net2)$color=gsub("2","darkblue",V(net2)$color) 
V(net2)$color=gsub("3","blue1",V(net2)$color) 
V(net2)$color=gsub("4","blue1",V(net2)$color) 
V(net2)$color=gsub("5","lightblue",V(net2)$color) 
V(net2)$color=gsub("6","lightblue",V(net2)$color) 
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades deportivas (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("1 y 2","3 y 4","5 y 6")
             , title="Estratos Socioeconómicos", pt.bg = c("darkblue", "blue1", "lightblue")
             , pch = c(21,21,21))

V(net2)$pilo=as.character(Atributos2$pilopaga[match(V(net2)$name,Atributos2$Ind)]) 
V(net2)$color=V(net2)$pilo 
V(net2)$color=gsub("0","red",V(net2)$color) 
V(net2)$color=gsub("1","darkred",V(net2)$color) 
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)
title(main = "Red de actividades deportivas (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Si","No")
             , title="Beneficiario ser pilo paga", pt.bg = c("darkred",  "red")
             , pch = 21)

V(net2)$programa=as.character(Atributos2$programa[match(V(net2)$name,Atributos2$Ind)]) 
V(net2)$color=V(net2)$programa 
V(net2)$color=gsub("0","green",V(net2)$color) #Programa de Finanzas
V(net2)$color=gsub("1","blue",V(net2)$color) #Programa de economia
plot.igraph(net2,vertex.label=NA,layout=layout.fruchterman.reingold, vertex.size=3)

title(main = "Red de actividades deportivas (min 1 x semana)")
l <- legend( "bottomright", inset = .02, cex = 1, bty = "n", legend = c("Finanzas y Comercio Internacional","Economía")
             , title="Programa Academico", pt.bg = c("green",  "blue")
             , pch = 21)



########Descripcion de las otras redes


####Red de los compañeros a los cuales les pediria un consejo personal
network_4 <- as.matrix(base_4)
g_4 <- graph.adjacency(network_4)
(b_4 <- betweenness(g_4, directed = FALSE))
(c_4 <- closeness(g_4, mode = "out"))
(d_4 <- degree(g_4, mode = "out"))
red_4 <-as.network.matrix(network_4)
plot.network(red_4) 
title(main = "Red de consejos personales")

#### Red de los estudiantes conocidos antes de entrar a la universidad
network_5 <- as.matrix(base_5)
g_5 <- graph.adjacency(network_5)
(b_5 <- betweenness(g_5, directed = FALSE))
(c_5 <- closeness(g_5, mode = "out"))
(d_5 <- degree(g_5, mode = "out"))
red_5 <-as.network.matrix(network_5)
plot.network(red_5) 
title(main = "Conocidos antes de entrar a la UR")

#######Es una red con direccion por que son las personas que considera lideres en la cohorte
network_6 <- as.matrix(base_6)
g_6 <- graph.adjacency(network_6)
(b_6 <- betweenness(g_6, directed = FALSE))
(c_6 <- closeness(g_6, mode = "out"))
(d_6 <- degree(g_6, mode = "out"))
red_6 <-as.network.matrix(network_6)
plot.network(red_6, col="purple") 
col("purple")
title(main = "Estudiantes considerados lideres")


