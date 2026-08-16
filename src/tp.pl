
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

% CASO DIA FESTIVO

conocioHazania(Persona, AnioDesde, porDiaFestivo, hazania(NombreHazania, Donde, Quienes)):-
    
    %Garantizo inversibilidad respecto de Persona (y unifico el pueblo en que nacio)
    persona(Persona, Pueblo, AnioNacimiento, _),

    %Verifico si existe una festividad en dicho pueblo que conmemore la Hazania
    esConmemorada(hazania(NombreHazania, Donde, Quienes), Pueblo, AnioDesde, diaFestivo),

    %Verifico si la festividad se empezo a celebrar luego de su nacimiento (La conoce desde que se empezo a celebrar)
    AnioDesde > AnioNacimiento,

    %Verifico que siga vivo en dicho Anio
    estaVivoEnAnio(Persona,AnioDesde).

conocioHazania(Persona, AnioNacimiento, porDiaFestivo, hazania(NombreHazania, Donde, Quienes)):-
    
    %Garantizo inversibilidad respecto de Persona (y unifico el pueblo en que nacio)
    persona(Persona, Pueblo, AnioNacimiento, _),

    %Verifico si existe una festividad en dicho pueblo que conmemore la Hazania
    esConmemorada(hazania(NombreHazania, Donde, Quienes), Pueblo, AnioDesde, diaFestivo),

    %Verifico si la festividad se empezo antes/el mismo anio de su nacimiento (La conoce desde que nacio)
    AnioDesde =< AnioNacimiento.


% CASO ESTATUA

conocioHazania(Persona, AnioDesde, porEstatua(NombreEstatua),hazania(NombreHazania, Donde, Quienes)):-

    %Garantizo inversibilidad respecto de Persona (y unifico el pueblo en que nacio)
    persona(Persona, Pueblo, AnioNacimiento, _),

    %Verifico si existe una estatua en dicho pueblo que conmemore la Hazania
    esConmemorada(hazania(NombreHazania, Donde, Quienes), Pueblo, AnioDesde, estatua(NombreEstatua, _, _)),

    %Verifico si la estatua se construyo luego de su nacimiento (La cnoce desde que se construyo)
    AnioDesde > AnioNacimiento,

    %Verifico que este vivo cuando se construyo la estatua
    estaVivoEnAnio(Persona,AnioDesde). 

conocioHazania(Persona, AnioNacimiento, porEstatua(NombreEstatua),hazania(NombreHazania, Donde, Quienes)):-
    
    %Garantizo inversibilidad respecto de Persona (y unifico el pueblo en que nacio)
    persona(Persona, Pueblo, AnioNacimiento, _),

    %Verifico si existe una estatua en dicho pueblo que conmemore la Hazania
    esConmemorada(hazania(NombreHazania, Donde, Quienes), Pueblo, AnioDesde, estatua(NombreEstatua, _, _)),

    %Verifico si la estatua se construyo antes/el mismo anio de su nacimiento (La conoce desde que nacio)
    AnioDesde =< AnioNacimiento.


% todaviaLoRecuerda(Como, AnioConocio, Anio)    %Evitamos poner el CuantosAniosLaRecuerda, porque para las estatuas es una condicion


recuerdaHazania(NombreDePersona, NombreHazania, Anio):-
    persona(NombreDePersona, _, _, _),

    %La debe haber conocido en algun momento

    conocioHazania(NombreDePersona, AnioConocio, Como,hazania(NombreHazania, Donde, Quienes)),

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

%CASO DIA FESTIVO

todaviaLoRecuerda(porDiaFestivo, _, _). %Si hay un dia festivo la recuerda para siempre (La verificacion de seguir vivo esta en recuerdaHazania)

%CASO ESATUA

todaviaLoRecuerda(porEstatua(NombreEstatua), _, Anio):-
    
    %Garantizo inversibilidad respecto de NombreEstatua
    esConmemorada(_,_,_,estatua(NombreEstatua, _, _)),

    %Estas hazañas son recordadas si la estatua sigue en buen estado.
    estaEnBuenEstado(NombreEstatua, Anio).

