//
//  DetailViewController.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 24/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var materiaLabel: UILabel!
    
    
    //var colorArray: [AnyObject]?
    //let gradientLayer = CAGradientLayer()
    
    var event: CalendarEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appdelegate.shouldRotate = false
//        
//        // Force the device in landscape mode when the view controller gets loaded
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
        
        materiaLabel.text = event?.materia
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped")
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func viewTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
