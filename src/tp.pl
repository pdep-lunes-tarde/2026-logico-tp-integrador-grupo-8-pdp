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

% punto 1

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

% punto 2

conocioHazania(
    wirbel,
    1390,
    presencio,
    hazania(rescatarHermanaDeWirbel, klares, [stark, fern])
).

conocioHazania(
    frieren,
    1390,
    presencio,
    hazania(rescatarHermanaDeWirbel, klares, [stark, fern])
).

conocioHazania(
    lawine,
    1393,
    escucho(cancion),
    hazania(destruirDemonioAura, weise, [frieren])
).

conocioHazania(
    voll,
    1400,
    leyo(paginas(50)),
    hazania(destruirDemonioAura, auberst, [denken])
).

conocioHazania(
    serie,
    1335,
    leyo(paginas(100)),
    hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen])
).

conocioHazania(
    kanne,
    1375,
    presencio,
    hazania(recuperarGatoPerdido, weise, [himmel, frieren])
).

cuantoAniosRecuerdaHazania(presencio, siempre).
cuantoAniosRecuerdaHazania(escucho, 15).
cuantoAniosRecuerdaHazania(leyo(paginas(CantPaginas)), CantPaginas).

todaviaLoRecueda(_, siempre, _).
todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio):-
    number(CuantosAniosLaRecuerda),                                    % agrego esto porque cuando hace backtracking y lo recuerda siempre tira error
    Anio =< CuandoLaConocio + CuantosAniosLaRecuerda.

recuerdaHazaniaEnAnio(Persona, Hazania, Anio):-
    conocioHazania(Persona, CuandoLaConocio, ComoLaConocio, Hazania),
    Anio >= CuandoLaConocio,
    cuantoAniosRecuerdaHazania(ComoLaConocio, CuantosAniosLaRecuerda),
    todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio).

:- begin_tests(tpIntegrador, []).

:- end_tests(tpIntegrador).
