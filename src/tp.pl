
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
esperanzaDeVida(humano,80).
esperanzaDeVida(elfo,infinito).

sigueVivo(Anio,AnioNacimiento,infinito):-
    between(AnioNacimiento, inf, Anio).
    
sigueVivo(Anio,AnioNacimiento,EsperanzaDeVida):-
    EsperanzaDeVida \= infinito,
    AnioMuerte is AnioNacimiento+EsperanzaDeVida,
    between(AnioNacimiento, AnioMuerte, Anio).

estaVivoEnAnio(NombreDePersona,Anio):-
    persona(NombreDePersona,_,AnioNacimiento,Raza),
    esperanzaDeVida(Raza, EsperanzaDeVida),
    sigueVivo(Anio,AnioNacimiento,EsperanzaDeVida).


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
    escuchoCancion,
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


% todaviaLoRecuerda(Como, AnioConocio, Anio)    %Evitamos poner el CuantosAniosLaRecuerda, porque para las estatuas es una condicion


recuerdaHazania(NombreDePersona, NombreHazania, Anio):-
    persona(NombreDePersona, _, _, _),

    %La debe haber conocido en algun momento

    conocioHazania(NombreDePersona, AnioConocio, Como,hazania(NombreHazania, _, _)),

%El Anio debe ser mayor al anio en que la conocio (Usando between garantizo que sea inversible respecto de Anio)

    between(AnioConocio, inf, Anio),

    %Debe estar vivo en dicho Anio

    estaVivoEnAnio(NombreDePersona,Anio),

    %Todavia recuerda la Hazania segun como la conocio

    todaviaLoRecuerda(Como, AnioConocio, Anio).

todaviaLoRecuerda(presencio, _, _). %Si la presencio la recuerda para siempre (La verificacion de seguir vivo esta en recuerdaHazania)

todaviaLoRecuerda(escuchoCancion, AnioConocio, Anio):-

    %si una persona escuchó una canción sobre una hazaña, la recuerda por 15 años.

    AnioDeOlvido is AnioConocio + 15,

    between(AnioConocio, AnioDeOlvido, Anio).

todaviaLoRecuerda(leyo(paginas(CuantasPaginas)), AnioConocio, Anio):-

    %si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como páginas tenga el libro.

    AnioDeOlvido is AnioConocio + CuantasPaginas,

    between(AnioConocio, AnioDeOlvido, Anio).

/*
Una hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas 
que la conocieron con distintos detalles (ya sea diferentes personas que la llevaron a cabo o diferente 
lugar en el que ocurrió la hazaña)
*/


estaCorroborada(NombreHazania):-
    
    %Garantizo inversibilidad

    conocioHazania(_,_,_,hazania(NombreHazania, _, _)),

    hayUnaUnicaVersion(NombreHazania).


hayUnaUnicaVersion(NombreHazania):-

    conocioHazania(_,_,_,hazania(NombreHazania, Lugar, Heroes)),
    
    not(    %Niego la existencia de versiones distintas

            (
            conocioHazania(_,_,_,hazania(NombreHazania, OtroLugar, OtrosHeroes)),

            OtroLugar \= Lugar,

            OtrosHeroes \= Heroes
            )
    )
    
    /*
        %Version con forall

        forall(
            conocioHazania(_,_,_,hazania(NombreHazania, OtroLugar, OtrosHeroes)), %Genero todas las Hazanias con el mismo nombre, dejo el lugar y heroes de incognita
            (%Deben coincidir los detalles, si es la unica version que existe tambien es true
                OtroLugar == Lugar,
                OtrosHeroes == Heroes
            )
        )
    */
    .















































