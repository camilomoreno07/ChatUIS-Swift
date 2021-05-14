//
//  ChatView.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 6/05/21.
//

import SwiftUI

struct ChatView: View {
    @State var mensaje = ""
    @ObservedObject private var viewModel = MsgViewModel()
    @State var scrolled = false
    var body: some View {

        

        VStack {
//            ScrollViewReader{reader in
//                ScrollView{
//                    VStack(spacing: 15){
//                        ForEach(viewModel.msgModel){msgModel in
//                            ChatRow(chatData: msgModel)
//                                .onAppear{
//                                    if msgModel == self.viewModel.msgModel.last!.id && !scrolled{
//                                        reader.scrollTo(viewModel.msgModel.last!.id,anchor: .bottom)
//                                        scrolled = true
//                                    }
//                                }
//                        }.onChange(of: viewModel.msgModel, perform: { value in
//                            reader.scrollTo(viewModel.msgModel.last!.id, anchor: .bottom)
//                        })
//                    }
//                }
//
//            }
        
            ZStack{
                
                TextField("Escrbie algo", text: $mensaje)
            }
        }
           

    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
