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
    @State var msj = ""
    @State var pageNumber = 0

    var body: some View {

        if pageNumber == 0 {
            VStack(spacing:0){
            ZStack{
                Color("verde").frame(height:50, alignment: .bottom)
                
                
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
                    }.frame(height: 40, alignment: .bottom)
                
                
            }
//            List(viewModel.msgModel){msgmodel in
//                ChatRow(chatData: msgmodel)
////                VStack{
////                    Text(msgmodel.msg)
////                    Text(msgmodel.user)
////                }
//
//
//
//            }
                ScrollView{
                    LazyVStack {
                        ForEach(viewModel.msgModel) { msgmodel in
                            ChatRow(chatData: msgmodel)
                        }
                    }
                }
            .onAppear(){
                self.viewModel.fetchData()
            }
            ZStack{
                Color("verde").frame( height: 50, alignment: .bottom)
                HStack{
                    TextField("", text: $msj)
                        .font(.system(size: 18))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.init("blanconegro")))
                    if msj != ""{
                        Button(action: {
                            print("enviar")
                        }, label: {
                            Image(systemName: "paperplane.fill").resizable().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10).background(Color.init("cuenta")).clipShape(Circle())
                        })
                    }
                    
                }.frame(height: 40, alignment: .center).padding(.horizontal,10)
                
        
            }
            }.edgesIgnoringSafeArea(.all)
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
