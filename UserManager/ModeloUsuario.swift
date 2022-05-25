//
//  ModeloUsuario.swift
//  UserManager
//
//  Created by Daniel Carracedo on 19/5/22.
//

import Foundation

struct User: Codable, Identifiable {
    var id:UUID=UUID()
    let email: String
    let password: String

}
