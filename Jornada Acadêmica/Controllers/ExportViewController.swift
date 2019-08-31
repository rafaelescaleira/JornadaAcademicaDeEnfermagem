//
//  ExportViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func ButtonAction18() {
        
        let url = CSV.generateCSV(csvText: getCSVText(day: "18"), fileName: "Dia 18")
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: [])
        self.present(activity, animated: true, completion: nil)
    }
    
    @IBAction func ButtonAction19() {
        
        let url = CSV.generateCSV(csvText: getCSVText(day: "19"), fileName: "Dia 19")
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: [])
        self.present(activity, animated: true, completion: nil)
    }
    
    @IBAction func ButtonAction20() {
        
        let url = CSV.generateCSV(csvText: getCSVText(day: "20"), fileName: "Dia 20")
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: [])
        self.present(activity, animated: true, completion: nil)
    }
}
