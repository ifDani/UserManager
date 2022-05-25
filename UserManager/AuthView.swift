import SwiftUI

struct AuthView: View {
    //Para seleccionar Login o Registro
    @State var select = 1
    //Campos registro y login
    @State var emailMain: String = ""
    @State var emailForgot: String = ""
    @State var password: String = ""
    @State var repPassword: String = ""
    //Mostrar sheet
    @State var showForgotPass = false
    //Lista de usuarios registrados
    @State var users: [User] = getAllUsers
    @State var showListLogged = false
    @State var showAlert = false
    @State var textAlert = "Usuario o contraseña incorrectos"
    @State var selectedEmail = ""
    var body: some View {
        NavigationView {
            VStack{
                //Navegacion cuando se loguee o registre un usuario
                NavigationLink(destination: UsersList(rootIsActive: $showListLogged, users: $users, currentEmail: selectedEmail), isActive: $showListLogged) {
                    EmptyView()
                }.navigationTitle("Autenticación")
                
                Text( select == 1 ? "Login" :  "Registro").font(.title)
                
                //TextFields
                VStack() {
                    TextField("Email", text: $emailMain)
                        .textContentType(.emailAddress)
                        .font(Font.system(size: 14))
                        .padding(.vertical, 12)
                        .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Contraseña", text: $password)
                        .font(Font.system(size: 14))
                        .padding(.vertical, 12)
                        .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    //Boton olvidar contraseña solo disponible en login
                    if select == 1 {
                        HStack {
                            Spacer()
                            Button {
                                showForgotPass = true
                            }label: {
                                Text("¿Has olvidado tu contraseña?").font(.system(size: 14))
                            }
                        }
                    }
                    
                    //Textfield repetir contraseña solo disponible en registro
                    if select == 2 {
                        SecureField("Repite Contraseña", text: $repPassword)
                            .font(Font.system(size: 14))
                            .padding(.vertical, 12)
                        
                            .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button {
                        controlarAutenticacion()
                    }label: {
                        Text(select == 1 ? "Iniciar sesión" : "Registrarse").padding().foregroundColor(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }.padding(.horizontal)
                
                
                //Seleccionar login o registro
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(Color.black).frame(height: 50)
                    HStack {
                        Button {
                            select = 1
                            
                        }label:{
                            Text("Login").foregroundColor(.white).padding(.horizontal).frame(height:43).background(select == 1 ? Color.yellow : Color.black).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        Spacer()
                        Button {
                            select = 2
                            
                        }label:{
                            Text("Registro").foregroundColor(.white).padding(.horizontal).frame(height:43).background(select == 2 ? Color.yellow: Color.black).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }.padding(.vertical).padding(.horizontal, 8)
                    
                }.fixedSize(horizontal: true, vertical: true).padding(.horizontal, 6).padding(.bottom, 40)
                
                
            }.sheet(isPresented: $showForgotPass, content: {
                VStack {
                    Text("Recuperacion de contraseña").font(.title)
                    TextField("Email", text: $emailForgot)
                        .font(Font.system(size: 14))
                        .padding(.vertical, 12)
                        .textContentType(.emailAddress)
                        .foregroundColor(.black).textFieldStyle(RoundedBorderTextFieldStyle())
                    //Boton de enviar que cierra el sheet
                    Button {
                        showForgotPass.toggle()
                    }label: {
                        Text("Enviar").foregroundColor(.white).padding(.vertical, 5).padding(.horizontal).background(.blue).clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                }.padding(.horizontal)
                
            }).alert(textAlert, isPresented: $showAlert, actions: {})
                .onAppear(perform: loadUsers)
        }
    }
    func controlarAutenticacion() {
        //Login
        if select == 1 {
                if users.filter({$0.email == emailMain && $0.password == password}).first != nil {
                    selectedEmail = emailMain
                    showListLogged = true
                } else {
                    //Error
                    textAlert = "Usuario o contraseña incorrectos"
                    showAlert = true
                }
            
            //Registro
        } else {
            if emailMain == "" || password == "" || repPassword == "" {
                textAlert = "Es necesario rellenar todos los campos"
                showAlert = true
            } else {
                if password == repPassword {
                    
                    let usuario = User(email: emailMain, password: password)
                    
                    if users[0].email == "default" {
                        
                        //No hay usuarios añadimos el array
                        saveUsersAndGo(users: [usuario], email: usuario.email)
                    } else {
                        //Ya hay usuarios, añadimos el usuario al array
                        
                        users.append(usuario)
                        saveUsersAndGo(users: users, email: usuario.email)
                        
                    }
                } else {
                    textAlert = "Las contraseñas no coinciden"
                    showAlert = true
                }
            }
        }
    }
    
    func loadUsers() {
        users = getAllUsers
    }
    func saveUsersAndGo(users: [User], email:String) {
        selectedEmail = email
        saveAllUsers(allObjects: users)
        loadUsers()
        showListLogged = true
        select = 1
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
