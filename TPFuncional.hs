import Text.Show.Functions

data Planta = Planta {tipo::String, sol::Int, vida::Int, attack::Int} deriving (Show,Eq)

peashooter = Planta "PeaShooter" 0 5 (ataquePlanta 2 peashooter)
repeater = Planta "Repeater" 0 5 (ataquePlanta 4 repeater)
sunflower = Planta "SunFlower" 1 7 (ataquePlanta 0 sunflower)
nut = Planta "Nut" 0 100 (ataquePlanta 0 nut) 
cactus = Planta "Cactus" 0 9 (ataquePlanta 0 cactus)

ataquePlanta num planta = (nivelDeMuerte zombiebase) - (nivelDeMuerte.flip zombieAttacked zombiebase.plantaVieja num) planta
                               where plantaVieja num planta = planta {attack = num}

dañoZombie zombie = 30 + length (accesorios zombie)

dañoPaper zombie = sum (map length (accesorios zombie))

especialidad :: Planta -> String 
especialidad planta |((>=1).sol) planta ="Proveedora"
                    |((<2*(attack planta)).vida) planta = "Atacante"
                    |otherwise = "Defensiva"

data Zombies = Zombies{nombre::String, accesorios::[String], daño::Int} deriving (Show,Eq)

zombiebase = Zombies "Zombie" [] 1
ballonzombie = Zombies "Pepe Colgado" ["Globo"] 5
newspaperzombie = Zombies "Beto el chismoso" ["Diario"] (dañoPaper newspaperzombie)
gargantuar = Zombies "Gargantuar Hulk Smash Puny God" ["Poste", "Enano"] (dañoZombie gargantuar)


nivelDeMuerte :: Zombies -> Int
nivelDeMuerte zombie = (length.nombre) zombie

esPeligroso :: Zombies -> Bool
esPeligroso zombie = ((>1).(length.accesorios) )zombie || ((nivelDeMuerte zombie)>10)


 --Punto3--

data LineaDeDefensa = LineaDeDefensa{plantas::[Planta], zombies::[Zombies]} deriving (Show,Eq)

sunflowerRandom planta num = planta{sol = num} 

linea1 = LineaDeDefensa { plantas = [sunflowerRandom sunflower 5,sunflowerRandom sunflower 8,sunflowerRandom sunflower 7], zombies = [] }
linea2 = LineaDeDefensa { plantas = [peashooter, peashooter,sunflowerRandom sunflower 9, nut], zombies = [zombiebase, newspaperzombie] } 
linea3 = LineaDeDefensa { plantas = [sunflowerRandom sunflower 11, peashooter], zombies = [gargantuar, zombiebase, zombiebase] } 
linea4 = LineaDeDefensa { plantas = [peashooter], zombies = [zombiebase] }

determinarCantidad:: [lista] -> Int
determinarCantidad lista = (length lista)

agregarALista :: a -> [a] -> [a] 
agregarALista e [] = [e]
agregarALista e (x : xs) = x : agregarALista e xs

agregarZombieALinea zombie linea = linea{zombies = agregarALista zombie (zombies linea)} 

agregarPlantaALinea planta linea = linea{plantas = agregarALista planta (plantas linea)}

totalDeAtaque :: [Planta] -> Int
totalDeAtaque  = foldl facum 0
                 where facum acum = (+acum).attack  

totalDeMordiscos :: [Zombies] -> Int
totalDeMordiscos  = foldl facum 0
                 where facum acum = (+acum).daño

esLineaDeZombiesPeligrosos :: [Zombies] -> Bool
esLineaDeZombiesPeligrosos [] = False
esLineaDeZombiesPeligrosos lista = all esPeligroso lista

estaEnPeligro :: LineaDeDefensa -> Bool
estaEnPeligro linea = ((totalDeAtaque . plantas) linea < (totalDeMordiscos . zombies) linea) || ((esLineaDeZombiesPeligrosos . zombies) linea)

sonProveedoras :: [Planta] -> Bool
sonProveedoras  = all (=="Proveedora").map especialidad