/*
    Una estatua está en buen estado…:

    sí es de mármol, si tuvo un mantenimiento o fue construida hace no más de 30 años.
    sí es de bronce, si tuvo un mantenimiento o fue construida hace no más de 15 años.
*/
estaEnBuenEstado(NombreEstatua, AnioActual):-
    
    %Obtengo datos de la estatua
    esConmemorada(_,_,AnioConstruccion,estatua(NombreEstatua, Material, _)),

    %Obtengo la Duracion del material
    duracionMaterial(Material, Duracion),

    construidaRecientemente(AnioConstruccion, Duracion, AnioActual).    %Es inversible respecto de AnioActual

estaEnBuenEstado(NombreEstatua, AnioActual):-
    
    %Obtengo datos de la estatua
    esConmemorada(_,_,_,estatua(NombreEstatua, Material, AniosMantenimiento)),

    %Obtengo la Duracion del material
    duracionMaterial(Material, Duracion),
    
    mantenidaRecientemente(AniosMantenimiento, Duracion, AnioActual). %Es inversible respecto de AnioActual


%Asocio c/material con su duracion
duracionMaterial(marmol, 30).
duracionMaterial(bronce, 15).

construidaRecientemente(AnioConstruccion, Duracion, AnioActual):-

    %Dependiende de la duracion del material
    AnioFinal is AnioConstruccion + Duracion,

    between(AnioConstruccion, AnioFinal, AnioActual).


%No considero el caso de AniosMantenimiento=[] por principio de universo cerrado
%No considero el caso de AniosMantenimiento=[Anio], esta contenido en el siguiente

%Caso 1 o mas anios de mantenimiento
mantenidaRecientemente([Anio1|AniosSiguientes], Duracion, AnioActual):-

    %Si no existe ningun otro anio en el q se le realizo mantenimiento posterior a Anio1, pero menor/igual a AnioActual

    not(
            (
                member(UnAnio, AniosSiguientes),    
                %Si AniosSiguientes es [], esto da false, por ende el not() es true, esto funciona 
                %porque Anio1 es el ultimo anio en que se le realizo mantenimiento

                between(Anio1, AnioActual, UnAnio)
                
            )
        ),

    %Entonces Anio1 es el ultimo anio en que se le realizo mantenimiento
    %Verifico que el AnioActual sea posterior a este, pero no exceda el AnioFinal

    AnioFinal is Anio1 + Duracion,

    between(Anio1, AnioFinal, AnioActual).
    
mantenidaRecientemente([Anio1|AniosSiguientes], Duracion, AnioActual):-
    
    %Si existe algun anio en el que se le realizo mantenimiento posterior a Anio1, pero menor/igual a AnioActual

    member(UnAnio, AniosSiguientes),

    between(Anio1, AnioActual, UnAnio),

    %Entonces el ultimo Anio en que se le realizo mantenimiento esta en la lista AniosSiguientes, lo busco de forma recursiva

    mantenidaRecientemente(AniosSiguientes, Duracion, AnioActual).


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


pasoAlOlvido(NombreHazania, Anio):-

    %Garantizo inversibilidad respecto de NombreHazania
    conocioHazania(_,_,_,hazania(NombreHazania, _, _)),

    %Garantizo inversibilidad respecto de Anio 
    between(0, inf, Anio),
    
    %Niego la existencia de personas que recuerden la hazania indicada en dicho Anio
    not(recuerdaHazania(_, NombreHazania, Anio)).



% 3 - a

% esConmemorada(Hazania, Donde, AnioDesde, Como)

% Como -> diaFestivo / estatua(Nombre, Material, [AniosMantenimiento])

esConmemorada(
                hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                weise,
                1340,
                diaFestivo
            ).

esConmemorada(
                hazania(destruirReyDemonio, ende, [frieren, himmel, heiter, eisen]),
                auberst,
                1370,
                estatua(elEquipoDeHeroes, bronce, [1400, 1450])
            ).

esConmemorada(
                hazania(destruirSchlatElOmniscente, ende, [heroeDelSur]),
                auberst,
                1340,
                estatua(elHeroeDelSur, marmol, [1410])
            ).






%%%   ------------------    Parte 2       --------------------



esPueblo(auberst).
esPueblo(ende).
esPueblo(weise).
esPueblo(riegel).
esPueblo(klares).

esHazania(rescatarHermanaDeWirbel).
esHazania(destruirDemonioAura).
esHazania(destruirReyDemonio).
esHazania(recuperarGatoPerdido).



