persona(denken,  auberst, 1290, humano).
persona(voll,    ende,    1200, enano).
persona(serie,   weise,    500, elfo).
persona(fern,    weise,   1370, humano).
persona(stark,   riegel,  1368, humano).
persona(lawine,  auberst, 1372, humano).
persona(kanne,   weise,   1365, humano).
persona(wirbel,  klares,  1350, humano).
persona(lernen,  auberst, 1315, humano).
persona(frieren, weise,    100, elfo).
persona(eisen,   riegel,  1150, enano).

% punto 1-a

esperanzaDeVida(enano,350).
esperanzaDeVida(humano,85).
esperanzaDeVida(elfo,infinito).

sigueVivo(Anio ,AnioNacimiento,infinito).
sigueVivo(Anio ,AnioNacimiento,EsperanzaDeVida):-
    Anio =< (AnioNacimiento + EsperanzaDeVida).

estaVivoEnAnio(Persona,Anio):-
    persona(Persona,_,AnioNacimiento,Raza),
    esperanzaDeVida(Raza, EsperanzaDeVida),
    Anio >= AnioNacimiento.
    sigueVivo(Anio,AnioNacimiento,EsperanzaDeVida).



:- begin_tests(tpIntegrador, []).

:- end_tests(tpIntegrador).
