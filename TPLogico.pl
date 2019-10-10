%==================  PUNTO 1  ==================
%candidato(Postulante,Partido)
candidato(frank,rojo).
candidato(claire,rojo).
candidato(garrett,azul).
candidato(jackie,amarillo).
candidato(linda,azul).
candidato(catherine,rojo).
candidato(heather,amarillo).
candidato(seth,amarillo).

%postulacion(Nombre.Edad)
postulante(frank,50).
postulante(claire,52).
postulante(garrett,64).
postulante(jackie,38).
postulante(linda,30).
postulante(catherine,59).
postulante(heather,50).

%postulacion(Partido,Provincias)
postulacion(azul,buenosAires).
postulacion(azul,chaco).
postulacion(azul,tierraDelFuego).
postulacion(azul,sanLuis).
postulacion(azul,neuquen).
postulacion(rojo,buenosAires).
postulacion(rojo,santaFe).
postulacion(rojo,cordoba).
postulacion(rojo,chubut).
postulacion(rojo,tierraDelFuego).
postulacion(rojo,sanLuis).
postulacion(amarillo,chaco).
postulacion(amarillo,formosa).
postulacion(amarillo,tucuman).
postulacion(amarillo,salta).
postulacion(amarillo,santaCruz).
postulacion(amarillo,laPampa).
postulacion(amarillo,corrientes).
postulacion(amarillo,misiones).
postulacion(amarillo,buenosAires).

%provincia(Provincia,CantidadDeHabitantes)
provincia(buenosAires,15355000).
provincia(chaco,1143201).
provincia(tierraDelFuego,160720).
provincia(sanLuis,489255).
provincia(neuquen,637913).
provincia(santaFe,3397532).
provincia(cordoba,3567654).
provincia(chubut,577466).
provincia(formosa,527895).
provincia(tucuman,1687305).
provincia(salta,1333365).
provincia(santaCruz,273964).
provincia(laPampa,349299).
provincia(corrientes,992595).
provincia(misiones,1189446).

%intencionDeVotoEn(Provincia,Partido,Porcentaje)
intencionDeVotoEn(buenosAires,rojo,40).
intencionDeVotoEn(buenosAires,azul,30).
intencionDeVotoEn(buenosAires,amarillo,30).
intencionDeVotoEn(chaco,rojo,50).
intencionDeVotoEn(chaco,azul,20).
intencionDeVotoEn(chaco,amarillo,0).
intencionDeVotoEn(tierraDelFuego,rojo,40).
intencionDeVotoEn(tierraDelFuego,azul,20).
intencionDeVotoEn(tierraDelFuego,amarillo,10).
intencionDeVotoEn(sanLuis,rojo,50).
intencionDeVotoEn(sanLuis,azul,20).
intencionDeVotoEn(sanLuis,amarillo,0).
intencionDeVotoEn(neuquen,rojo,80).
intencionDeVotoEn(neuquen,azul,10).
intencionDeVotoEn(neuquen,amarillo,0).
intencionDeVotoEn(santaFe,rojo,20).
intencionDeVotoEn(santaFe,azul,40).
intencionDeVotoEn(santaFe,amarillo,40).
intencionDeVotoEn(cordoba,rojo,10).
intencionDeVotoEn(cordoba,azul,60).
intencionDeVotoEn(cordoba,amarillo,20).
intencionDeVotoEn(chubut,rojo,15).
intencionDeVotoEn(chubut,azul,15).
intencionDeVotoEn(chubut,amarillo,15).
intencionDeVotoEn(formosa,rojo,0).
intencionDeVotoEn(formosa,azul,0).
intencionDeVotoEn(formosa,amarillo,0).
intencionDeVotoEn(tucuman,rojo,40).
intencionDeVotoEn(tucuman,azul,40).
intencionDeVotoEn(tucuman,amarillo,20).
intencionDeVotoEn(salta,rojo,30).
intencionDeVotoEn(salta,azul,60).
intencionDeVotoEn(salta,amarillo,10).
intencionDeVotoEn(santaCruz,rojo,10).
intencionDeVotoEn(santaCruz,azul,20).
intencionDeVotoEn(santaCruz,amarillo,30).
intencionDeVotoEn(laPampa,rojo,25).
intencionDeVotoEn(laPampa,azul,25).
intencionDeVotoEn(laPampa,amarillo,40).
intencionDeVotoEn(corrientes,rojo,30).
intencionDeVotoEn(corrientes,azul,30).
intencionDeVotoEn(corrientes,amarillo,10).
intencionDeVotoEn(misiones,rojo,90).
intencionDeVotoEn(misiones,azul,0).
intencionDeVotoEn(misiones,amarillo,0).

%==================  PUNTO 6  ==================

%promete(Partido,Promesa)
promete(azul,construir([edilicio(hospital,1000),edilicio(jardin,100),edilicio(escuela,5)])).
promete(azul,inflacion(2,4)).
promete(amarillo,construir([edilicio(hospital,100),edilicio(universidad,1),edilicio(comisaria,200)])).
promete(amarillo,nuevosPuestosDeTrabajo(10000)).
promete(amarillo,inflacion(1,15)).
promete(rojo,nuevosPuestosDeTrabajo(800000)).
promete(rojo,inflacion(10,30)).

%==================  PUNTO 2  ==================

esPicante(Provincia):-
			provincia(Provincia,Habitantes),
			Habitantes > 1000000,
			findall(Partido,(postulacion(Partido,Provincia)),Partidos),
			length(Partidos,Cant),
			Cant > 1.

