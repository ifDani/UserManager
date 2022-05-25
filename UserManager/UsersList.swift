//
//  UsersList.swift
//  UserManager
//
//  Created by Daniel Carracedo on 19/5/22.
//

import SwiftUI

struct UsersList: View {
    @Binding var rootIsActive: Bool
    @Binding var users: [User]
    @State var showProfile = false
    let currentEmail: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
        VStack {
            //Navegacion al Perfil
            NavigationLink(destination: ProfileView(shouldPopToRootView: $rootIsActive, users: $users, email: currentEmail), isActive: $showProfile) {
                EmptyView()
            }.navigationTitle("Lista de usuarios")
            //Solo se muestra la lista si hay usuarios
            if let usuarios = users {
                List(usuarios) { user in
                     Text(user.email)
                }
            }
            
            //Cuando cargue la vista, cargamos los usuarios guardados en el UserDefaults
        }.onAppear(perform: loadUsers)
            Button {
                showProfile = true
            } label: {
                Image(systemName: "person.circle.fill").font(.system(size: 24)).padding()
            }
            
        }.navigationTitle("Listado Usuarios")
    }
    func loadUsers() {
        users = getAllUsers
    }
}

