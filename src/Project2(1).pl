%% Project2-1.pl
%% Gramática DCG para analizador de frases en castellano
%% Versión con subordinadas relativas y árbol visual

% ==========================================================
% ORACIÓN
% ==========================================================

oracion(o(Suj, Pred, Punc)) -->
    sintagma_nominal(Num, _Gen, Suj),
    sintagma_verbal(Num, Pred),
    puntuacion(Punc).

puntuacion(punc('.')) --> ['.'].

% ==========================================================
% SINTAGMA NOMINAL
% ==========================================================

sintagma_nominal(Num, Gen, sn(Det, N)) -->
    sintagma_nominal_base(Num, Gen, Det, N),
    complementos_nominales(Num, Gen, []).

sintagma_nominal(Num, Gen, sn(Det, N, Complements)) -->
    sintagma_nominal_base(Num, Gen, Det, N),
    complementos_nominales(Num, Gen, Complements),
    { Complements \= [] }.

sintagma_nominal(sing, masc, sn(np(NP))) -->
    nombre_propio(sing, masc, NP).

sintagma_nominal(sing, fem, sn(np(NP))) -->
    nombre_propio(sing, fem, NP).

sintagma_nominal(Num, Gen, sn(pron(Pron))) -->
    pronombre(Num, Gen, Pron).

sintagma_nominal_base(Num, Gen, Det, N) -->
    articulo(Num, Gen, Det),
    nombre(Num, Gen, N).

complementos_nominales(Num, Gen, [Adj|Resto]) -->
    sintagma_adjetival(Num, Gen, Adj),
    complementos_nominales(Num, Gen, Resto).

complementos_nominales(Num, Gen, [SP|Resto]) -->
    sintagma_preposicional(SP),
    complementos_nominales(Num, Gen, Resto).

complementos_nominales(Num, Gen, [Sub|Resto]) -->
    subordinada_relativa(Num, Sub),
    complementos_nominales(Num, Gen, Resto).

complementos_nominales(_, _, []) --> [].

% ==========================================================
% SUBORDINADAS
% ==========================================================

subordinada_relativa(Num, sub_rel(Rel, Pred)) -->
    relativo(Rel),
    sintagma_verbal(Num, Pred).

relativo(rel(que)) --> [que].

% ==========================================================
% SINTAGMA VERBAL
% ==========================================================

sintagma_verbal(Num, sv(Neg, Nucleo, Comp)) -->
    negacion_opcional(Neg),
    nucleo_verbal(Num, Nucleo),
    complementos_verbales(Comp).

negacion_opcional(neg(no)) --> adverbio_negacion(neg(no)).
negacion_opcional(none) --> [].

nucleo_verbal(Num, v(intransitivo(V))) -->
    verbo_intransitivo(Num, V).

nucleo_verbal(Num, v(transitivo(V))) -->
    verbo_transitivo(Num, V).

nucleo_verbal(Num, v(copulativo(V))) -->
    verbo_copulativo(Num, V).

complementos_verbales([Obj|Resto]) -->
    sintagma_nominal(_, _, Obj),
    complementos_verbales(Resto).

complementos_verbales([Atr|Resto]) -->
    sintagma_adjetival(_, _, Atr),
    complementos_verbales(Resto).

complementos_verbales([SP|Resto]) -->
    sintagma_preposicional(SP),
    complementos_verbales(Resto).

complementos_verbales([Adv|Resto]) -->
    sintagma_adverbial(Adv),
    complementos_verbales(Resto).

complementos_verbales([]) --> [].

% ==========================================================
% OTROS SINTAGMAS
% ==========================================================

sintagma_adjetival(Num, Gen, sadj(Adj)) -->
    adjetivo(Num, Gen, Adj).

sintagma_preposicional(sp(Prep, SN)) -->
    preposicion(Prep),
    sintagma_nominal(_, _, SN).

sintagma_adverbial(sadv(Adv)) -->
    adverbio(Adv).

% ==========================================================
% VISUALIZACIÓN DEL ÁRBOL
% ==========================================================

mostrar_arbol(Termino) :-
    nl,
    write('Arbol visual:'), nl,
    imprimir_arbol(Termino, 0).

imprimir_arbol(Termino, Nivel) :-
    atomic(Termino),
    tab(Nivel),
    write('- '), write(Termino), nl.

imprimir_arbol(Termino, Nivel) :-
    compound(Termino),
    Termino =.. [Functor|Args],
    tab(Nivel),
    write('- '), write(Functor), nl,
    Nivel1 is Nivel + 4,
    imprimir_hijos(Args, Nivel1).

imprimir_hijos([], _).
imprimir_hijos([H|T], Nivel) :-
    imprimir_arbol(H, Nivel),
    imprimir_hijos(T, Nivel).

% ==========================================================
% ARTÍCULOS
% ==========================================================

