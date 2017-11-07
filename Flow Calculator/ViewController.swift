//
//  ViewController.swift
//  Flow Calculator
//
//  Created by Samuel Schmitt on 11/6/17.
//  Copyright © 2017 Samuel Schmitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Outlets
    @IBOutlet weak var velocityField: UITextField!
    @IBOutlet weak var diameterField: UITextField!
    @IBOutlet weak var kvField: UITextField!
    @IBOutlet weak var roughField: UITextField!
    @IBOutlet weak var reynLabel: UILabel!
    @IBOutlet weak var wallreyLabel: UILabel!
    @IBOutlet weak var relRoughLabel: UILabel!
    @IBOutlet weak var ffLabel: UILabel!
    
    let tol = 0.001

    override func viewDidLoad() {
        reynLabel.text = ""
        wallreyLabel.text = ""
        relRoughLabel.text = ""
        ffLabel.text = ""
        self.title = "Friction Calculator"
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
    }

    @IBAction func calculateFriction(_ sender: Any) {
        self.view.endEditing(true)
        let velocity: Double! = Double(velocityField.text!)
        let diameter: Double! = Double(diameterField.text!)
        let kinVisc: Double! = Double(kvField.text!)
        let roughLen: Double! = Double(roughField.text!)
        
        let reyn = (velocity * diameter) / kinVisc
        let rrel = roughLen / diameter
        reynLabel.text = String(round(reyn*1000)/1000)
        relRoughLabel.text = String(round(rrel*10000)/10000)
        
        if reyn < 4000 {
            let fdw = 64/reyn
            let wallrat = reyn * rrel * pow(fdw/8, 0.5)
            wallreyLabel.text = String(round(wallrat*10000)/10000)
            ffLabel.text = String(round(fdw*10000)/10000)
        }else {
            var fdw = 1.34 / pow(log(3.7/rrel),2.0)
            var wallrat = reyn * rrel * pow(fdw/8, 0.5)
            
            if wallrat > 70 {
                wallreyLabel.text = String(round(wallrat*10000)/10000)
                ffLabel.text = String(round(fdw*10000)/10000)
            }else {
                fdw = 1.63 / pow(log(pow(rrel / 3.7, 1.11) + 6.9 / reyn),2.0)
                wallrat = reyn * rrel * pow(fdw/8, 0.5)
                if wallrat > 1{
                    wallreyLabel.text = String(round(wallrat*10000)/10000)
                    ffLabel.text = String(round(fdw*10000)/10000)
                    
                }else{
                    var eps = 1.0
                    while eps > tol {
                        let fsto = 1.34 / pow(log(0.396 * reyn * pow(fdw, 0.5)), 2.0)
                        eps = abs(fsto - fdw) / fdw
                        fdw = fsto
                    }
                    wallrat = reyn * rrel * pow(fdw/8, 0.5)
                    wallreyLabel.text = String(round(wallrat*10000)/10000)
                    ffLabel.text = String(round(fdw*10000)/10000)
                }
            }
            
            
        }
        
    }
    


}

