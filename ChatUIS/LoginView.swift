//
//  LoginView.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 5/05/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var error = ""
    @State var alert = false
    @State var mensaje = ""
    @State var pageNumber = 0
    

    
  
    
    var body: some View {
        if pageNumber == 0 {
            VStack(spacing: 0) {
                
                
                ZStack {
                    
                    Color("verde").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    VStack{
                        HStack{
                            
                            Button(action: {
                                pageNumber = 1
                            }) {
                                
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                                
                                
                            }.foregroundColor(.black)
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                            
                        }
                        HStack() {
                            Text("Regístrate")
                                .font(Font.system(size: 40))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.leading)
                            Image("uisblanco")
                                .resizable()
                                .frame(width: 50, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.offset( y: -10.0)
                        
                        
                        
                        VStack {
                            
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                TextField("Usuario", text: self.$email)
                                    .font(.system(size: 14))
                                    .padding(15)
                                    .background(RoundedRectangle(cornerRadius: 50).stroke(Color("verde"), lineWidth: 1))
                                    .multilineTextAlignment(TextAlignment.center)
                                SecureField("Contraseña", text: self.$password)
                                     
                                    .font(.system(size: 14))
                                    .padding(15)
                                    .background(RoundedRectangle(cornerRadius: 50).stroke(Color("verde"),lineWidth: 1))
                                    .multilineTextAlignment(TextAlignment.center)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 10)
                            
                            Text(self.alert ? self.mensaje : "")
                                .foregroundColor(.red)
                                .padding()
                            
                            Button(action: {
                                self.registrar()
                            }, label: {
                                Text("Registrar")
                                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .frame(width:300 ,height: 50)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: . bold))
                                    .background(LinearGradient(gradient: Gradient(colors: [Color("verde"), Color("verde2")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                    .cornerRadius(25)
                            })
                         
                        
                            Spacer()
                            
                            
                        }
                        
                        .padding()
                        .background(Color("blanconegro"))
                        .mask(CustomShape(radius: 50))
                        //.shadow(color: .gray, radius: 10, x: 0, y: -5)
                        .edgesIgnoringSafeArea(.bottom)
                        .onTapGesture {
                            self.endEditing()
                            
                        }
                        .keyboardManagment()
                    }
                    
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        }
        else if pageNumber == 1{
            FirstView()
        }
        else{
            ChatView()
        }
        
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
        
    }
    
    func registrar(){
        if email != "" {
            if password.count >= 6{
                
                alert = false
                
                Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
                    if let x = err {
                        let err = x as NSError
                        alert = true
                        switch err.code {
                        case AuthErrorCode.wrongPassword.rawValue:
                            mensaje = "wrong password"
                        case AuthErrorCode.invalidEmail.rawValue:
                            mensaje = "Usuario inválido"
                        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                            mensaje = "accountExistsWithDifferentCredential"
                        case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                            mensaje = "Este usuario ya está en uso"
                        default:
                            print("unknown error: \(err.localizedDescription)")
                        }
                        
                        
                    }
                    else{
                        pageNumber = 2
                    }
                    email = ""
                    password = ""
                    print("Success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"),object: nil)
                }
                
            }
            else{
                mensaje = "La contraseña debe tener más de 6 caracteres"
                alert = true
            }
        }
        
        else{
            mensaje = "El campo de usuario está vacío"
            alert = true
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
