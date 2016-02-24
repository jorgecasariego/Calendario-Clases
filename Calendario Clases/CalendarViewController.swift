//
//  CalendarViewController.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 23/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import UIKit
import Sapporo

/*
    Como usar intervalo de tiempo

    let time = Time(startHour: 8, intervalMinutes: 30, endHour: 23)
    print(time.timeRepresentations)

    let time = Time(startHour: 8, intervalMinutes: 30, endHour: 23)

    let ranges = time.timeRepresentations.enumerate().flatMap { index, value -> String? in
        if index + 1 < time.timeRepresentations.count {
            return value + " - " + time.timeRepresentations[index + 1]
        }
    
        return nil
    }
*/

enum CalendarHeaderType: String {
    case Day    = "DayHeaderView"
    case Hour   = "HourHeaderView"
}

class CalendarViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var sapporo: Sapporo = { [unowned self] in
        return Sapporo(collectionView: self.collectionView)
        }()
    
    let time = Time(startHour: 7, intervalMinutes: 30, endHour: 21)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sapporo.delegate = self
        sapporo.registerNibForClass(CalendarEventCell)
        sapporo.registerNibForSupplementaryClass(CalendarHeaderView.self, kind: CalendarHeaderType.Day.rawValue)
        sapporo.registerNibForSupplementaryClass(CalendarHeaderView.self, kind: CalendarHeaderType.Hour.rawValue)
        
        
        print("Tiempos: \(time.timeRepresentations)")
        
        let layout = CalendarLayout()
        sapporo.setLayout(layout)
        
        let randomEvent = { () -> CalendarEvent in
            let randomID = arc4random_uniform(10000)
            let materia = "Materia \(randomID)"
            let profesor = "Profesor \(randomID)"
            
            let randomDay = Int(arc4random_uniform(7))
            let randomStartHour = Int(arc4random_uniform(20))
            let randomDuration = Int(arc4random_uniform(5) + 1)
            let randomFinishtHour = randomStartHour + randomDuration
            
            print("Materia: \(materia)")
            print("Hora Inicio: \(randomStartHour) - Hora Inicio String: \(self.time.timeRepresentations[randomStartHour])")
            print("Duracion: \(randomDuration)")
            print("Hora Salida: \(randomFinishtHour) - Hora Salida String: \(self.time.timeRepresentations[randomFinishtHour])")
            print("")
            print("")
            
            return CalendarEvent(materia: materia, profesor: profesor, dia: randomDay, horaInicio: randomStartHour, horaInicioString: self.time.timeRepresentations[randomStartHour], duracionEnHoras: randomDuration, horaSalida: randomFinishtHour, horaSalidaString: self.time.timeRepresentations[randomFinishtHour])
        }
        
        let cellmodels = (0...5).map { _ -> CalendarEventCellModel in
            let event = randomEvent()
            return CalendarEventCellModel(event: event) { _ in
                print("Materia seleccionada: \(event.materia)")
            }
        }
        
        sapporo[0].append(cellmodels)
        sapporo.bump()
        
        
        
    }
}

extension CalendarViewController: SapporoDelegate {
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CalendarHeaderType.Day.rawValue {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CalendarHeaderView.reuseIdentifier, forIndexPath: indexPath) as! CalendarHeaderView
            
            switch (indexPath.item)
            {
            case 0:
                view.titleLabel.text = "Lunes"
                
            case 1:
                view.titleLabel.text = "Martes"
                
            case 2:
                view.titleLabel.text = "Miercoles"
                
            case 3:
                view.titleLabel.text = "Jueves"
                
            case 4:
                view.titleLabel.text = "Viernes"
                
            case 5:
                view.titleLabel.text = "Sabado"
                
            default:
                view.titleLabel.text = "Domingo"
            }
            
            
            return view
        }
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CalendarHeaderView.reuseIdentifier, forIndexPath: indexPath) as! CalendarHeaderView
        
        if indexPath.item < self.time.timeRepresentations.count {
            view.titleLabel.text = self.time.timeRepresentations[indexPath.item]
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.borderWidth = 2
        }
        
        
        return view
    }
}
