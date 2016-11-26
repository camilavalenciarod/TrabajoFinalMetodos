
# Efecto de grupo par sobre el rendimiento académico de los estudiantes de primer semestre de la Facultad de Economía en la Universidad del Rosario

[Camila Valencia](https://github.com/camilavalenciarod/Resume/blob/master/HojadeVida%20Nov%202016.pdf) 

25-Nov-2016



---

## Descripción y Motivación

En el último año he estado coordinando un programa que tiene la facultad de economía. Este programa trata de disminuir la tasa de deserción de las dos carreras, para esto implementamos una serie de actividades que mejoren y complemente la experiencia de estar en la universidad con el fin de aumentar el nivel académico de nuestra facultad.Por esto quiero analizar el efecto de grupo par sobre el rendimiento académico de los estudiantes.

Algunas preguntas que pretendo responder con  este trabajo:

- Qué tan interconectados estan los estudiantes de la universidad del Rosario? 
- De que atributos depende de esa interconección?
- Qué clase de polarizacion hay en la red de estudiantes universitarios?
- Qué efecto tiene la red de amigos sobre el rendimiento académico?


## Metodos usados

Los datos con los que cuento son algunas caracteristicas socioecónomicas provenientes de las encuestas de admision de la universidad del Rosario y todos los datos que se le preguntan a los estudiantes en la prueba Saber 11. Ademas para analizar los rendimientos academicos, tengo el promedio ponderado y las notas de todas las materias que vieron el primer semestre del 2016. Una encuesta que se llevo a cabo a finales del semestre en donde se preguntaba cuales eran los estudiantes con los que estudiaba una vez por semana por fuera de los horarios de clase, cuales eran los estudiantes con los hacia ejercicio, cuales con los que salia a actividades sociales (cine, teatro, fiesta, bares), cuales eran los estudiantes mas cercanos a los que les pediria un consejo personal, cuales eran los estudiantes a los que conocia antes de entrar a la universidad y cuales son los que considera lideres.

Todos los datos estan codificados por el numero del individuo, los datos de la encuesta de redes estaban forma string con el codigo de todos los estudiantes pertenecientes a la red del individuo

1. Excel
    - Ordenar y limpiar la base de datos
    - Convertir esa unica celda con la informacion de la red en varias columnas y despues de eso hacer la matriz adyaciente de unos que me deja modelar la red con los comandos de igraph en R
    - Despues de esto hice multiplique las filas de la matriz por los vectores que me interesaban tener como el promedio de la red, como       lo es el desempeño promedio de la red de cada estudiante y como lo es los resultados del Saber 11 promedio de la red de cada       estudiante
    
    
2. Redes en R
    - Al tener la matriz adyaciente de las reds, mediante una serie de comandos en R. Modele las graficas con direcciones, las redes con atributos como lo son genero, estrato, programa, desempeño academico, ser beneficiario de ser pilo paga
    - Ademas de las graficas, obtuve una serie de variables descriptivas de la red de estudio 
    - Puede ver el [Codigo en R](https://github.com/camilavalenciarod/TrabajoFinalMetodos/blob/master/CodigoFinalRedes.R)
   
    
3. Analisis en Stata
    - Con la base generada en excel pude correr la regresion de minimos cuadrados ordinarios la cual tiene un problema de endogeneidad por el problema de reflexion descrito por Manski (1993). 
    - Luego muestro la regresion de minimos cuadrados ordinarios en dos etapas, para resolver el probema de endogeneidad por medio de           variables instrumentales.
    - Puede ver el [Codigo en Stata] (https://github.com/camilavalenciarod/TrabajoFinalMetodos/blob/master/IV%20Completo.do)
 

## Resultados

1. Resultados de las Redes
    - La red es tiene una alta conectividad
    - La red esta polarizada por el programa que estudian y por ser parte de ser pilo paga
    - Hay muy pocos estudiantes que se conocian antes de la universidad
    - Los estudiantes parece que hacen ejercicio con personas de mismo sexo

2. Resultados del analisis econometrico
    - Los resultados de OLS dan significativos y grandes pero estos estimadores son inconsistente y sesgados debido a la endogeneidad
    - El instrumento parece tener problemas de relevancia, lo cual se puede deber a que el tamaño de muestra es reducido, por lo tanto sera necesario hacer un test de relevancia independiente al tamaño de muestra
    - Los efectos en la segunda etapa son grandes y relevantes a un 10%, por lo que se puede inferir que si hay efecto del grupo par sobre el rendimiento de los estudiantes. El coeficiente estimado es significativo a un nivel de significancia del 90%, por un punto más en el resultado del Saber 11 del promedio del promedio de los compañeros del colegio de los integrantes de la red del individuo i, el promedio ponderado de la universidad de i aumenta en 0.87 unidades
    
Dirirgirse al trabajo completo con mas detalles como revision de literatura, datos, metodologia y resultados [Final] (https://github.com/camilavalenciarod/TrabajoFinalMetodos/blob/master/Trabajo%20Final%20Camila%20Valencia.pdf)

