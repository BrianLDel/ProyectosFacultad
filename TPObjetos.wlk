object hoy{
	const hoy = new Date()
	
	method anio(){
		return hoy.year()
	}
}

class Gobierno{
	const property ciudad;
	const property pais;
	
	method puedeParticipar(bandas){
		return bandas.all{banda=>self.bandaApta(banda)}
	}
	
	method bandaApta(banda) = banda.nacionalidad() == pais
	
	method noAptaError(){
		self.error("La banda no corresponde al pais.")
	}
}

class Discografica{
	
	method bandaApta(banda) = banda.discos().any({disco=>disco.discografica() == self})
	
	method puedeParticipar(bandas){
		return bandas.all{banda=>self.bandaApta(banda)}
	}
	
	method noAptaError(){
		self.error("La discografica no produce discos de esa banda")
	}	
}
const EMI = new Discografica()

const Warner = new Discografica()

const Elektra = new Discografica()


class Sede{
	const sede;
	const property capacidad;
	var ciudad;
	var eventos=[];
	var historialEventos = [];
	
	method agregarEvento(evento){
		if(evento.sePuedeHacerEn(self)){
			eventos.add(evento)
		}
	}
	
	method sePuedeHacerRecital() = true
	
	method sePuedeHacerFestival()
	
	method sePuedeHacerCena()
	
	
	method conjuntoDeBandas(){
		return eventos.flatMap({evento=>evento.bandas()}).asSet()
	}
	
	method conjuntoDeBandasExtranjeras(){
		return self.conjuntoDeBandas().filter{banda=>banda.esExtranjera(ciudad.pais())}
	}
}

class Estadio inherits Sede{
	
	const property costoAlquilerFijo;
	
	override method sePuedeHacerFestival() = true
	
	override method sePuedeHacerCena() = false
	
	method costoAlquiler(evento){
		return costoAlquilerFijo * (evento.duracion()/60)
	}
}

class Anfiteatro inherits Sede{
	
	const costoEvento;
	var property generosEnPromocion=#{}
	
	override method sePuedeHacerFestival() = false
	
	override method sePuedeHacerCena() = true
	
	method costoAlquiler(evento){
		if(evento.generosEvento().any({g=>generosEnPromocion.contains(g)})){
			return costoEvento - costoEvento*0.2
		}else{
			return costoEvento
		}
	}
}

class Festival{
	var property bandas = #{};
	var property generosIndicado= #{};
	const property precioDeEntrada=0;
	const property financiamientoInicial=0;
	var property auspiciantes=[];
	var bandaDeCierre=null;
	
	method importeDelEvento(){
		return	auspiciantes.sum{aus=>aus.aporte()}
	}
	
	method gastosBasicos(){
		return bandaDeCierre.cachet() + self.gastosBandasSinBndCierre()
	}
	
	method gastosBandasSinBndCierre() = bandas.remove(bandaDeCierre).sum({b=>(b.cachet()*0.5)})
	
	method ingresoAsegurado() = self.importeDelEvento() + financiamientoInicial
	
	method esBandaDeCierre(banda){
		return bandas == #{}
	}
	
	method esEconomicamenteFactible() = self.ingresoAsegurado() > self.gastosBasicos()
	
	method rockstar(){
		return self.bandaPrincipal().lider()
	}
	
	method duracion(){
		return bandas.sum{banda=>banda.duracionConcierto()}
	}
	
	method esGeneroAceptado(banda){
		return banda.generos().any{genero=>generosIndicado.contains(genero)}
	}
	
	method sePuedeAgregarBanda(banda){
		return (self.duracion()+banda.duracionConcierto() <= 720) && (self.esGeneroAceptado(banda))
	}
	
	method agregarBanda(banda){
		if(!self.sePuedeAgregarBanda(banda)){
			self.error("No se puede agregar banda")
		}
		else{
			if(self.esBandaDeCierre(banda)){
				bandaDeCierre = banda
				bandas.add(banda)
			}else{
				bandas.add(banda)
			}
		}
	}
	
