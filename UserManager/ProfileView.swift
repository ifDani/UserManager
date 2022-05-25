//
//  ProfileView.swift
//  UserManager
//
//  Created by Daniel Carracedo on 19/5/22.
//

import SwiftUI

struct ProfileView: View {
    @Binding var shouldPopToRootView: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var users: [User]
    let email: String
    @State var password: String = ""
    @State var repPassword: String = ""
    @State var showAlert = false
     @State var changeSuccess = false
    @State var accountDeleted = false

    var body: some View {
        VStack {
            Text("Bienvenido \(email)")
            
            SecureField("Contraseña", text: $password)
                .font(Font.system(size: 14))
                .padding(.vertical, 12)
                .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Repite Contraseña", text: $repPassword)
                .font(Font.system(size: 14))
                .padding(.vertical, 12)
                .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                if password == repPassword {
                    //Eliminamos el usuario actual
                    users = users.filter({$0.email != email})
                    //Añadimos de nuevo el usuario con la contraseña cambiada
                    users.append(User(email: email, password: password))
                    saveAllUsers(allObjects: users)
                    changeSuccess = true
                    showAlert = true
                } else {
                    showAlert = true
                }
            }label: {
                Text("Cambiar Contraseña").padding().foregroundColor(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 12))
            }.padding(.bottom)
            
            Button {
                print("como queda", users.filter({$0.email != email}))
               saveAllUsers(allObjects: users.filter({$0.email != email}))
                accountDeleted = true
                showAlert = true
            } label: {
                Text("Eliminar cuenta").foregroundColor(.red).padding()
            }
        }.padding(.horizontal)
            .alert(isPresented: $showAlert) {
            Alert(
                title: Text(accountDeleted ? "Atención" : (changeSuccess ? "Confirmacion" : "Error")),
                message: Text(accountDeleted ? "Cuenta eliminada" : (changeSuccess ? "Contraseña cambiada correctamente" : "Las contraseñas no coinciden")),
                dismissButton: .default(Text("Ok"), action:  {
                    if changeSuccess {
                        presentationMode.wrappedValue.dismiss()

                    }
                    if accountDeleted {
                        shouldPopToRootView = false
                        
                    }

                })
            )
        }
    }
}

