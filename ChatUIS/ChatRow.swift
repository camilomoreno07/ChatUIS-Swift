//
//  ChatRow.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 20/04/21.
//

import SwiftUI
import Firebase

struct ChatRow: View {
    var chatData: MsgModel
    var user = Auth.auth().currentUser!.email
    var body: some View {
        HStack(spacing: 7 ){
            if chatData.user != user{
                NickName(name: chatData.user)
            }
            if chatData.user == user{Spacer(minLength: 0)}
            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
                Text(chatData.msg)
                    
                    .foregroundColor(Color.init("negroblanco"))
                    .padding(10)
                    .background(Color.init("verde"))
                    .clipShape(ChatBubble(myMsg: chatData.user == user)).foregroundColor(.blue)
                Text(chatData.timeStamp,style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(chatData.user != user ? .leading : .trailing, 10)
            })
            if chatData.user == user{
                
            }
            if chatData.user != user{Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)}
        }.padding(.horizontal, 10).padding(.vertical, 5)
        .id(chatData.id)
    }
}

struct NickName: View {
    var name: String
    var user = Auth.auth().currentUser!.email
    var body: some View{
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background((name == user ? Color("verde") : Color.red).opacity(0.5))
            .clipShape(Circle())
            .contentShape(Circle())
            .contextMenu{
                Text(name).fontWeight(.bold)
            }
    }
}

struct ChatBubble: Shape {
    var myMsg: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}


struct ChatRow_Preview: PreviewProvider{
    
    static var previews: some View{
        ChatRow(chatData: MsgModel(id: "id", msg: "Superrrrrr", user: "Daniel", timeStamp: Date()), user: "Daniel")
    }
}