% I )
puebloRecuerdaHazaniaEnAnio(NombreHazania, Pueblo, Anio):-
    persona(Persona, Pueblo, AnioNacimiento, _),
    recuerdaHazania(Persona, NombreHazania, Anio).
% II ) 
leyeronPaginasEnAnio(Pueblo, Total, Anio):-
    esPueblo(Pueblo),
    persona(Persona, Pueblo, _, _ ),
    findall(
        CantPaginas ,
        conocioHazania(Persona, Anio, leyo(paginas(CantPaginas)),_),
        ListaCantPag
        ),
    sum_list(ListaCantPag, Total).
% III)
puebloLeeMasQueOtro(Pueblo1, Pueblo2, Anio):-
    esPueblo(Pueblo1),
    esPueblo(Pueblo2),
    leyeronPaginasEnAnio(Pueblo1, Total1, Anio),
    leyeronPaginasEnAnio(Pueblo2, Total2, Anio),
    Total1 > Total2.

puebloQueMasLeeEnAnio(Pueblo, Anio):-
    esPueblo(Pueblo),
    forall(
        ( esPueblo(OtroPueblo), OtroPueblo \=  Pueblo ),
        puebloLeeMasQueOtro(Pueblo,OtroPueblo,Anio)
        ).
%  IV)
listaHazaniasPorComoLaConocio(Pueblo, Lista, ComoLaConocio ,Anio):-
    findall(
    Hazania,                    % Lista de todas las hazania que una persona conocio durante cierto anio de una manera particular(ComoLaConocio)
        (persona(Persona,Pueblo,_,_),  conocioHazania(Persona, Anio, ComoLaConocio,hazania(Hazania, _, _))),
        Lista
    ).
hayMasHazaniasEscuchadas(ListaEscuchadas,ListaPresenciadas,ListaLeidas):-
    length(ListaEscuchadas, CantEscuchadas),
    length(ListaPresenciadas, CantPresenciadas),
    length(ListaLeidas, CantLeidas),
    CantEscuchadas > CantLeidas,
    CantEscuchadas > CantPresenciadas.

esPuebloMusicalEnAnio(Pueblo,Anio):-
    esPueblo(Pueblo),
    listaHazaniasPorComoLaConocio(Pueblo, ListaEscuchadas, escuchoCancion, Anio),
    listaHazaniasPorComoLaConocio(Pueblo, ListaPresenciadas, presencio, Anio),
    listaHazaniasPorComoLaConocio(Pueblo, ListaLeidas, leyo(_), Anio),
    hayMasHazaniasEscuchadas(ListaEscuchadas,ListaPresenciadas,ListaLeidas).
%   V)
esPuebloChismosoEnAnio(Pueblo,Anio):-
    esPueblo(Pueblo),
    forall(
        (persona(Persona, Pueblo, _, _), conocioHazania(Persona, Anio, _,hazania(Hazania, _, _)) ),  % Para toda hazania conocida por alguien del pueblo
        not(estaCorroborada(Hazania))                                                                % esa hazania no esta corroborrada
        ).    
%   VI)
hazaniaEsImportanteEnPueblo(Pueblo,NombreHazania,Anio):-
    esPueblo(Pueblo),
    esHazania(NombreHazania),
    forall(
        (persona(Persona, Pueblo, _, _), estaVivoEnAnio(Persona, Anio)),    % Para toda persona de un pueblo y que siga viva durante cierto anio
        recuerdaHazania(Persona, NombreHazania, Anio)                 % recuerda la hazania
    ).
%   VII
nadieDelPuebloPresencioHazania(Hazania,Pueblo,Anio):-
    esPueblo(Pueblo),
    esHazania(Hazania),
    forall(
        persona(Persona,Pueblo,_,_),                                          % Para toda persona del pueblo durante cierto anio
        not(conocioHazania(Persona, Anio, presencio,hazania(Hazania,_,_)))    % ninguna de esas personas PRESENCIO la hazania
        ).

puebloViveTiempoSinPresedente(Pueblo, Anio):-
    esPueblo(Pueblo),
    forall(
        hazaniaEsImportanteEnPueblo(Pueblo, Hazania, Anio),       % Para toda hazania importante de un pueblo durante un anio
        not(nadieDelPuebloPresencioHazania(Hazania,Pueblo,Anio))  % Al menos uno la presencio
        ).