%==================  PUNTO 3  ==================

leGanaA(Ganador,Perdedor,Provincia):-
			candidato(Ganador,_),candidato(Perdedor,_),provincia(Provincia,_),
			compiteEn(Ganador,Provincia,VotosGanador),
			compiteEn(Perdedor,Provincia,VotosPerdedor),
			VotosGanador \= VotosPerdedor ,
			VotosGanador > VotosPerdedor .
						
leGanaA(Ganador,Perdedor,Provincia):-
			candidato(Ganador,_),candidato(Perdedor,_),provincia(Provincia,_),
			compiteEn(Ganador,Provincia,_),
			not(compiteEn(Perdedor,Provincia,_)).
			
leGanaA(Ganador,Perdedor,Provincia):-
			candidato(Ganador,Partido),candidato(Perdedor,Partido),provincia(Provincia,_),
			compiteEn(Ganador,Provincia,_),
			compiteEn(Perdedor,Provincia,_).
			
compiteEn(Candidato,Provincia,Votos):-
		candidato(Candidato,CPartido),
		postulacion(CPartido,Provincia),
		intencionDeVotoEn(Provincia,CPartido,Votos).
		
%==================  PUNTO 4  ==================	
	
elGranCandidato(Candidato):-
		postulante(Candidato,CandidatoEdad),
		candidato(Candidato,PartidoDelGanador),
		candidato(Rivales,PartidoDelPerdedor),
		forall(postulacion(PartidoDelGanador,Provincias),(PartidoDelGanador \= PartidoDelPerdedor,Candidato \= Rivales,leGanaA(Candidato,Rivales,Provincias))),
		findall(Edad,(candidato(Compas,PartidoDelGanador),postulante(Compas,Edad),Edad \= CandidatoEdad),Edades),
		min_member(MenorEdadPartido,Edades),
		CandidatoEdad < MenorEdadPartido .
		

%==================  PUNTO 5  ==================

partidoGanaEnProvincia(Partido, Provincia,PorcentajeGanador):-
		intencionDeVotoEn(Provincia,Partido,_),
		findall(Porcentaje,intencionDeVotoEn(Provincia,_,Porcentaje),Porcentajes),
		intencionDeVotoEn(Provincia,Partido,PorcentajeGanador),
		max_member(PorcentajeGanador,Porcentajes).

ajusteConsultora(Partido, Provincia, VerdaderoPorcentaje):- 
		intencionDeVotoEn(Provincia, Partido, Porcentaje),
		not(partidoGanaEnProvincia(Partido, Provincia,_)),
		VerdaderoPorcentaje is Porcentaje + 5.

ajusteConsultora(Partido, Provincia, VerdaderoPorcentaje):-
		partidoGanaEnProvincia(Partido, Provincia,PorcentajeGanador),
		VerdaderoPorcentaje is PorcentajeGanador - 20.

%==================  PUNTO 7  ==================

influenciaDePromesa(inflacion(C1,C2),VariacionIntencionDeVotos):-
		promete(Partido,inflacion(C1,C2)),           
		VariacionIntencionDeVotos is (-((C1 + C2) / 2)).

influenciaDePromesa(nuevosPuestosDeTrabajo(Cant),VariacionIntencionDeVotos):-
		promete(Partido,nuevosPuestosDeTrabajo(Cant)),
    	Cant > 50000,
    	VariacionIntencionDeVotos is 3.

influenciaDePromesa(nuevosPuestosDeTrabajo(Cant),VariacionIntencionDeVotos):-
		promete(Partido,nuevosPuestosDeTrabajo(Cant)),
    	Cant < 50000,
    	VariacionIntencionDeVotos is 0.

influenciaDePromesa(construir(Lista),VariacionIntencionDeVotos):-
    	promete(Partido,construir(Lista)),
		maplist(valorarConstruccion,Lista,NewList),
		sum_list(NewList,VariacionIntencionDeVotos).
		
valorarConstruccion(edilicio(hospital,_),2).
valorarConstruccion(edilicio(jardin,Cantidad),Variacion):- Variacion is Cantidad * 0.1 .
valorarConstruccion(edilicio(escuela,Cantidad),Variacion):- Variacion is Cantidad * 0.1 .
valorarConstruccion(edilicio(comisaria,200),2).
valorarConstruccion(edilicio(comisaria,Cantidad),Variacion):- Cantidad \= 200, Variacion is 0 .
valorarConstruccion(edilicio(universidad,_),0).

%==================  PUNTO 8  ==================

crecimientoTotal(Partido,Sumatoria):-
    	intencionDeVotoEn(buenosAires,Partido,_),
		findall(Variacion,
				(promete(Partido,Promesa),influenciaDePromesa(promete(Partido,Promesa),Variacion)),Variaciones),
				sum_list(Variaciones,Sumatoria).

%==================  PUNTO 9  ==================

terna(Provincia, Candidatos):-
	provincia(Provincia,_),
	findall(Partido, postulacion(Partido, Provincia), Partidos),
	list_to_set(Partidos, PartidosSinRepetir),
	ternaDeCandidatos(PartidosSinRepetir, Candidatos),
	length(PartidosSinRepetir, NumeroPartidos), 
	length(Candidatos, NumeroCandidatos), NumeroPartidos = NumeroCandidatos.
   
   ternaDeCandidatos(_, []).
   ternaDeCandidatos(Partidos, [Candidato | Candidatos] ):-
	select(Partido, Partidos, PartidosSinElemento), candidato(Candidato,Partido), 
	ternaDeCandidatos(PartidosSinElemento,Candidatos).