/*


% 3-b


% CASO DIA FESTIVO

conocioHazania(Persona, AnioDesde, porDiaFestivo, hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde),
    AnioDesde >= AnioNacimiento,
    estaVivoEnAnio(Persona,AnioDesde). %Verifico que este vivo cuando se empezo a celebrar la hazania

conocioHazania(Persona, AnioNacimiento, porDiaFestivo, hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde),
    AnioDesde =< AnioNacimiento. %Si se celebrara desde antes, conoce la hazania desde q nacio


%   CASO ESTATUA

conocioHazania(Persona, AnioDesde, porEstatua,hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConEstatua(NombreHazania, Pueblo, AnioDesde),
    AnioDesde >= AnioNacimiento,
    estaVivoEnAnio(Persona,AnioDesde). %Verifico que este vivo cuando se construyo la estatua.

conocioHazania(Persona, AnioNacimiento, porEstatua,hazania(NombreHazania, _, _)):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    conmemoraConEstatua(NombreHazania, Pueblo, AnioDesde),
    AnioDesde =< AnioNacimiento. %Si se existia desde antes, conoce la hazania desde q nacio



% Predicados aux para mas expresividad
conmemoraConFestividad(NombreHazania, Pueblo, AnioDesde):-
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, diaFestivo(AnioDesde)).

conmemoraConEstatua(NombreHazania, Pueblo, AnioDesde):-
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, estatua(AnioDesde, _, _)).



% cuantoAniosRecuerdaHazania(modoEnQueLaConocio, tiempoQueLaRecuerda)
cuantoAniosRecuerdaHazania(presencio, siempre).
cuantoAniosRecuerdaHazania(escuchoCancion, 15).
cuantoAniosRecuerdaHazania(leyo(paginas(CantPaginas)), CantPaginas).


% 3-b
cuantoAniosRecuerdaHazania(porDiaFestivo, siempre).





% 2-a
% todaviaLoRecuerda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio)
todaviaLoRecueda(CuandoLaConocio, siempre, Anio):-
    between(CuandoLaConocio, inf, Anio).

todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio):-
    CuantosAniosLaRecuerda \= siempre,
    CuandoLoOlvida is CuandoLaConocio + CuantosAniosLaRecuerda,
    between(CuandoLaConocio, CuandoLoOlvida, Anio).

recuerdaHazaniaEnAnio(Persona, NombreHazania, Anio):-
    conocioHazania(Persona, CuandoLaConocio, ComoLaConocio, hazania(NombreHazania,_,_)),
    estaVivoEnAnio(Persona,Anio),
    cuantoAniosRecuerdaHazania(ComoLaConocio, CuantosAniosLaRecuerda),
    todaviaLoRecueda(CuandoLaConocio, CuantosAniosLaRecuerda, Anio).

% 3-b
recuerdaHazaniaEnAnio(Persona, NombreHazania, Anio):-
    conocioHazania(Persona, CuandoLaConocio, porEstatua, hazania(NombreHazania,_,_)),
    Anio >= CuandoLaConocio,
    estaVivoEnAnio(Persona,Anio),
    persona(Persona, Pueblo, _, _),
    conmemoraConEstatuaEnBuenEstado(NombreHazania, Pueblo, Anio).

% Predicado aux para mas expresividad
conmemoraConEstatuaEnBuenEstado(NombreHazania, Pueblo, AnioActual):-
    esConmemorada(hazania(NombreHazania, _, _), Pueblo, estatua(AnioDesde, Material, AniosMantenimiento)),
    estaEnBuenEstado(estatua(AnioDesde, Material, AniosMantenimiento), AnioActual).

% Predicado aux mantenimientoReciente
%% Revisa si alguno de los anios de mantenimiento está dentro de la distancia dada. Asume que la lista de anios de mantenimiento está ordenada de menor a mayor.

% TUVO MANTINIMIENTO UN SOLO AÑO

mantenimientoReciente(AnioActual,[AnioMantenimiento],Distancia):-
    AnioActual>=AnioMantenimiento, 
    AnioActual-AnioMantenimiento =< Distancia.

% TUVO MANTINIMIENTO VARIOS AÑOS

mantenimientoReciente(AnioActual,[X|Xs],Distancia):-
    AnioActual>=X,
    AnioActual-X =< Distancia;
    mantenimientoReciente(AnioActual,Xs,Distancia).

% ESTATUAS DE MARMOL

estaEnBuenEstado(estatua(AnioDesde, marmol, []), AnioActual):- 
    AnioActual >= AnioDesde,
    AnioActual - AnioDesde =< 30.

estaEnBuenEstado(estatua(_, marmol, AniosMantenimiento), AnioActual):-
    mantenimientoReciente(AnioActual,AniosMantenimiento,30).

% ESTATUAS DE BRONCE

estaEnBuenEstado(estatua(AnioDesde, bronce, []), AnioActual):-
    AnioActual >= AnioDesde,
    AnioActual - AnioDesde =< 15.

estaEnBuenEstado(estatua(_, bronce, AniosMantenimiento), AnioActual):-
    mantenimientoReciente(AnioActual,AniosMantenimiento,15).



% 2-b

% Predicado auxiliar

% compara con el resto de personas que que conocen hazanias con el mismo nombre y se evalua si ocurren en el mismo lugar y tienen los mismos participantes.
estaCorroborada(NombreHazania) :-
    conocioHazania(_, _, _, hazania(NombreHazania, Donde1, Quienes1)),
    forall(                                                                  
        conocioHazania(_, _, _, hazania(NombreHazania, Donde2, Quienes2)),   
        (
            Donde1 == Donde2,
            Quienes1 == Quienes2
        )
    ).

% 2 - c
pasoAlOlvido(NombreHazania, Anio):-
    conocioHazania(_,_,_,hazania(NombreHazania, _, _)),
    not(recuerdaHazaniaEnAnio(_, NombreHazania, Anio)).


% 3 - a

% esConmemorada(hazania(NombreHazania, Donde, [Quienes]), Donde, diaFestivo(AnioDesde)/ estatua(AnioDesde, Material, [AniosMantenimiento]))
*/
/*
    esConmemorada(hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                    weise, diaFestivo(1340)).

    esConmemorada(hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                    auberst, estatua(1370, bronce, [1400, 1450])).
            
    esConmemorada(hazania(destruirSchlatElOmniscente, ende, [heroeDelSur]),
                    auberst, estatua(1340, marmol, [1410])).
*/