% punto 5
% a)
esHeroe(Persona):-  % devuelve muchos true
    persona(Persona, _, _ , _),
    conocioHazania(_,_,_, hazania(_, _, Participantes) ),
    member(Persona, Participantes).


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

    test("Una hazania pasa al olvido en un determinado anio si ya nadie la recuerda en dicho anio", nondet):-
        pasoAlOlvido(destruirDemonioAura, 1460),
        not(pasoAlOlvido(destruirDemonioAura, 1440)).

    test("Una estatua esta en buen estado, segun su material, si fue construida/tuvo mantenimiento reciente dentro del rango de duracion del material"):-
        %Lawine recuerda destruir al rey demonio en 1400 ya que vive en Auberst y allí hay una estatua en buen estado conmemorando la hazaña
        estaEnBuenEstado(elEquipoDeHeroes, 1400),
        %en 1390 Lawine no recuerda destruir al rey demonio porque la estatua no se encuentra en buen estado en ese momento
        not(estaEnBuenEstado(elEquipoDeHeroes, 1390)),
        %En 1000 la estatua elHeroeDelSur no habia sido construida, no puede estar en buen estado
        not(estaEnBuenEstado(elHeroeDelSur, 1000)), 
        %En 1360 la estatua de marmol elHeroeDelSur q se construyo en 1340 y no tuvo mantenimiento hasta 1410 sigue en buen estado, no pasaron 30 anios
        estaEnBuenEstado(elHeroeDelSur, 1360),
        %En 1371 la estatua de marmol elHeroeDelSur q se construyo en 1340 y no tuvo mantenimiento hasta 1410 ya esta en mal estado
        not(estaEnBuenEstado(elHeroeDelSur, 1371)), 
        %En 1420 la estatua de marmol elHeroeDelSur tuvo mantenimiento en 1410 y sigue en buen estado, no pasaron 30 anios
        estaEnBuenEstado(elHeroeDelSur, 1420),
        %Pero en 1441 dejo de tener mantenimiento, esta en mal estado
        not(estaEnBuenEstado(elHeroeDelSur, 1441)).


    test("Una persona conocio una hazania si donde vive hay alguna estatua que conmemore la hazania. Es recordada si la estatua sigue en buen estado.",nondet):-
        recuerdaHazania(lawine,destruirReyDemonio,1400),
        not(recuerdaHazania(lawine, destruirReyDemonio,1390)),
        recuerdaHazania(fern,destruirReyDemonio,1400).
    
        

        % Parte 2

    
    test("Un pueblo recuerda una hazania en un determinado anio si al menos una persona que vive en ese pueblo recuerda esa hazania", nondet):-
        puebloRecuerdaHazaniaEnAnio(destruirReyDemonio, weise, 1400),
        puebloRecuerdaHazaniaEnAnio(rescatarHermanaDeWirbel, klares, 1395),
        not(puebloRecuerdaHazaniaEnAnio(destruirReyDemonio, klares, 1395)).

    test("Las paginas leidas en un pueblo es la sumatoria de las paginas leidas de los habitantes de un pueblo", nondet):-
        leyeronPaginasEnAnio(weise, 100, 1335),
        leyeronPaginasEnAnio(weise, 0, 1336).

    test("Un pueblo puede ser el que mas lee en un determinado anio", nondet):-
        puebloQueMasLeeEnAnio(ende, 1400).


    test("Un pueblo es musical si escucha mas hazanias cantadas que presenciadas o leidas", nondet):-
        esPuebloMusicalEnAnio(auberst, 1393),
        not(esPuebloMusicalEnAnio(weise, 1400)).

    test("Una hazania es importante en un pueblo si todas las personas que viven alli la recuerdan", nondet):-
        hazaniaEsImportanteEnPueblo(weise, destruirReyDemonio, 1400),
        not(hazaniaEsImportanteEnPueblo(weise, recuperarGatoPerdido,1400)).

    test("Un pueblo vive tiempos sin precedentes si todas las hazanias importantes fueron presenciadas", nondet):-
        puebloViveTiempoSinPresedente(klares, 1390),
        not(puebloViveTiempoSinPresedente(weise, 1400)).

:- end_tests(tpIntegrador).
