//
//  FirstView.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 5/05/21.
//

import SwiftUI
import Firebase

struct FirstView: View {
    
    @State var email = "1@2.com"
    @State var password = "123456"
    @State var alert = false
    @State var isNavigationBarHidden: Bool = true
    @State var mensaje = ""
    @State var pageNumber = 0
    
    var body: some View {
        if pageNumber == 0 {
            VStack(spacing: 0) {
                ZStack {
                    
                    Color("verde").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    HStack {
                        //                    Text("Hola, te damos la bienvenida a nuestro chat!")
                        //                        .font(Font.custom("Poppins", size: 15))
                        //                        .fontWeight(.heavy)
                        //                        .foregroundColor(.white)
                        //                        .multilineTextAlignment(.leading)
                        //                    Spacer()
                        //                    ExDivider()
                        //                    Spacer()
                        Image("uisblanco")
                            .resizable()
                            .frame(width: 50, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }.padding()
                }.frame(height: 150)
                
                
                ZStack {
                    Color("verde").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    VStack {
                        
                        Spacer()
                        VStack(alignment: .leading, spacing: 20) {
                            
                            TextField("Usuario", text: $email)
                                .font(.system(size: 14))
                                .padding(15)
                                .background(RoundedRectangle(cornerRadius: 50).stroke(Color("verde"), lineWidth: 1))
                                .multilineTextAlignment(TextAlignment.center)
                            SecureField("Contraseña", text: $password)
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
                        
                        
                        
                        Button(action:{
                            self.ingresar()
                        }){
                            Text("Ingresar")
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(width:300 ,height: 50)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: . bold))
                                .background(LinearGradient(gradient: Gradient(colors: [Color("verde"), Color("verde2")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                .cornerRadius(25)
                        }
                        
                        Spacer()
                        
                        
                        
                        HStack{
                            Text("Soy un nuevo usuario.")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.primary)
                            
                            Button(action: {pageNumber = 1}, label: {
                                Text("Crear cuenta")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(Color("cuenta"))
                            })
                            
                            
                        }.padding(.bottom, 25)
                        
                        
                        
                    }
                    .keyboardManagment()
                    .padding()
                    .background(Color("blanconegro"))
                    .mask(CustomShape(radius: 50))
                    //.shadow(color: .gray, radius: 10, x: 0, y: -5)
                    .edgesIgnoringSafeArea(.bottom)
                    .onTapGesture {
                        self.endEditing()
                    }
                }
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .navigationBarHidden(true)
            
            
        }
        else if pageNumber == 1{
            LoginView()
        }
        else{
            ChatView()
        }
        
        
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    func ingresar() {
        if email != "" {
            if password.count >= 6{
                
                alert = false
                
                Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
                    if let x = err {
                        let err = x as NSError
                        alert = true
                        switch err.code {
                        case AuthErrorCode.wrongPassword.rawValue:
                            mensaje = "Contraseña incorrecta"
                        case AuthErrorCode.invalidEmail.rawValue:
                            mensaje = "Usuario inválido"
                        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                            mensaje = "accountExistsWithDifferentCredential"
                        case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                            mensaje = "Este usuario ya está en uso"
                        case AuthErrorCode.userNotFound.rawValue:
                        mensaje = "Este usuario no existe"
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
                    print(Auth.auth().currentUser!.email as Any)
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

//Allow to close the TextField
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CustomShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minY, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius), control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        
        return path
    }
}


struct KeyboardManagment: ViewModifier {
    @State private var offset: CGFloat = 0
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                        withAnimation(Animation.easeOut(duration: 0.285)) {
                            offset = keyboardFrame.height - geo.safeAreaInsets.bottom
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                        withAnimation(Animation.easeOut(duration: 0.2)) {
                            offset = 0
                        }
                    }
                }
                .padding(.bottom, offset)
        }
    }
    
    
}

extension View {
    func keyboardManagment() -> some View {
        self.modifier(KeyboardManagment())
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
