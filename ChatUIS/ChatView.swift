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
    @State var height : CGFloat = 0
    @State var keyboardHeight : CGFloat = 0
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
                Color("verde").frame( height: self.height + 15, alignment: .bottom)
                HStack{
                    ResizableTF(txt: self.$msj, height: self.$height).frame(height: self.height < 150 ? self.height : 150).padding(.horizontal).padding(.vertical, 2).background(Color.init("blanconegro")).cornerRadius(15)
//                    TextField("", text: $msj)
//                        .font(.system(size: 18))
//                        .padding(.horizontal, 5)
//                        .padding(.vertical, 3)
//                        .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.init("blanconegro")))
                    if msj != ""{
                        Button(action: {
                            print("enviar")
                        }, label: {
                            Image(systemName: "paperplane.fill").resizable().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10).background(Color.init("cuenta")).clipShape(Circle())
                        })
                    }
                    
                }.frame(height: 40, alignment: .center).padding(.horizontal,10)
                
        
            }.padding(.bottom, self.keyboardHeight)
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (data) in
                    let height1 = data.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                    self.keyboardHeight = height1.cgRectValue.height - 1
                }
            }
            }.edgesIgnoringSafeArea(.all)
        }
        else{
            FirstView()
        }

    }
}

struct ResizableTF : UIViewRepresentable{
    
    @Binding var txt : String
    @Binding var height : CGFloat
    
    func makeCoordinator() -> Coordinator {
        return ResizableTF.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = ""
        view.font = .systemFont(ofSize: 18)
        view.textColor = .gray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate{
        var parent : ResizableTF
        init(parent1 : ResizableTF){
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.txt == ""{
                textView.text = ""
                textView.textColor = UIColor.init(named: "negroblanco")
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.txt = textView.text
            }
        }
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