:- begin_tests(tpIntegrador, []).

    test("Una persona esta viva si ya nacio y no supero su esperanza de vida", nondet):-
        estaVivoEnAnio(kanne,1370),
        estaVivoEnAnio(voll,1550),
        estaVivoEnAnio(serie, 5000),
        not(estaVivoEnAnio(kanne,1300)),    %no nacio
        not(estaVivoEnAnio(kanne,2000)),    %ya murio
        not(estaVivoEnAnio(voll,1551)).    %ya murio
    
    test("Una persona recuerda una hazania si sigue vivo, la presencio/leyo/escucho sobre ella y todavia la recuerda", nondet):-
        not(recuerdaHazania(lawine, destruirDemonioAura, 1380)),  %todavia no escucho la cancion
        recuerdaHazania(lawine, destruirDemonioAura, 1400),       %ahora si
        not(recuerdaHazania(lawine, destruirDemonioAura, 1410)),  %la olvido
        recuerdaHazania(voll, destruirDemonioAura, 1450),
        not(recuerdaHazania(voll, destruirDemonioAura, 1460)),
        recuerdaHazania(wirbel, rescatarHermanaDeWirbel, 1430),
        not(recuerdaHazania(wirbel, rescatarHermanaDeWirbel, 1440)). %porque murio

    
    test("Una hazania esta corroborada si hay unica version de la misma", nondet):-
        estaCorroborada(rescatarHermanaDeWirbel),   %Las versiones de frieren y wirbel coinciden
        not(estaCorroborada(destruirDemonioAura)),  %Las versiones de lawine y voll difieren
        estaCorroborada(recuperarGatoPerdido).      %Hay una sola version
        %not(estaCorroborada(destruirReyDemonio)).        %La version  de Serie y del pueblo de weise son distintas


    /*
    test("Una hazania pasa al olvido en un determinado anio si ya nadie la recuerda en dicho anio", nondet):-
        pasoAlOlvido(destruirDemonioAura, 1460),
        not(pasoAlOlvido(destruirDemonioAura, 1440)).

    test("Una persona conocio una hazania si donde vive hay alguna estatua que conmemore la hazania. Es recordada si la estatua sigue en buen estado.",nondet):-
        recuerdaHazaniaEnAnio(lawine,destruirReyDemonio,1400),
        not(recuerdaHazaniaEnAnio(lawine, destruirReyDemonio,1390)),
        recuerdaHazaniaEnAnio(fern,destruirReyDemonio,1400).
        */
        
:- end_tests(tpIntegrador).
