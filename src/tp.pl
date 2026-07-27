
% punto 1

% 1 - a
%persona(Nombre, Pueblo, Año de nacimiento, Raza)

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

% 1 - b

esperanzaDeVida(enano,350).
esperanzaDeVida(humano,85).
esperanzaDeVida(elfo,infinito).

sigueVivo(_ ,_,infinito).
sigueVivo(Anio ,AnioNacimiento,EsperanzaDeVida):-
    Anio =< (AnioNacimiento + EsperanzaDeVida).

estaVivoEnAnio(NombreDePersona,Anio):-
    persona(NombreDePersona,_,AnioNacimiento,Raza),
    esperanzaDeVida(Raza, EsperanzaDeVida),
    Anio >= AnioNacimiento,
    sigueVivo(Anio,AnioNacimiento,EsperanzaDeVida).

% punto 2 - a

%conocioHazania(NombreDePersona, AnioDesde, Presencio/Escucho/Leyo, Hazania)

%hazania(Descripcion, Donde, [Quienes])

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


%3-b

conocioHazania(Persona, AnioDesde, porDiaFestivo, hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde),
    AnioDesde >= AnioNacimiento,
    estaVivoEnAnio(Persona,AnioDesde). %Verifico que este vivo cuando se empezo a celebrar la hazania

conocioHazania(Persona, AnioNacimiento, porDiaFestivo, hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde),
    AnioDesde =< AnioNacimiento. %Si se celebrara desde antes, conoce la hazania desde q nacio

conocioHazania(Persona, AnioDesde, porEstatua,hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, estatua(AnioDesde, _, _)),
    AnioDesde >= AnioNacimiento,
    estaVivoEnAnio(Persona,AnioDesde). %Verifico que este vivo cuando se construyo la estatua.

conocioHazania(Persona, AnioNacimiento, porEstatua,hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, estatua(AnioDesde, _, _)),
    AnioDesde =< AnioNacimiento. %Si se existia desde antes, conoce la hazania desde q nacio

%cuantoAniosRecuerdaHazania(modoEnQueLaConocio, tiempoQueLaRecuerda)
cuantoAniosRecuerdaHazania(presencio, siempre).
cuantoAniosRecuerdaHazania(escucho(_), 15).%porque lo definimos como un functor
cuantoAniosRecuerdaHazania(leyo(paginas(CantPaginas)), CantPaginas).

%3-b
cuantoAniosRecuerdaHazania(porDiaFestivo, siempre).


%todaviaLoRecuerda(CuandoLaConocio, CuantosAniosLaRecuerda, AnioConsultado)
todaviaLoRecueda(_, siempre, _).
todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio):-
    number(CuantosAniosLaRecuerda),                                    % agrego esto porque cuando hace backtracking y lo recuerda siempre tira error
    Anio =< CuandoLaConocio + CuantosAniosLaRecuerda.

recuerdaHazaniaEnAnio(Persona, NombreHazania, Anio):-
    conocioHazania(Persona, CuandoLaConocio, ComoLaConocio, hazania(NombreHazania,_,_)),
    Anio >= CuandoLaConocio,
    cuantoAniosRecuerdaHazania(ComoLaConocio, CuantosAniosLaRecuerda),
    todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio),
    estaVivoEnAnio(Persona,Anio).

%3 - b

recuerdaHazaniaEnAnio(Persona, NombreHazania, Anio):-
    conocioHazania(Persona, CuandoLaConocio, porEstatua, hazania(NombreHazania,_,_)),
    Anio >= CuandoLaConocio,
    estaVivoEnAnio(Persona,Anio),
    persona(Persona, Pueblo, _, _),
    conmemoraConEstatuaEnBuenEstado(NombreHazania, Pueblo, Anio).


% 2-b


%Hay 2 personas distintas con la misma version

estaCorroborada(NombreHazania):-
    persona(Persona1, _, _, _),
    persona(Persona2, _, _, _),
    Persona1\=Persona2,
    conocioHazania(Persona1, _, _, hazania(NombreHazania, Donde, Quienes)),
    conocioHazania(Persona2, _, _, hazania(NombreHazania, Donde, Quienes)).


% 2 - c
pasoAlOlvido(NombreHazania, Anio):-
    conocioHazania(_,_,_,hazania(NombreHazania, _, _)),
    not(recuerdaHazaniaEnAnio(_, NombreHazania, Anio)).


% 3 - a

%esConmemorada(hazania(NombreHazania, Donde, [Quienes]),
%               Donde, diaFestivo(AnioDesde)/
%                       estatua(AnioDesde, Material, [AniosMantenimiento]))

esConmemorada(hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                weise, diaFestivo(1340)).

esConmemorada(hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                auberst, estatua(1370, bronce, [1400, 1450])).
        
esConmemorada(hazania(destrirSchlatElOmniscente, ende, [heroeDelSur]),
                auberst, estatua(1340, marmol, [1410])).


% 3 - b

conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde):-
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, diaFestivo(AnioDesde)).
% Revisa si alguno de los anios de mantenimiento está dentro de la distancia dada. Asume que la lista de anios de mantenimiento está ordenada de menor a mayor.
mantenimientoReciente(AnioActual,[AnioMantenimiento],Distancia):-
    AnioActual>=AnioMantenimiento, AnioActual-AnioMantenimiento =< Distancia.

mantenimientoReciente(AnioActual,[X|Xs],Distancia):-
    AnioActual>=X,
    AnioActual-X =< Distancia;
    mantenimientoReciente(AnioActual,Xs,Distancia).
    
estaEnBuenEstado(estatua(AnioDesde, marmol, []), AnioActual):- 
%Dejo una lista vacia en anios de mantenimiento, 
%porque si hay una estatua reciente sin mantenimiento 
%matchea solo con este caso, y no con el segundo donde 
%puede romper por acceder a una lista vacia/ usar <= con una variable libre
    AnioActual - AnioDesde =< 30.

% Este código no funcionaba correctamente, si el mantenimiento no había ocurrido todavía la estatua estaba en buen estado, un absurdo.
%estaEnBuenEstado(estatua(_, marmol, AniosMantenimiento), AnioActual):-
%    max_member(UltimoMantenimiento, AniosMantenimiento),
%    AnioActual - UltimoMantenimiento =< 30.

%estaEnBuenEstado(estatua(AnioDesde, bronce, []), AnioActual):-
%    AnioActual - AnioDesde =< 15.

%estaEnBuenEstado(estatua(_, bronce, AniosMantenimiento), AnioActual):-
%    max_member(UltimoMantenimiento, AniosMantenimiento),
%    AnioActual - UltimoMantenimiento =< 15.


estaEnBuenEstado(estatua(_, marmol, AniosMantenimiento), AnioActual):-
    mantenimientoReciente(AnioActual,AniosMantenimiento,30).

estaEnBuenEstado(estatua(AnioDesde, bronce, []), AnioActual):-
    AnioActual>AnioDesde,AnioActual - AnioDesde =< 15.

estaEnBuenEstado(estatua(_, bronce, AniosMantenimiento), AnioActual):-
    mantenimientoReciente(AnioActual,AniosMantenimiento,15).


conmemoraConEstatuaEnBuenEstado(NombreHazania, Pueblo, AnioActual):-
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, estatua(AnioDesde, Material, AniosMantenimiento)),
    estaEnBuenEstado(estatua(AnioDesde, Material, AniosMantenimiento), AnioActual).






:- begin_tests(tpIntegrador, []).

    test("Una persona esta viva si ya nacio y no supero su esperanza de vida", nondet):-
        estaVivoEnAnio(kanne,1370),
        estaVivoEnAnio(voll,1550),
        estaVivoEnAnio(serie, 5000),
        not(estaVivoEnAnio(kanne,1300)),    %no nacio
        not(estaVivoEnAnio(kanne,2000)),    %ya murio
        not(estaVivoEnAnio(voll,1551)).    %ya murio
    
    test("Una persona recuerda una hazania si sigue vivo, la presencio/leyo/escucho sobre ella y todavia la recuerda", nondet):-
        not(recuerdaHazaniaEnAnio(lawine, destruirDemonioAura, 1380)),  %todavia no escucho la cancion
        recuerdaHazaniaEnAnio(lawine, destruirDemonioAura, 1400),       %ahora si
        not(recuerdaHazaniaEnAnio(lawine, destruirDemonioAura, 1410)),  %la olvido
        recuerdaHazaniaEnAnio(voll, destruirDemonioAura, 1410),
        not(recuerdaHazaniaEnAnio(voll, destruirDemonioAura, 1460)),
        recuerdaHazaniaEnAnio(wirbel, rescatarHermanaDeWirbel, 1430),
        not(recuerdaHazaniaEnAnio(wirbel, rescatarHermanaDeWirbel, 1440)). %porque murio

    test("Una hazania esta corroborada si hay unica version de la misma", nondet):-
        estaCorroborada(rescatarHermanaDeWirbel),   %Las versiones de frieren y wirbel coinciden
        not(estaCorroborada(destruirDemonioAura)).  %Las versiones de lawine y voll difieren
        %Ojo que recuperarGatoPerdido y destruirReyDemonio no estan corroboradas, pero tienen una unica version
        %solo encontre una forma de demostrar que si hay distintas versiones entonces coinciden

    test("Una hazania pasa al olvido en un determinado anio si ya nadie la recuerda en dicho anio", nondet):-
        pasoAlOlvido(destruirDemonioAura, 1460),
        not(pasoAlOlvido(destruirDemonioAura, 1440)).
    test("Una persona conocio una hazania si donde vive hay alguna estatua que conmemore la hazania. Es recordada si la estatua sigue en buen estado.",nondet):-
        recuerdaHazaniaEnAnio(lawine,destruirReyDemonio,1400),
        not(recuerdaHazaniaEnAnio(lawine, destruirReyDemonio,1390)),
        recuerdaHazaniaEnAnio(fern,destruirReyDemonio,1400).

:- end_tests(tpIntegrador).