	method generosEvento(){
		if(bandas == #{}){
			self.error("No hay ninguna banda para determinar el genero del evento")
		}
			return self.bandaPrincipal().generos()
	}
	
	method bandaPrincipal(){
		return bandas.max({banda=>banda.discosVendidos()})
	}
	
	method esLargo(){
		return self.duracion()>540
	}
	
	method sePuedeHacerEn(sede){
		return sede.sePuedeHacerFestival()
	}
	
	method cantBandas() = bandas.size()
	
	method incluyeGenero(genero){
		return self.bandaPrincipal().generos().contains(genero) ||
		bandas.all{banda=>banda.generos().contains(genero)}
	}
}

class FestivalOrganizado inherits Festival{
	var organizador;
	
	override method sePuedeAgregarBanda(banda){
		return super(banda) && organizador.bandaApta(banda)
	}

	override method agregarBanda(banda){
		if(!self.sePuedeAgregarBanda(banda)){
			organizador.noAptaError()
		}else{
			bandas.add(banda)
		}
	}
	
	override method sePuedeHacerEn(sede){
		return super(sede) && organizador.puedeParticipar(bandas)
	}
	
	method porcentajeCopiasVendidas(unaBanda){
		if(unaBanda.esExtranjera(organizador.pais())){
			return unaBanda.discosVendidos()*0.15
		}else{
			return unaBanda.discosVendidos()*0.25
		}
	}
	
	method indiceDeExitoPotencial(){
		return bandas.sum({b=>self.porcentajeCopiasVendidas(b)})
	}
}


class Recital{
	var property bandaPrincipal=null;
	var property bandasSoporte = #{};
	const property precioDeEntrada=0;
	const property financiamientoInicial=0;
	const property importeDelEvento = 45000
	
	method gastosBasicos(sede) = bandaPrincipal.cachet() +(sede.costoAlquiler(self) / 2) 
	
	method ingresoAsegurado() = importeDelEvento + financiamientoInicial
	
	method esEconomicamenteFactible(sede) = self.ingresoAsegurado() > self.gastosBasicos(sede)
	
	method rockstar() = bandaPrincipal.lider()
	
	method duracion(){
		return bandaPrincipal.duracionConcierto() + bandasSoporte.sum{banda=>banda.duracionConcierto()}
	}
	
	method sePuedeAgregarBanda(banda){
		return (bandasSoporte == #{}) || banda.generos().any{genero=>bandaPrincipal.generos().contains(genero)}
	}

	method agregarBanda(banda){
		if(!self.sePuedeAgregarBanda(banda)){
			self.error("No se puede agregar banda")
		}else{
			if(bandaPrincipal != null){
				bandasSoporte.add(banda)
			}else{
				bandaPrincipal = banda
			}
		}
	}
	
	method principalVendioMasQue(banda){
		return (bandaPrincipal.discosVendidos()) > (3*banda.discosVendidos())
	}
	
	method bandaPrincipalApta(){
		return bandasSoporte.any{banda=>self.principalVendioMasQue(banda)}
	}
	
	method esLargo(){
		return bandasSoporte.all{banda=>banda.duracionConcierto()>=40} && bandaPrincipal.duracionConcierto()>=40
	}
	method incluyeGenero(genero){
		return bandaPrincipal.generos().contains(genero)
	}
	
	method bandas(){
		var list = #{}
		list.add(bandaPrincipal)
		list.addAll(bandasSoporte)
		return list
	}

	method generosEvento(){
		if(bandaPrincipal == null){
			self.error("No hay ninguna banda para determinar el genero del evento")
		}
			return bandaPrincipal.generos()
	}
	
	method sePuedeHacerEn(sede) = true
}

class RecitalOrganizado inherits Recital{
	var organizador;
	
	override method sePuedeAgregarBanda(banda){
		return super(banda) && organizador.bandaApta(banda)
	}
	
	override method agregarBanda(banda){
		if(!self.sePuedeAgregarBanda(banda)){
			organizador.noAptaError()
		}else{
			if(bandaPrincipal != null){
				bandasSoporte.add(banda)
			}else{
				bandaPrincipal = banda
			}
		}
	}
	
