:- encoding(utf8).
:- ensure_loaded('Project2(1).pl').
:- use_module(library(readutil)).

%% Predicado principal para arrancar el programa
iniciar :-
    nl,
    write('Analizador de frases en castellano'), nl,
    bucle.

%% Bucle interactivo: lee la entrada del usuario y la procesa repetidamente
bucle :-
    nl,
    write('Introduce la frase que quieres comprobar:'), nl,
    write('> '),
    read_line_to_string(user_input, Texto),
    procesar_entrada(Texto).

% Condición de salida si se fuerza el fin de archivo
procesar_entrada(end_of_file) :-
    nl,
    write('Fin del programa.'), nl.

% Control de entrada vacía
procesar_entrada("") :-
    write('No has escrito ninguna frase.'), nl,
    bucle.

procesar_entrada(Texto) :-
    string_lower(Texto, TextoMin),
    ( TextoMin = "salir" ->
        nl,
        write('Programa finalizado.'), nl
    ;
        % Convertimos el string en una lista de átomos para que la gramática de cláusulas definidas lo entienda
        texto_a_lista(TextoMin, Lista),
        comprobar_frase(Lista),
        bucle
    ).

% Tokenizador: trocea la frase en palabras.
% Añadimos espacios alrededor del punto para aislarlo, así evitamos que split_string lo borre, 
% ya que nuestra gramática exige el punto final.
texto_a_lista(Texto, ListaAtoms) :-
    replace_string(Texto, ".", " . ", TextoConPunto),
    split_string(TextoConPunto, " ", " ,;:!?¡¿\"'()", ListaStrings),
    exclude(==(""), ListaStrings, ListaLimpia),
    maplist(atom_string, ListaAtoms, ListaLimpia).

% Función auxiliar para buscar y reemplazar en strings nativos de Prolog
replace_string(String, Buscar, Reemplazar, Resultado) :-
    split_string(String, Buscar, "", Partes),
    atomics_to_string(Partes, Reemplazar, Resultado).

% Motor de comprobación: llama a la gramática.
% Usamos phrase/2. Si la lista encaja con la regla 'oracion', Prolog unificará y 
% construirá automáticamente el árbol en la variable Arbol.
comprobar_frase(Lista) :-
    ( phrase(oracion(Arbol), Lista) ->
        write('--> FRASE CORRECTA. <--'), nl,
        write('Arbol sintactico (termino Prolog):'), nl,
        write(Arbol), nl,
        mostrar_arbol(Arbol) % Llama a la visualización jerárquica
    ;
        write('Frase incorrecta o no reconocida por la gramatica.'), nl
    ),
    write('Lista interpretada: '), write(Lista), nl.