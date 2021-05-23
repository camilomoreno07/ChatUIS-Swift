//
//  ChatView.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 6/05/21.
//

import SwiftUI
import Firebase

struct ChatView: View {
    
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
                
                VStack(spacing: 0){
                    ScrollViewReader{reader in
                        ScrollView{
                            
                                ForEach(viewModel.msgModel) { msgmodel in
                                    ChatRow(chatData: msgmodel,user: Auth.auth().currentUser!.email ).onAppear{
                                        if msgmodel.id == self.viewModel.msgModel.last!.id && scrolled{
                                            reader.scrollTo(viewModel.msgModel.last!.id, anchor: .bottom)
                                        }
                                    }
                                        
                                }
                                .onChange(of: viewModel.msgModel, perform: { value in
                                    reader.scrollTo(viewModel.msgModel.last!.id, anchor: .bottom)
                                })
                            
                        }
                        .onTapGesture {
                            self.endEditing()
                        }
                        .onAppear(){
                            self.viewModel.fetchData()
                        }
                        
                    }
                    
                    ZStack{
                        Color("verde").frame( height: 50, alignment: .bottom)
                        HStack{
                            TextField("", text: $viewModel.txt)
                                .frame(height: 35)
                                .font(.system(size: 15))
                                .padding(.horizontal, 5)
                                .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.init("blanconegro")))
                            if viewModel.txt != ""{
                                Button(action: {
                                    self.viewModel.writeMsgs()
                                }, label: {
                                    Image(systemName: "paperplane.fill").resizable().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10).background(Color.init("cuenta")).clipShape(Circle())
                                })
                            }
                            
                        }.frame(height: 40, alignment: .center).padding(.horizontal,10)
                        
                        
                    }
                }.keyboardManagment()
               
                
                
            }.edgesIgnoringSafeArea(.all)
            
        }
        else{
            FirstView()
        }
        
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
