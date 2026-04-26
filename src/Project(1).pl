% Este archivo es el esquema básico inicial.
% Define la estructura pura sin extracción de árbol semántico ni control de concordancia.

% Oración = SN + SV + Puntuacion
oracion --> sujeto, predicado, puntuacion.

sujeto --> sintagma_nominal.
predicado --> sintagma_verbal, complemento.
predicado --> sintagma_verbal.

% Puntuacion final obligatoria
puntuacion --> ['.'].

% Sintagma nominal: articulo + sustantivo [+ sintagma adjetival] [+ sintagma preposicional]
sintagma_nominal --> articulo, sintagma_nominal2.
sintagma_nominal --> sustantivo.
sintagma_nominal2 --> sustantivo.
sintagma_nominal2 --> sustantivo , sintagma_adjetival.
sintagma_nominal2 --> sustantivo, sintagma_preposicional.

% Sintagma verbal: verbo
sintagma_verbal --> verbo.

% Complementos opcionales
complemento --> sintagma_nominal.
complemento --> sintagma_nominal, complemento.
complemento --> sintagma_adjetival.
complemento --> sintagma_adjetival, complemento.
complemento --> sintagma_preposicional.
complemento --> sintagma_preposicional, complemento.

% Sintagma adjetival = adjetivo
sintagma_adjetival --> adjetivo.

% Sintagma preposicional = prep + SN
sintagma_preposicional --> preposicion, sintagma_nominal.
 

%% Léxico básico: artículos, sustantivos, adjetivos, verbos y preposiciones.
articulo --> [el].
articulo --> [la].
articulo --> [los].
articulo --> [las].
articulo --> [su].

sustantivo --> [niño].
sustantivo --> [niña].
sustantivo --> [perro].
sustantivo --> [perros].
sustantivo --> [casa].
 
adjetivo --> [pequeño].
adjetivo --> [pequeña].
adjetivo --> [rapido].
adjetivo --> [rapida].
adjetivo --> [lento].
adjetivo --> [lenta].

verbo --> [corre].
verbo --> [salta].
verbo --> [come].
verbo --> [ve].

preposicion --> [en].
preposicion --> [con].
preposicion --> [sin].
preposicion --> [sobre].
preposicion --> [bajo].
preposicion --> [entre].
preposicion --> [hacia].
preposicion --> [desde].
preposicion --> [de].
preposicion --> [entre].
preposicion --> [hacia].
preposicion --> [desde].
preposicion --> [de].