//
//  PersonsParser.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit

public func parsePersons() {
    
    do {
        
        guard let path = Bundle.main.path(forResource: "jornada", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let persons = try JSONDecoder().decode([PersonsModel].self, from: data)
        
        for index in 18...20 {
            
            for person in persons {
                
                autoreleasepool {
                    
                    let newPerson = PersonsDatabase()
                    newPerson.email = person.email
                    newPerson.nomeCompleto = person.nomeCompleto
                    newPerson.nomeSocial = person.nomeSocial
                    newPerson.CPF = person.CPF
                    newPerson.celular = person.celular
                    newPerson.cursoProf = person.cursoProf
                    newPerson.instituicao = person.instituicao
                    newPerson.frequencia = "Ausente"
                    newPerson.dia = "\(index)"
                    newPerson.commit()
                }
            }
        }
    }
        
    catch {}
}

public func getCSVText(day: String) -> String {
    
    let persons = PersonsDatabase.query().where("dia='\(day)'").fetch() as? [PersonsDatabase] ?? []
    
    var parameter: String = String(format: "NomeCompleto;CPF;Email;Presenca\n")
    
    for person in persons {
        
        autoreleasepool {
            
            let name = String(format: "\(person.nomeCompleto ?? "");")
            let cpf = String(format: "\(person.CPF ?? "");")
            let email = String(format: "\(person.email ?? "");")
            let frequencia = String(format: "\(person.frequencia ?? "")\n")
            
            let row = name + cpf + email + frequencia
            
            parameter = parameter + row
        }
    }
    
    return parameter
}
