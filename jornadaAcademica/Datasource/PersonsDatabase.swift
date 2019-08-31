//
//  PersonsDatabase.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import Foundation
import SharkORM

public class PersonsDatabase: SRKObject {
    
    @objc dynamic var email           : String?
    @objc dynamic var nomeCompleto    : String?
    @objc dynamic var nomeSocial      : String?
    @objc dynamic var CPF             : String?
    @objc dynamic var celular         : String?
    @objc dynamic var cursoProf       : String?
    @objc dynamic var instituicao     : String?
    @objc dynamic var frequencia      : String?
    @objc dynamic var dia             : String?
}

public struct PersonsModel: Codable {
    
    var email           : String?
    var nomeCompleto    : String?
    var nomeSocial      : String?
    var CPF             : String?
    var celular         : String?
    var cursoProf       : String?
    var instituicao     : String?
    
    enum CodingKeys: String, CodingKey {
        
        case email = "A"
        case nomeCompleto = "B"
        case nomeSocial = "C"
        case CPF = "D"
        case celular = "E"
        case cursoProf = "F"
        case instituicao = "G"
    }
}
