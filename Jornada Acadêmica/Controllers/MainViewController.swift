//
//  MainViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import SPStorkController

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if PersonsDatabase.query().count() == 0 { parsePersons() }
        let persons = PersonsDatabase.query().where("dia='\(18)'").fetch() as? [PersonsDatabase] ?? []
        
        for i in persons { print("," + (i.CPF ?? "")) }
    }
    
    @IBAction func exportButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ExportViewController") as? ExportViewController else { return }
        
        DispatchQueue.global(qos: .background).sync {
            
            DispatchQueue.main.async {
                
                let transitionDelegate = SPStorkTransitioningDelegate()
                controller.transitioningDelegate = transitionDelegate
                controller.modalPresentationStyle = .custom
                controller.modalPresentationCapturesStatusBarAppearance = true
                transitionDelegate.customHeight = 200
                transitionDelegate.showIndicator = false
                transitionDelegate.showCloseButton = true
                
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func personsButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PersonsViewController") as? PersonsViewController else { return }
        
        DispatchQueue.global(qos: .background).sync {
            
            DispatchQueue.main.async {
                
                let transitionDelegate = SPStorkTransitioningDelegate()
                controller.transitioningDelegate = transitionDelegate
                controller.modalPresentationStyle = .custom
                controller.modalPresentationCapturesStatusBarAppearance = true
                transitionDelegate.showIndicator = false
                transitionDelegate.showCloseButton = true
                
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func scannerButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController else { return }
        
        DispatchQueue.global(qos: .background).sync {
            
            DispatchQueue.main.async {
                
                let transitionDelegate = SPStorkTransitioningDelegate()
                controller.transitioningDelegate = transitionDelegate
                controller.modalPresentationStyle = .custom
                controller.modalPresentationCapturesStatusBarAppearance = true
                transitionDelegate.showIndicator = false
                transitionDelegate.showCloseButton = true
                
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