articulo(sing, masc, art(el)) --> [el].
articulo(sing, fem,  art(la)) --> [la].
articulo(plur, masc, art(los)) --> [los].
articulo(plur, fem,  art(las)) --> [las].

articulo(sing, masc, art(un)) --> [un].
articulo(sing, fem,  art(una)) --> [una].
articulo(plur, masc, art(unos)) --> [unos].
articulo(plur, fem,  art(unas)) --> [unas].

% ==========================================================
% NOMBRES
% ==========================================================

nombre(sing, masc, n(perro)) --> [perro].
nombre(plur, masc, n(perros)) --> [perros].

nombre(sing, fem, n(perra)) --> [perra].
nombre(plur, fem, n(perras)) --> [perras].

nombre(sing, masc, n(gato)) --> [gato].
nombre(plur, masc, n(gatos)) --> [gatos].

nombre(sing, fem, n(gata)) --> [gata].
nombre(plur, fem, n(gatas)) --> [gatas].

nombre(sing, masc, n(niño)) --> [niño].
nombre(plur, masc, n(niños)) --> [niños].

nombre(sing, fem, n(niña)) --> [niña].
nombre(plur, fem, n(niñas)) --> [niñas].

nombre(sing, masc, n(hombre)) --> [hombre].
nombre(plur, masc, n(hombres)) --> [hombres].

nombre(sing, fem, n(mujer)) --> [mujer].
nombre(plur, fem, n(mujeres)) --> [mujeres].

nombre(sing, masc, n(profesor)) --> [profesor].
nombre(plur, masc, n(profesores)) --> [profesores].

nombre(sing, fem, n(profesora)) --> [profesora].
nombre(plur, fem, n(profesoras)) --> [profesoras].

nombre(sing, masc, n(estudiante)) --> [estudiante].
nombre(plur, masc, n(estudiantes)) --> [estudiantes].
nombre(sing, fem, n(estudiante)) --> [estudiante].
nombre(plur, fem, n(estudiantes)) --> [estudiantes].

nombre(sing, masc, n(coche)) --> [coche].
nombre(plur, masc, n(coches)) --> [coches].

nombre(sing, fem, n(casa)) --> [casa].
nombre(plur, fem, n(casas)) --> [casas].

nombre(sing, fem, n(pelota)) --> [pelota].
nombre(plur, fem, n(pelotas)) --> [pelotas].

nombre(sing, masc, n(libro)) --> [libro].
nombre(plur, masc, n(libros)) --> [libros].

nombre(sing, masc, n(parque)) --> [parque].
nombre(plur, masc, n(parques)) --> [parques].

nombre(sing, masc, n(jardin)) --> [jardin].
nombre(plur, masc, n(jardines)) --> [jardines].

nombre(sing, fem, n(comida)) --> [comida].
nombre(plur, fem, n(comidas)) --> [comidas].

nombre(sing, masc, n(hueso)) --> [hueso].
nombre(plur, masc, n(huesos)) --> [huesos].

nombre(sing, masc, n(pajaro)) --> [pajaro].
nombre(plur, masc, n(pajaros)) --> [pajaros].

nombre(sing, masc, n(arbol)) --> [arbol].
nombre(plur, masc, n(arboles)) --> [arboles].

% ==========================================================
% NOMBRES PROPIOS Y PRONOMBRES
% ==========================================================

nombre_propio(sing, masc, np(juan)) --> [juan].
nombre_propio(sing, masc, np(pedro)) --> [pedro].
nombre_propio(sing, fem, np(maria)) --> [maria].
nombre_propio(sing, fem, np(ana)) --> [ana].

pronombre(sing, fem, pron(ella)) --> [ella].
pronombre(plur, masc, pron(ellos)) --> [ellos].
pronombre(plur, fem, pron(ellas)) --> [ellas].
pronombre(sing, _, pron(yo)) --> [yo].
pronombre(sing, _, pron(tu)) --> [tu].

% ==========================================================
% ADJETIVOS
% ==========================================================

adjetivo(sing, masc, adj(pequeño)) --> [pequeño].
adjetivo(plur, masc, adj(pequeños)) --> [pequeños].
adjetivo(sing, fem, adj(pequeña)) --> [pequeña].
adjetivo(plur, fem, adj(pequeñas)) --> [pequeñas].

adjetivo(sing, masc, adj(grande)) --> [grande].
adjetivo(plur, masc, adj(grandes)) --> [grandes].
adjetivo(sing, fem, adj(grande)) --> [grande].
adjetivo(plur, fem, adj(grandes)) --> [grandes].

adjetivo(sing, masc, adj(rapido)) --> [rapido].
adjetivo(plur, masc, adj(rapidos)) --> [rapidos].
adjetivo(sing, fem, adj(rapida)) --> [rapida].
adjetivo(plur, fem, adj(rapidas)) --> [rapidas].

