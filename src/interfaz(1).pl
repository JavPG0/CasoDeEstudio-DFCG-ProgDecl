:- ensure_loaded('Project2(1).pl').
:- use_module(library(readutil)).

iniciar :-
    nl,
    write('Analizador de frases en castellano'), nl,
    bucle.

bucle :-
    nl,
    write('Introduce la frase que quieres comprobar:'), nl,
    write('> '),
    read_line_to_string(user_input, Texto),
    procesar_entrada(Texto).

procesar_entrada(end_of_file) :-
    nl,
    write('Fin del programa.'), nl.

procesar_entrada("") :-
    write('No has escrito ninguna frase.'), nl,
    bucle.

procesar_entrada(Texto) :-
    string_lower(Texto, TextoMin),
    ( TextoMin = "salir" ->
        nl,
        write('Programa finalizado.'), nl
    ;
        texto_a_lista(TextoMin, Lista),
        comprobar_frase(Lista),
        bucle
    ).

texto_a_lista(Texto, ListaAtoms) :-
    replace_string(Texto, ".", " . ", TextoConPunto),
    split_string(TextoConPunto, " ", " ,;:!?¡¿\"'()", ListaStrings),
    exclude(==(""), ListaStrings, ListaLimpia),
    maplist(atom_string, ListaAtoms, ListaLimpia).

replace_string(String, Buscar, Reemplazar, Resultado) :-
    split_string(String, Buscar, "", Partes),
    atomics_to_string(Partes, Reemplazar, Resultado).

comprobar_frase(Lista) :-
    ( phrase(oracion(Arbol), Lista) ->
        write('--> FRASE CORRECTA. <--'), nl,
        write('Arbol sintactico (termino Prolog):'), nl,
        write(Arbol), nl,
        mostrar_arbol(Arbol)
    ;
        write('Frase incorrecta o no reconocida por la gramatica.'), nl
    ),
    write('Lista interpretada: '), write(Lista), nl.