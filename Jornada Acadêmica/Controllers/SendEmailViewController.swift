//
//  SendEmailViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 11/09/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import MessageUI

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var presenteButton: UIButton!
    @IBOutlet weak var faltaButton: UIButton!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    
    var day = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ausenteImage = #imageLiteral(resourceName: "xmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
        let presenteImage = #imageLiteral(resourceName: "checkmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
        
        self.presenteButton.setImage(presenteImage, for: .normal)
        self.faltaButton.setImage(ausenteImage, for: .normal)
        
        self.presenteButton.tintColor = #colorLiteral(red: 0.3843137255, green: 0.7294117647, blue: 0.2784313725, alpha: 1)
        self.faltaButton.tintColor = .systemRed
        
        self.segmentedControl.segments = LabelSegment.segments(withTitles: ["Dia 18", "Dia 19", "Dia 20"], numberOfLines: 3, normalBackgroundColor: segmentedControl.backgroundColor, normalFont: .systemFont(ofSize: 17), normalTextColor: .white, selectedBackgroundColor: segmentedControl.indicatorViewBackgroundColor, selectedFont: .boldSystemFont(ofSize: 17), selectedTextColor: .white)
    }
    
    @IBAction func segmentedControlAction(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 { self.day = 18 }
        else if sender.index == 1 { self.day = 19 }
        else { self.day = 20 }
    }
    
    @IBAction func presentesAction() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let mails = (PersonsDatabase.query().where("dia='\(self.day)'").fetch() as? [PersonsDatabase] ?? []).filter({ ($0.frequencia ?? "") == "Presente" }).map({ $0.email ?? "" })
            mail.setToRecipients(mails)

            present(mail, animated: true)
        }
        
        else {
            
            let alert = UIAlertController(title: "Mail services are not available", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBAction func ausentesAction() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let mails = (PersonsDatabase.query().where("dia='\(self.day)'").fetch() as? [PersonsDatabase] ?? []).filter({ ($0.frequencia ?? "") == "Ausente" }).map({ $0.email ?? "" })
            mail.setToRecipients(mails)

            present(mail, animated: true)
        }
        
        else {
            
            let alert = UIAlertController(title: "Mail services are not available", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
}
