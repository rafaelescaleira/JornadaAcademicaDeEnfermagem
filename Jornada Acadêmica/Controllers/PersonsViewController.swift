//
//  PersonsViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import MessageUI

class PersonsViewController: UIViewController, UISearchBarDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    
    var persons: [PersonsDatabase] = []
    var fetchPersons: [PersonsDatabase] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        self.segmentedControl.segments = LabelSegment.segments(withTitles: ["Dia 18", "Dia 19", "Dia 20"], numberOfLines: 3, normalBackgroundColor: segmentedControl.backgroundColor, normalFont: .systemFont(ofSize: 17), normalTextColor: .white, selectedBackgroundColor: segmentedControl.indicatorViewBackgroundColor, selectedFont: .boldSystemFont(ofSize: 17), selectedTextColor: .white)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.persons = PersonsDatabase.query().where("dia=\(18)").fetch() as? [PersonsDatabase] ?? []
        self.fetchPersons = self.persons
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" { self.fetchPersons = self.persons.filter({ ($0.nomeCompleto?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.CPF?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "").lowercased().contains(searchText.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "").lowercased()) ?? false) }) }
        else { self.fetchPersons = self.persons }
        
        self.tableView.reloadData()
        if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async { self.view.endEditing(true) }
    }
    
    @IBAction func segmentedControlAction(_ sender: BetterSegmentedControl) {
        
        self.searchBar.text = ""
        self.view.endEditing(true)
        
        if sender.index == 0 {
            
            self.persons = PersonsDatabase.query().where("dia=\(18)").fetch() as? [PersonsDatabase] ?? []
            self.fetchPersons = self.persons
            
            self.tableView.reloadData()
            if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
        }
        
        else if sender.index == 1 {
            
            self.persons = PersonsDatabase.query().where("dia=\(19)").fetch() as? [PersonsDatabase] ?? []
            self.fetchPersons = self.persons
            
            self.tableView.reloadData()
            if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
        }
        
        else {
            
            self.persons = PersonsDatabase.query().where("dia=\(20)").fetch() as? [PersonsDatabase] ?? []
            self.fetchPersons = self.persons
            
            self.tableView.reloadData()
            if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
        }
    }
    
    @IBAction func backButtonAction() {
        
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
    
    @IBAction func hideKeyboardButtonAction(_ sender: Any) {
        
        DispatchQueue.main.async { self.view.endEditing(true) }
    }
    
    @objc func presenteButtonAction(_ sender: UIButton) {
        
        let person = self.fetchPersons[sender.tag]
        person.frequencia = "Presente"
        person.commit()
        
        self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .middle)
    }
    
    @objc func faltaButtonAction(_ sender: UIButton) {
        
        let person = self.fetchPersons[sender.tag]
        person.frequencia = "Ausente"
        person.commit()
        
        self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .middle)
    }
    
    @objc func callAction(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            guard let number = URL(string: "tel://" + InputTextMask.applyMask(.PHONE, toText: (self.fetchPersons[sender.tag].celular?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "") ?? "Número Inexistente"))) else { return }
            UIApplication.shared.open(number)
        }
    }
    
    @objc func messageAction(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            guard let number = URL(string: "https://api.whatsapp.com/send?phone=+5567\((self.fetchPersons[sender.tag].celular?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "067", with: "").replacingOccurrences(of: "67", with: "") ?? "Número Inexistente"))") else { return }
            UIApplication.shared.open(number)
        }
    }
    
    @objc func mailAction(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.fetchPersons[sender.tag].email ?? ""])

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

extension PersonsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fetchPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonsTableViewCell", for: indexPath) as? PersonsTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.presenteButton.tag = indexPath.row
        cell.faltaButton.tag = indexPath.row
        cell.callButton.tag = indexPath.row
        cell.messageButton.tag = indexPath.row
        cell.mailButton.tag = indexPath.row
        
        cell.presenteButton.addTarget(self, action: #selector(self.presenteButtonAction(_:)), for: .touchUpInside)
        cell.faltaButton.addTarget(self, action: #selector(self.faltaButtonAction(_:)), for: .touchUpInside)
        cell.callButton.addTarget(self, action: #selector(self.callAction(_:)), for: .touchUpInside)
        cell.messageButton.addTarget(self, action: #selector(self.messageAction(_:)), for: .touchUpInside)
        cell.mailButton.addTarget(self, action: #selector(self.mailAction(_:)), for: .touchUpInside)
        
        let item = self.fetchPersons[indexPath.row]
        cell.setCell(name: item.nomeCompleto, cpf: item.CPF, email: item.email, state: item.frequencia, day: item.dia, course: item.cursoProf, institutional: item.instituicao)
        
        return cell
    }
}

public class PersonsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cpfLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var institutionalLabel: UILabel!
    
    @IBOutlet weak var presenteButton: UIButton!
    @IBOutlet weak var faltaButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    public func setCell(name: String?, cpf: String?, email: String?, state: String?, day: String?, course: String?, institutional: String?) {
        
        self.nameLabel.text = name
        self.cpfLabel.text = InputTextMask.applyMask(.CPF, toText: cpf ?? "")
        self.emailLabel.text = email
        self.dayLabel.text = day
        self.courseLabel.text = course?.lowercased().capitalized
        self.institutionalLabel.text = institutional?.lowercased().capitalized
        
        if state == "Ausente" {
            
            let ausenteImage = #imageLiteral(resourceName: "xmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
            let presenteImage = #imageLiteral(resourceName: "checkmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
            
            self.presenteButton.setImage(presenteImage, for: .normal)
            self.faltaButton.setImage(ausenteImage, for: .normal)
            
            self.presenteButton.tintColor = .white
            self.faltaButton.tintColor = .systemRed
        }
        
        else {
            
            let ausenteImage = #imageLiteral(resourceName: "xmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
            let presenteImage = #imageLiteral(resourceName: "checkmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
            
            self.presenteButton.setImage(presenteImage, for: .normal)
            self.faltaButton.setImage(ausenteImage, for: .normal)
            
            self.presenteButton.tintColor = #colorLiteral(red: 0.3843137255, green: 0.7294117647, blue: 0.2784313725, alpha: 1)
            self.faltaButton.tintColor = .white
        }
    }
}
