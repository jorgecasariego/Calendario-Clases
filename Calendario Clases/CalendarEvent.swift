//
//  CalendarEvent.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 23/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import Foundation

class CalendarEvent {
    let materia         : String
    let profesor        : String
    let dia             : Int
    let horaInicio      : Int
    let horaInicioString: String
    let duracionEnHoras : Int
    let horaSalida      : Int
    let horaSalidaString: String
    
    init(materia: String, profesor: String, dia: Int, horaInicio: Int, horaInicioString: String, duracionEnHoras: Int, horaSalida: Int, horaSalidaString: String) {
        self.materia = materia
        self.profesor = profesor
        self.dia = dia
        self.horaInicio = horaInicio
        self.horaInicioString = horaInicioString
        self.duracionEnHoras = duracionEnHoras
        self.horaSalida = horaSalida
        self.horaSalidaString = horaSalidaString
    }
}