necesitaSerDefendida :: LineaDeDefensa -> Bool
necesitaSerDefendida linea = (sonProveedoras . plantas) linea

--punto 4--

plantasMixtas :: [Planta] -> Bool
plantasMixtas [] = False
plantasMixtas [x] = False
plantasMixtas [x,y] = (especialidad x) /= (especialidad y)
plantasMixtas (x : xs) = (especialidad x /= especialidad (head xs)) && plantasMixtas xs


lineaMixta :: LineaDeDefensa -> Bool
lineaMixta linea = plantasMixtas (plantas linea)

--Punto 5-- modificada para la Entrega 2

zombieAttacked :: Planta -> Zombies -> Zombies
zombieAttacked planta zombie
  |tipo planta == "Cactus" && nombre zombie == "Pepe Colgado" = zombie{accesorios = [""], daño = 2}
  |tipo planta == "Nut" && daño zombie >= 1 = zombie{daño = (daño zombie - 1)}
  |otherwise = zombie{nombre = (drop (attack planta) (nombre zombie))}

plantaAttacked :: Zombies -> Planta -> Planta
plantaAttacked zombie planta = planta{vida = ((vida planta)-(daño zombie))}

----  ENTREGA 2   ----------------------------

-- Punto 3 --

consultarCondicion func cond linea = filter (cond.func) (plantas linea)

--Punto 4 --

type Jardin = [LineaDeDefensa]

miJardin = [linea1, linea2, linea3, linea4]


navidadZombie artefacto jardin = map otorgarArtefacto jardin
  where otorgarArtefacto linea = linea {zombies = agregarAccesorio artefacto (zombies linea)}


agregarAccesorio artefacto lista = map (agregarArt artefacto) lista

agregarArt artefacto zombie = zombie {accesorios = agregarALista artefacto (accesorios zombie), daño = daño zombie + length artefacto}



catenaccio jardin = map agregarMuralla jardin
  where agregarMuralla linea = agregarPlantaALinea nut linea



regar num cond jardin = map darVida jardin
   where darVida linea = linea{plantas = agregarVida num cond (plantas linea)}

agregarVida num cond plantas = map funcPlant plantas
   where funcPlant planta
          |cond planta = planta{vida = num + (vida planta)}
          |otherwise = planta


vidaImpar planta = (odd.vida) planta

potenciarJardin jardin potenciadores = foldr ($) jardin potenciadores

-- Punto 5 --

mostValuablePlant :: Ord a => (Planta -> a) -> Planta -> Planta -> Planta
mostValuablePlant fun planta1 planta2
  |fun planta1 > fun planta2 = planta1
  |otherwise = planta2

mvpLista :: Ord a => (Planta -> a) -> [Planta] -> Planta
mvpLista func plantas = foldl (mostValuablePlant func) (head plantas) plantas

-- Punto 6 --

ataqueCompleto :: LineaDeDefensa -> LineaDeDefensa
ataqueCompleto linea = (limpieza.atacaPrimerZom.atacanPlantas) linea

atacanPlantas linea = linea {zombies = (foldl (flip zombieAttacked) (head (zombies linea)) (plantas linea)) : (drop 1 (zombies linea))}

atacaPrimerZom linea 
  |nivelDeMuerte (head (zombies linea)) > 0 = linea {plantas = (init.plantas)linea ++ [plantaAttacked ((head.zombies) linea) ((last.plantas)linea)] }
  |otherwise = linea

limpieza linea = linea {zombies = filter ((>0).nivelDeMuerte) (zombies linea),
                        plantas = filter ((>0).vida) (plantas linea)}

ataqueMasivo :: LineaDeDefensa -> LineaDeDefensa
ataqueMasivo linea 
  |(zombies linea) == [] = linea  
  |(plantas linea) == [] = linea
  |otherwise = (ataqueMasivo.ataqueCompleto) linea


theZombiesAteYourBrains :: Jardin -> Bool
theZombiesAteYourBrains jardin = any sinPlantas jardinAtaqueMasivo
  where jardinAtaqueMasivo = map ataqueMasivo jardin
sinPlantas linea = plantas linea == []