	override method sePuedeHacerEn(sede){
		return super(sede) && organizador.puedeParticipar(self.bandas())
	}
	
	method porcentajeCopiasVendidas(unaBanda){
		if(unaBanda.esExtranjera(organizador.pais())){
			return unaBanda.discosVendidos()*0.15
		}else{
			return unaBanda.discosVendidos()*0.25
		}
	}
	
	method indiceDeExitoPotencial(){
		return self.bandas().sum({b=>self.porcentajeCopiasVendidas(b)})
	}
}

class RecitalCuidadNoOrg inherits Recital{}

class CenaShow{
	const property bandaPrincipal=null;
	const precioPorEntrada=0;
	const financiamientoInicial=0;
	
	method importeDelEvento(sede) = (sede.capacidad() * precioPorEntrada)/2
	
	method gastosBasicos() = (bandaPrincipal.cachet()*0.8) + 80000
	
	method ingresoAsegurado(sede) = financiamientoInicial + self.importeDelEvento(sede)
	
	method esEconomicamenteFactible(sede) = self.ingresoAsegurado(sede) > self.gastosBasicos()
	
	method esLargo() = false;
	
	method duracion() = bandaPrincipal.duracionConcierto()
	
	method sePuedeHacerEn(sede){
		return sede.sePuedeHacerCena()
	}
	
	method incluyeGenero(genero){
		return bandaPrincipal.generos().contains(genero)
	}
	
	method generosEvento(){
		if(bandaPrincipal == null){
			self.error("No hay ninguna banda para determinar el genero del evento")
		}
			return bandaPrincipal.generos()
	}
	
	method bandas() = bandaPrincipal
	
}

class CenaShowOrganizado inherits CenaShow{
	var organizador;
	
	override method sePuedeHacerEn(sede){
		return super(sede) && organizador.bandaApta(bandaPrincipal)
	}
}

class Disco {
	const property nombre;
	const property duracion;
	var property anio;
	var property copiasVendidas;
	const property discografica;

}

class BandaFundacional{
	var property generos;
	const property fundacion;
	var property discos;
	const property integrantesOriginales;
	const property integrantesActuales;
	var property cachet;
	var property nacionalidad;
	
	method lider(){
		return integrantesActuales.head()
	}
	
	method esExtranjera(pais) = nacionalidad != pais
	
	method duracionConcierto(){
		if(integrantesActuales.size() > integrantesOriginales.size()){
			return 40+10*(integrantesActuales.size() - integrantesOriginales.size())
		}else{
			return 40-10*(integrantesActuales.size() - integrantesOriginales.size())
		}
	}
	
	method edad(){
		return hoy.anio() - fundacion
	}
	
	method discosVendidos(){
		return discos.sum{disco=>disco.copiasVendidas()}
	}
	
	method ultimoDisco(){
		return discos.max({disco=>disco.anio()})
	}
}

class BandaDisquera{
	var property generos;
	var property miembros;
	var property discos;
	var property cachet;
	var property nacionalidad;
	
	method lider(){
		return miembros.head()
	}
	
	method esExtranjera(pais) = nacionalidad != pais
	
	method duracionConcierto(){
		const discoMasLargo = discos.max({disco=>disco.duracion()})
		return discoMasLargo.duracion()
	}
	
	method edad(){
		const menorAnio = discos.min({e=>e.anio()})
		return hoy.anio() - menorAnio.anio()
	}
	
	method discosVendidos(){
		return discos.sum{disco=>disco.copiasVendidas()}
	}
	
	method ultimoDisco(){
		return discos.max({e=>e.anio()})
	}
	
	method discoMasTaquillero(){
		return discos.max({disco=>disco.copiasVendidas()})
	}
}
class BandaEstructurada{
	var property generos;
	var property edad;
	var property miembros;
	var property discos;
	const property duracionConcierto = 60
	var property cachet;
	var property nacionalidad;
	
	method lider(){
		return miembros.head()
	}
	
	method esExtranjera(pais) = nacionalidad != pais
	
