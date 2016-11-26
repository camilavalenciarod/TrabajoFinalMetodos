cd "C:\Users\camila.valencia\Desktop\Efectos Pares"

import excel "C:\Users\camila.valencia\Desktop\Efectos Pares\red_academica.xlsx", sheet("redes") firstrow

** Tabla descriptiva
tabstat rend_i saber_i Genero Estrato edad2016 programa pilopaga, s(mean, sd)



**OLS

reg rend_i rend_red_i if promedio_compañeros > 0
outreg2 using minimos.doc

reg rend_i rend_red_i saber_i if promedio_compañeros > 0
outreg2 using minimos.doc, append

reg rend_i rend_red_i saber_i Genero Estrato if promedio_compañeros > 0
outreg2 using minimos.doc, append

reg rend_i rend_red_i saber_i Genero Estrato edad2016 programa pilopaga if promedio_compañeros > 0
outreg2 using minimos.doc, append 

** Primera etapa unicamente el instrumento
ivregress2 2sls rend_i ( rend_red_i= saber_red_i) if promedio_compañeros > 0, first
est restore first
outreg2 using primeraetapa.doc, cttop(first) 

** Segunda Etapa unicamente el instrumento
ivreg2 rend_i ( rend_red_i= saber_red_i) if promedio_compañeros > 0, first
outreg2 using segundaetapa.doc

** Primera etapa teniendo en cuenta el saber de cada individuo
ivregress2 2sls rend_i ( rend_red_i= saber_red_i) saber_i if promedio_compañeros > 0, first
est restore first
outreg2 using primeraetapa1.doc, cttop(first) 

** Segunda etapa teniendo en cuenta el saber de cada individuo
ivreg2 rend_i ( rend_red_i= saber_red_i) saber_i if promedio_compañeros > 0, first
outreg2 using segundaetapa.doc, append

** Primera etapa teniendo en cuenta el saber de cada individuo y con variables de control
ivregress2 2sls rend_i ( rend_red_i= saber_red_i) saber_i Genero Estrato if promedio_compañeros > 0, first
est restore first
outreg2 using primeraetapa2.doc, cttop(first)
 
** Segunda etapa teniendo en cuenta el saber de cada individuo y con variables de control
ivreg2 rend_i ( rend_red_i= saber_red_i) saber_i Genero Estrato if promedio_compañeros > 0, first
outreg2 using segundaetapa.doc, append

** Primera etapa teniendo en cuenta el saber de cada individuo y con variables de control
ivregress2 2sls rend_i ( rend_red_i= saber_red_i) saber_i Genero Estrato edad2016 programa pilopaga if promedio_compañeros > 0, first
est restore first
outreg2 using primeraetapa3.doc, cttop(first) 

** Segunda etapa teniendo en cuenta el saber de cada individuo y con variables de control
ivreg2 rend_i ( rend_red_i= saber_red_i) saber_i Genero Estrato edad2016 programa pilopaga if promedio_compañeros > 0, first
outreg2 using segundaetapa.doc, append
