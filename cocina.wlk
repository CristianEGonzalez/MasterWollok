object paella{
    //se puede hacer con mariscos o Sin maricos
    method esVegetariana() = not hayMariscos
    var hayMariscos = true    
    method puntosOtorgados() = if (hayMariscos) 8 else 6

    method ingresanMariscos(){
        hayMariscos = true
    }
    method agotoMariscos(){
        hayMariscos = false
    }
}

object risotto{
    var ingredientePrincipal = hongos
    
    method esVegetariana() = ingredientePrincipal.esVegetariano()
    method puntosOtorgados() = ingredientePrincipal.puntos()

    method cambiarIngredientePrincipal(ingr){
        ingredientePrincipal= ingr
    }

}

///ingredientes principales
object hongos{
    var esPrimavera = false
    method puntos() =  if (esPrimavera) 16 else 12
    method esVegetariano() = true

    method cambiarTemporada(){
        esPrimavera= not esPrimavera
    }
}

object pollo{
    method puntos() = 8
    method esVegetariano() = false
}

object ensalada{
    method esVegetariana() = true
    method puntosOtorgados() = 10
}

////CHEF:

object paulina{
    const recetasConocidas = [ensalada, risotto]
    var puntosAcumulados = 0
    method puntosAcumulados() = puntosAcumulados
    // siempre puede cocinar
    method puedeCocinar(receta) = self.conoceReceta(receta)

    method cocinar(receta){
        if (self.puedeCocinar(receta)){
            puntosAcumulados = puntosAcumulados + self.puntosVegetariana(receta)
        }
    }

    method puntosVegetariana(receta) { 
        if(receta.esVegetariana()) 
            return receta.puntosOtorgados()*2
        else 
            return receta.puntosOtorgados()/2
    }

    method conoceReceta(receta) = recetasConocidas.contains(receta) 
    
    // solo puede aprender receta si esta es vegetariana
    method aprenderReceta(nuevaReceta){
        if(!self.conoceReceta(nuevaReceta) && nuevaReceta.esVegetariana())
            recetasConocidas.add(nuevaReceta)
    }
}

object remy{
    const recetasConocidas = [risotto, paella]
    var puntosAcumulados = 0
    var estaRatatouille = true
    method puntosAcumulados() = puntosAcumulados
    //puede cocinar si conoce 2 o mas recetas y tiene los creditosRequeridos
    method puedeCocinar(receta){ 
        return recetasConocidas.size()>=2 && self.conoceReceta(receta)
    }

    method cocinar(receta){
        if (self.puedeCocinar(receta)){
            puntosAcumulados = puntosAcumulados + receta.puntosOtorgados() + self.puntosConRatatouille()
        }
    }

    method puntosConRatatouille() = if(estaRatatouille) 5 else 0 

    method conoceReceta(receta) = recetasConocidas.contains(receta)

    method aprenderReceta(nuevaReceta){
        if(!self.conoceReceta(nuevaReceta))
            recetasConocidas.add(nuevaReceta)
    }

    method ratatouilleSeVa(){
        estaRatatouille = false
    }
    method ratatouilleLlega(){
        estaRatatouille = true
    }
}

object christof{
    //solo puede conocer una receta, cuando aprende una nueva se olvida la anterior
    var recetaConocida = paella
    var cantidadAyudantes = 2
    var puntosAcumulados = 0
    method puntosAcumulados() = puntosAcumulados
    //puede cocinar cuando la cantidad de ayudantes es par y no supere los 200 puntos acumulados 
    method puedeCocinar(receta){ 
        return cantidadAyudantes.even() && puntosAcumulados<200 && self.conoceReceta(receta)
    }

    method cantidadAyudantes() = cantidadAyudantes

    //cada vez que aprende una receta recibe un ayudante nuevo
    method aprenderReceta(nuevaReceta){
        if (!self.conoceReceta(nuevaReceta)){
            recetaConocida = nuevaReceta
            cantidadAyudantes = cantidadAyudantes + 1
        }
    }

    //se le suman los puntos otorgados por la receta pero se le restan 2 por cada ayudante
    method cocinar(receta){
        if (self.puedeCocinar(receta)){
            puntosAcumulados = puntosAcumulados + receta.puntosOtorgados() + (cantidadAyudantes*2)
        }
    }

    method conoceReceta(receta) = (receta == recetaConocida)
}

////Concurso
object concurso{
    const concursantes = [paulina, remy, christof]
    const recetas = [paella, risotto, ensalada]

    
//PREPARACION
    method prepararConcurso(){
        paella.agotoMariscos()
        risotto.cambiarIngredientePrincipal(hongos)
        hongos.cambiarTemporada()
    }

//CONCURSO
    //Todos aprenden una receta
    method aprenderReceta(receta){
        concursantes.forEach({c => 
            c.aprenderReceta(receta)
        })
    }

    //mandar a cocinar todas las recetas
    method cocinarReceta(receta){
        //recetas.forEach({r => self.aCocinar(r)})
        concursantes.forEach({c => c.cocinar(receta)})
    }

    method ganador(){
        return concursantes.max({c=> c.puntosAcumulados()})
    }

//CONSULTAS
    //indicar si hay un chef nivel experto (con mas de 450 puntos)
    method hayChefExperto(){
        return concursantes.any({c => c.puntosAcumulados() > 450 })
    }

    //la receta vegetariana que mas puntos otorga
    method recetaVegetarianaConMasPuntos(){
        return self.recetasVegetarianas().max({r => r.puntosOtorgados()})
    }

    //método auxiliar
    method recetasVegetarianas(){
        return recetas.filter({r => r.esVegetariana()})
    }

    //contar cantidad de chef que puede realizar X receta
    method cantidadChefQueCocinan(receta){
        return concursantes.count({r => r.puedeCocinar(receta)})
    }

    // mapear los puntos que otorga cada receta para obtener una lsita de puntos
    method listaDePuntos(){
        return recetas.map({r => r.puntosOtorgados()})
    }

}