	method discosVendidos(){
		return discos.sum{disco=>disco.copiasVendidas()}
	}
	
	method ultimoDisco(){
		return discos.max({disco=>disco.anio()})
	}
}

const ten = new Disco(
	nombre="Ten",
	duracion=53,
	anio=1991,
	copiasVendidas=11000000,
	discografica = Elektra
)

const vs = new Disco(
	nombre="Vs",
	duracion=46,
	anio=1993,
	copiasVendidas=2000000,
	discografica = Elektra
)

const noCode = new Disco(
	nombre="No Code",
	duracion=49,
	anio=1996,
	copiasVendidas=3000000,
	discografica = Elektra
)

const riotAct = new Disco(
	nombre="Riot Act",
	duracion=54,
	anio=2002,
	copiasVendidas=1500000,
	discografica = Elektra
)

const backSpacer = new Disco(
	nombre="Backspacer",
	duracion=36,
	anio=2009,
	copiasVendidas=2000000,
	discografica = EMI
)

const esquivandoCharcos = new Disco(
	nombre="Esquivando Charcos",
	duracion=40,
	anio=1991,
	copiasVendidas=300000,
	discografica = Warner
)

const despedazadopormilpartes = new Disco(
	nombre="Despedazado por mil partes",
	duracion=54,
	anio=1996,
	copiasVendidas=1300000,
	discografica = Elektra
)

const laRengaDisc = new Disco(
	nombre= "La Renga",
	duracion=41,
	anio=1998,
	copiasVendidas=1000000,
	discografica = EMI
)

const ironMaidenDisc = new Disco(
	nombre= "Iron Maiden",
	duracion=40,
	anio=1980,
	copiasVendidas=2000000,
	discografica = EMI
)

const theNumberOfTheBeast = new Disco(
	nombre= "The Number Of The Beast",
	duracion=40,
	anio=1982,
	copiasVendidas=14000000,
	discografica = EMI
)

const powerSlave = new Disco(
	nombre= "Powerslave",
	duracion=50,
	anio=1984,
	copiasVendidas=3000000,
	discografica = EMI
)

const someWhere = new Disco(
	nombre= "Somewhere",
	duracion=51,
	anio=1986,
	copiasVendidas=2500000,
	discografica = EMI
)

const braveNewWorld = new Disco(
	nombre= "Brave New World",
	duracion=66,
	anio=2000,
	copiasVendidas=6000000,
	discografica = EMI
)

const theBookOfSouls = new Disco(
	nombre= "The Book Of Souls",
	duracion=92,
	anio=2015,
	copiasVendidas=3000000,
	discografica = EMI
)

const rhcp = new Disco(
	nombre="The Red Hot Chili Peppers",
	duracion=32,
	anio=1984,
	copiasVendidas=500000,
	discografica = EMI
)

const californication = new Disco(
	nombre="Californication",
	duracion=56,
	anio=1999,
	copiasVendidas=16000000,
	discografica = Warner
)

const stadiumArcadium = new Disco(
	nombre="Stadium Arcadium",
	duracion=122,
	anio=2006,
	copiasVendidas=10000000,
	discografica = Warner
)

const theGateway = new Disco(
	nombre="The Gateway",
	duracion=53,
	anio=2006,
	copiasVendidas=1000000,
	discografica = Warner
)

const killingIsMyBusiness = new Disco(
	nombre="Killing Is My Business... And Business Is Good!",
	duracion=31,
	anio=1986,
	copiasVendidas=1000000,
	discografica = EMI
)

const rustInPeace = new Disco(
	nombre="Rust In Peace",
	duracion=40,
	anio=1990,
	copiasVendidas=1400000,
	discografica = Warner
)

const countdownToExtinction = new Disco(
	nombre="Countdown To Extinction",
	duracion=47,
	anio=1991,
	copiasVendidas=2000000,
	discografica = Warner
)

const youthanasia = new Disco(
	nombre="Youthanasia",
	duracion=50,
	anio=1994,
	copiasVendidas=2600000,
	discografica = Warner
)

const killEmAll = new Disco(
	nombre="Kill 'Em All",
	duracion=51,
	anio=1983,
	copiasVendidas=7000000,
	discografica = Elektra
)

const masterOfPuppets = new Disco(
	nombre="Master Of Puppets",
	duracion=54,
	anio=1986,
	copiasVendidas=8000000,
	discografica = EMI
)

const metallicaDisc = new Disco(
	nombre="Metallica",
	duracion=62,
	anio=1991,
	copiasVendidas=10000000,
	discografica = Elektra
)

const reLoad = new Disco(
	nombre="ReLoad",
	duracion=76,
	anio=1997,
	copiasVendidas=3000000,
	discografica = Elektra
)

const fooFightersDisc = new Disco(
	nombre="Foo Fighters",
	duracion=44,
	anio=1995,
	copiasVendidas=1000000,
	discografica = Warner
)

const theColourAndTheShape = new Disco(
	nombre="The Colour And The Shape",
	duracion=46,
	anio=1997,
	copiasVendidas=2400000,
	discografica = Warner
)

const echoes = new Disco(
	nombre="Echoes, Silence, Patience & Grace",
	duracion=51,
	anio=2007,
	copiasVendidas=1000000,
	discografica = Warner
)

const concreteAndGold = new Disco(
	nombre="Concrete And Gold",
	duracion=48,
	anio=2017,
	copiasVendidas=1000000,
	discografica = Warner
)

const pearlJam = new BandaFundacional(
	
	generos=["grunge","rockAlternativo"],
	fundacion=1990,
	integrantesOriginales=["Eddie Vedder","Mike McCready","Stone Gossard",
	"Jeff Ament"],
	integrantesActuales=["Eddie Vedder","Mike McCready","Stone Gossard",
	"Jeff Ament","Matt Cameron","Boom Gaspar"],
	discos=[ten,vs,noCode,riotAct,backSpacer],
	nacionalidad="USA",
	cachet=32000
)

const laRenga = new BandaDisquera(
	generos=["Heavy Metal","Hard Rock"],
	miembros=["Chizzo","Gabriel Iglesias","Jorge Iglesias","Manuel Varela"],
	discos=[esquivandoCharcos,despedazadopormilpartes,laRengaDisc],
	nacionalidad="Argentina",
	cachet=20000
)

const ironMaiden = new BandaFundacional(
	generos=["Heavy Metal"],
	fundacion=1975,
	integrantesOriginales=["Steve Harris", "Paul Di'Anno", "Dave Murray", "Dennis Stratton", "Clive Burr"],
	integrantesActuales=["Steve Harris", "Dave Murray", "Bruce Dickinson", "Nicko McBrain", "Adrian Smith", "Janick Gers"],
	discos=[ironMaidenDisc,theNumberOfTheBeast,powerSlave,someWhere,braveNewWorld,theBookOfSouls],
	nacionalidad="United Kingdom",
	cachet=30000
)

const redHotChilliPeppers = new BandaEstructurada(
	generos=["Rock Alternativo","Funk Metal","Hard Rock"],
	edad=36,
	miembros=["Anthony Kiedis", "Michael Flea Balzary", "Chad Smith", "Josh Klinghoffer"],
	discos=[rhcp,californication,stadiumArcadium,theGateway],
	nacionalidad="USA",
	cachet=22000
)

const megadeth = new BandaFundacional(
	generos=["Trash Metal","Heavy Metal"],
	fundacion=1983,
	integrantesOriginales=["Dave Mustaine", "David Ellefson", "Greg Hardevidt", "Lee Rausch"],
	integrantesActuales=["Dave Mustaine", "David Ellefson", "Kiko Loureiro", "Dirk Verveuren"],
	discos=[killingIsMyBusiness,rustInPeace,countdownToExtinction,youthanasia],
	nacionalidad="USA",
	cachet=28000
)

const metallica = new BandaEstructurada(
	generos=["Heavy Metal","Trash Metal"],
	edad=38,
	miembros=["James Hetfield","Lars Ulrich","Kirk Hammet","Robert Trujillo"],
	discos=[killEmAll,masterOfPuppets,metallicaDisc,reLoad],
	nacionalidad="USA",
	cachet=39000
)

const fooFighters = new BandaFundacional(
	generos=["Hard Rock","Post Grunge"],
	fundacion=1994,
	integrantesOriginales=["Dave Grohl", "Pat Smear", "Nate Mendel", "William Goldsmith"],
	integrantesActuales=["Dave Grohl", "Pat Smear", "Nate Mendel", "Taylor Hawkins", "Chris Shiflett", "Rami Jaffee"],
	discos=[fooFightersDisc,theColourAndTheShape,echoes,concreteAndGold],
	nacionalidad="USA",
	cachet=28000
)

//no inicio finanIni y Auspi
const pDePalooza = new Festival(
	bandas=#{ironMaiden, metallica, pearlJam},
	generosIndicado=#{"Heavy Metal", "grunge"}
)
//no inicio financiIni
const recitalMegadeth = new Recital(
	bandaPrincipal=megadeth,
	bandasSoporte=#{laRenga},
	financiamientoInicial=3000
)
//no inicio finanIni y auspi.era festival normal
const monstersOfRock = new FestivalOrganizado(
	bandas=#{ironMaiden, metallica, megadeth,laRenga},
	generosIndicado=#{"Heavy Metal", "grunge"},
	organizador=buenosAires
)

const monsterOfRockBA = new FestivalOrganizado(
	organizador=buenosAires,
	bandas=#{metallica, megadeth, laRenga},
	generosIndicado=#{"Heavy Metal", "grunge"}
)
//43 no inicio finanIni
const recitalRHCP = new Recital(
	bandaPrincipal=redHotChilliPeppers,
	bandasSoporte=#{laRenga},
	financiamientoInicial=2000
)
//no inicio precio por entrada y finanIni.era cenashow normal
const cenaShowFooFighters = new CenaShowOrganizado(
	bandaPrincipal=fooFighters,
	financiamientoInicial=3000,
	precioPorEntrada=300,
	organizador=Warner
)
//no inicio finanIni
const recitalMaiden = new Recital(
	bandaPrincipal=ironMaiden,
	bandasSoporte=#{laRenga}
)

const estadioVelez = new Estadio(
	sede="Estadio Velez",
	capacidad=55000,
	ciudad="Buenos Aires",
	eventos=[pDePalooza,monstersOfRock],
	costoAlquilerFijo=90000
)

const lunaPark = new Estadio(
	sede="Luna Park",
	capacidad=10000,
	ciudad=buenosAires,
	eventos=[recitalMegadeth,recitalMaiden],
	costoAlquilerFijo=30000
)

const anfiteatroCentenario = new Anfiteatro(
	sede="Anfiteatro Parque Centenario",
	capacidad=1600,
	ciudad=buenosAires,
	eventos=[recitalRHCP],
	costoEvento=50000,
	generosEnPromocion=#{"Hard Rock","Heavy Metal"}
)

const parqueCentenario = new Anfiteatro(
	sede="Anfiteatro Parque Centenario",
	capacidad=1600,
	ciudad=buenosAires,
	eventos=[recitalMegadethEmi],
	costoEvento=50000
)

const recitalMegadethEmi = new RecitalOrganizado(
	organizador = EMI,
	bandaPrincipal=megadeth
)

const recitalIncog = new RecitalOrganizado(
	organizador=buenosAires,
	bandaPrincipal=laRenga,
	bandasSoporte=#{ironMaiden}
)

const buenosAires = new Gobierno(
	ciudad="Buenos Aires",
	pais="Argentina"
)
class Auspiciante{
	var property aporte;
}

const empresaA = new Auspiciante(
	aporte=60000
)

const empresaB = new Auspiciante(
	aporte=20000
)

const empresaC = new Auspiciante(
	aporte=120000
)

object festival{
	
	method crear() = new Festival()
}

object recital{
	
	method crear() = new Recital()
}

object cenaShow{
	
	method crear() = new CenaShow()
}


