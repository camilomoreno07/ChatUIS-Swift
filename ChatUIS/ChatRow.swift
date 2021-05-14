//
//  ChatRow.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 20/04/21.
//

import SwiftUI

struct ChatRow: View {
    var chatData: MsgModel
    @AppStorage("current_user") var user = ""
    var body: some View {
        HStack(spacing: 15 ){
            if chatData.user != user{
                NickName(name: chatData.user)
            }
            if chatData.user == user{Spacer(minLength: 0)}
            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
                Text(chatData.msg)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(ChatBubble(myMsg: chatData.user == user))
                Text(chatData.timeStamp,style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(chatData.user != user ? .leading : .trailing, 19)
            })
            if chatData.user == user{
                NickName(name: chatData.user)
            }
            if chatData.user != user{Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)}
        }.padding(.horizontal)
        .id(chatData.id)
    }
}

struct NickName: View {
    var name: String
    var user = "Daniel"
    var body: some View{
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
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

