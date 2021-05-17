//
//  ChatView.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 6/05/21.
//

import SwiftUI
import Firebase

struct ChatView: View {
    @State var mensaje = ""
    @ObservedObject private var viewModel = MsgViewModel()
    @State var scrolled = false
    @State var email = ""
    @State var pageNumber = 0

    var body: some View {

        if pageNumber == 0 {
        VStack {
            ZStack{
                Color("verde").frame(height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                    Spacer()
                    Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                        print("El usuario salió")
                    } catch let signOutError as NSError {
                      print ("Error signing out: %@", signOutError)
                    }
                        pageNumber = 1
                                          }, label: {
                        Text("Cerrar Sesión").foregroundColor(.white)
                    }).padding(.horizontal)
                }.frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
            List {
                
                
            }.padding(0)
            ZStack{
                Color("verde").frame( height: 50, alignment: .bottom)
                HStack{
                    TextField("", text: $email)
                        .font(.system(size: 18))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.init("blanconegro")))
                    Button(action: {
                        print("enviar")
                    }, label: {
                        Image(systemName: "paperplane.fill").resizable().frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10)
                    })
                    
                }.frame(height: 40, alignment: .center).padding(.horizontal,10)
                
        
            }
        }
        }
        else{
            FirstView()
        }

    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
