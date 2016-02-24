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
    let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
    var goToDetail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
        
        
        sapporo.delegate = self
        sapporo.registerNibForClass(CalendarEventCell)
        sapporo.registerNibForSupplementaryClass(DayHeaderView.self, kind: CalendarHeaderType.Day.rawValue)
        sapporo.registerNibForSupplementaryClass(HourHeaderView.self, kind: CalendarHeaderType.Hour.rawValue)
        
        
        print("Tiempos: \(time.timeRepresentations)")
        
        
        let layout = CalendarLayout()
        sapporo.setLayout(layout)
        
        let randomEvent = { () -> CalendarEvent in
            let randomID = arc4random_uniform(10000)
            let materia = "Materia \(randomID)"
            let profesor = "Profesor \(randomID)"
            
            let randomDay = Int(arc4random_uniform(7))
            let randomStartHour = Int(arc4random_uniform(20))
            let randomDuration = Int(arc4random_uniform(3) + 2)
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
                
                let detailViewController = DetailViewController()
                detailViewController.event = event
                //detailViewController.colorArray = cell.gradientLayer?.colors
                //detailViewController.transitioningDelegate = transitionDelegate
                detailViewController.modalPresentationStyle = .Popover
                self.presentViewController(detailViewController, animated: true, completion: nil)
                self.goToDetail = true
                
            }
        }
        
        sapporo[0].append(cellmodels)
        sapporo.bump()
        
    }
    
    override func shouldAutorotate() -> Bool {
        // Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeRight, UIInterfaceOrientationMask.LandscapeLeft]
    }
    
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        // Only allow Landscape
        return UIInterfaceOrientation.LandscapeRight
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !goToDetail {
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.shouldRotate = true
        } else {
            // Volvemos al valor original
            goToDetail = false
        }
        
    }
    
}

extension CalendarViewController: SapporoDelegate {
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CalendarHeaderType.Day.rawValue {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: DayHeaderView.reuseIdentifier, forIndexPath: indexPath) as! DayHeaderView
            
            switch (indexPath.item)
            {
            case 0:
                view.dayLabel.text = "Lunes"
                
            case 1:
                view.dayLabel.text = "Martes"
                
            case 2:
                view.dayLabel.text = "Miercoles"
                
            case 3:
                view.dayLabel.text = "Jueves"
                
            case 4:
                view.dayLabel.text = "Viernes"
                
            case 5:
                view.dayLabel.text = "Sabado"
                
            default:
                view.dayLabel.text = "Domingo"
            }
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.borderWidth = 1
            
            
            return view
        }
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HourHeaderView.reuseIdentifier, forIndexPath: indexPath) as! HourHeaderView
        
        if indexPath.item < self.time.timeRepresentations.count {
            view.hourLabel.text = self.time.timeRepresentations[indexPath.item]
            //view.layer.borderColor = UIColor.whiteColor().CGColor
            //view.layer.borderWidth = 2
        }
        
        
        return view
    }
}