adjetivo(sing, masc, adj(lento)) --> [lento].
adjetivo(plur, masc, adj(lentos)) --> [lentos].
adjetivo(sing, fem, adj(lenta)) --> [lenta].
adjetivo(plur, fem, adj(lentas)) --> [lentas].

adjetivo(sing, masc, adj(bonito)) --> [bonito].
adjetivo(plur, masc, adj(bonitos)) --> [bonitos].
adjetivo(sing, fem, adj(bonita)) --> [bonita].
adjetivo(plur, fem, adj(bonitas)) --> [bonitas].

adjetivo(sing, masc, adj(feo)) --> [feo].
adjetivo(plur, masc, adj(feos)) --> [feos].
adjetivo(sing, fem, adj(fea)) --> [fea].
adjetivo(plur, fem, adj(feas)) --> [feas].

adjetivo(sing, masc, adj(alto)) --> [alto].
adjetivo(plur, masc, adj(altos)) --> [altos].
adjetivo(sing, fem, adj(alta)) --> [alta].
adjetivo(plur, fem, adj(altas)) --> [altas].

adjetivo(sing, masc, adj(bajo)) --> [bajo].
adjetivo(plur, masc, adj(bajos)) --> [bajos].
adjetivo(sing, fem, adj(baja)) --> [baja].
adjetivo(plur, fem, adj(bajas)) --> [bajas].

adjetivo(sing, masc, adj(joven)) --> [joven].
adjetivo(plur, masc, adj(jovenes)) --> [jovenes].
adjetivo(sing, fem, adj(joven)) --> [joven].
adjetivo(plur, fem, adj(jovenes)) --> [jovenes].

adjetivo(sing, masc, adj(viejo)) --> [viejo].
adjetivo(plur, masc, adj(viejos)) --> [viejos].
adjetivo(sing, fem, adj(vieja)) --> [vieja].
adjetivo(plur, fem, adj(viejas)) --> [viejas].

% ==========================================================
% VERBOS
% ==========================================================

verbo_intransitivo(sing, v(corre)) --> [corre].
verbo_intransitivo(plur, v(corren)) --> [corren].

verbo_intransitivo(sing, v(salta)) --> [salta].
verbo_intransitivo(plur, v(saltan)) --> [saltan].

verbo_intransitivo(sing, v(camina)) --> [camina].
verbo_intransitivo(plur, v(caminan)) --> [caminan].

verbo_intransitivo(sing, v(duerme)) --> [duerme].
verbo_intransitivo(plur, v(duermen)) --> [duermen].

verbo_intransitivo(sing, v(ladra)) --> [ladra].
verbo_intransitivo(plur, v(ladran)) --> [ladran].

verbo_intransitivo(sing, v(maulla)) --> [maulla].
verbo_intransitivo(plur, v(maullan)) --> [maullan].

verbo_transitivo(sing, v(ve)) --> [ve].
verbo_transitivo(plur, v(ven)) --> [ven].

verbo_transitivo(sing, v(mira)) --> [mira].
verbo_transitivo(plur, v(miran)) --> [miran].

verbo_transitivo(sing, v(quiere)) --> [quiere].
verbo_transitivo(plur, v(quieren)) --> [quieren].

verbo_transitivo(sing, v(come)) --> [come].
verbo_transitivo(plur, v(comen)) --> [comen].

verbo_transitivo(sing, v(empuja)) --> [empuja].
verbo_transitivo(plur, v(empujan)) --> [empujan].

verbo_transitivo(sing, v(toca)) --> [toca].
verbo_transitivo(plur, v(tocan)) --> [tocan].

verbo_copulativo(sing, v(es)) --> [es].
verbo_copulativo(plur, v(son)) --> [son].
verbo_copulativo(Num, V) --> parecer_copulativo(Num, V).

parecer_copulativo(sing, v(parece)) --> [parece].
parecer_copulativo(plur, v(parecen)) --> [parecen].

% ==========================================================
% PREPOSICIONES
% ==========================================================

preposicion(p(con)) --> [con].
preposicion(p(de)) --> [de].
preposicion(p(a)) --> [a].
preposicion(p(en)) --> [en].
preposicion(p(sobre)) --> [sobre].
preposicion(p(bajo)) --> [bajo].
preposicion(p(desde)) --> [desde].
preposicion(p(hasta)) --> [hasta].

% ==========================================================
% ADVERBIOS
% ==========================================================

adverbio(adv(rapidamente)) --> [rapidamente].
adverbio(adv(lentamente)) --> [lentamente].
adverbio(adv(bien)) --> [bien].
adverbio(adv(mal)) --> [mal].
adverbio(adv(hoy)) --> [hoy].
adverbio(adv(ayer)) --> [ayer].

adverbio_negacion(neg(no)) --> [no].