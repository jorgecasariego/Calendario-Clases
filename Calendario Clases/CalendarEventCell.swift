//
//  CalendarEventCell.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 23/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import UIKit
import Sapporo

class CalendarEventCellModel: SACellModel {
    let event: CalendarEvent
    
    init(event: CalendarEvent, selectionHandler: SASelectionHandler) {
        self.event = event
        super.init(cellType: CalendarEventCell.self, selectionHandler: selectionHandler)
    }
}

class CalendarEventCell: SACell {
    @IBOutlet weak var materiaLabel: UILabel!
    @IBOutlet weak var profesorLabel: UILabel!
    @IBOutlet weak var horaentradaLabel: UILabel!
    @IBOutlet weak var horaSalidaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0.7, alpha: 1).CGColor
    }
    
    override func configure(cellmodel: SACellModel) {
        super.configure(cellmodel)
        
        if let cellmodel = cellmodel as? CalendarEventCellModel {
            materiaLabel.text = cellmodel.event.materia
            profesorLabel.text = cellmodel.event.profesor
            horaentradaLabel.text = cellmodel.event.horaInicioString
            horaSalidaLabel.text  = cellmodel.event.horaSalidaString
        }
    }
}
