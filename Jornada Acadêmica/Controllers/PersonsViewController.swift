//
//  PersonsViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class PersonsViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    
    var persons: [PersonsDatabase] = []
    var fetchPersons: [PersonsDatabase] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        self.segmentedControl.segments = LabelSegment.segments(withTitles: ["Dia 18", "Dia 19", "Dia 20"], numberOfLines: 3, normalBackgroundColor: segmentedControl.backgroundColor, normalFont: .systemFont(ofSize: 17), normalTextColor: .white, selectedBackgroundColor: segmentedControl.indicatorViewBackgroundColor, selectedFont: .boldSystemFont(ofSize: 17), selectedTextColor: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.persons = PersonsDatabase.query().where("dia=\(18)").order("nomeCompleto").fetch() as? [PersonsDatabase] ?? []
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
            
            self.persons = PersonsDatabase.query().where("dia=\(18)").order("nomeCompleto").fetch() as? [PersonsDatabase] ?? []
            self.fetchPersons = self.persons
            
            self.tableView.reloadData()
            if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
        }
        
        else if sender.index == 1 {
            
            self.persons = PersonsDatabase.query().where("dia=\(19)").order("nomeCompleto").fetch() as? [PersonsDatabase] ?? []
            self.fetchPersons = self.persons
            
            self.tableView.reloadData()
            if self.fetchPersons.count != 0 { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true) }
        }
        
        else {
            
            self.persons = PersonsDatabase.query().where("dia=\(20)").order("nomeCompleto").fetch() as? [PersonsDatabase] ?? []
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
        
        cell.presenteButton.addTarget(self, action: #selector(self.presenteButtonAction(_:)), for: .touchUpInside)
        cell.faltaButton.addTarget(self, action: #selector(self.faltaButtonAction(_:)), for: .touchUpInside)
        
        let item = self.fetchPersons[indexPath.row]
        cell.setCell(name: item.nomeCompleto, cpf: item.CPF, email: item.email, state: item.frequencia, day: item.dia)
        
        return cell
    }
}

public class PersonsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cpfLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var presenteButton: UIButton!
    @IBOutlet weak var faltaButton: UIButton!
    
    public func setCell(name: String?, cpf: String?, email: String?, state: String?, day: String?) {
        
        self.nameLabel.text = name?.lowercased().capitalized
        self.cpfLabel.text = InputTextMask.applyMask(.CPF, toText: cpf ?? "")
        self.emailLabel.text = email
        self.dayLabel.text = day
        
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
            
            self.presenteButton.tintColor = #colorLiteral(red: 0.3831424117, green: 0.7302771807, blue: 0.2767491341, alpha: 1)
            self.faltaButton.tintColor = .white
        }
    }
}
