//
//  MsgViewModel.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 20/04/21.
//

import Foundation
import Firebase

class MsgViewModel: ObservableObject {
    @Published var msgModel = [MsgModel]()
    @Published var txt = ""
    private var db = Firestore.firestore()
    
    func fetchData(){
        db.collection("mensajes").order(by: "hora").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No documents")
                return
            }
            self.msgModel = documents.map { (queryDocumentSnapshot) -> MsgModel in
                let data = queryDocumentSnapshot.data()
                let mensaje = data["mensaje"] as? String ?? ""
                let usuario = data["usuario"] as? String ?? ""
                let timeStamp = data["hora"]  as? Double ?? Date().timeIntervalSince1970
                
                return MsgModel(msg: mensaje, user: usuario, timeStamp: timeStamp)
                
            }
        }
    }
    
    func writeMsgs(){
        if let messageBody = Optional(txt) , let messageSender = Auth.auth().currentUser?.email{
            txt = ""
            db.collection("mensajes").addDocument(data: [
                                                    "usuario" : messageSender,
                                                    "mensaje" : messageBody,
                                                    "hora" : Date().timeIntervalSince1970]) { (error) in
                if let e = error{
                    print("There was an issue saving data to firestore, \(e)")
                }else{
                    
                    print("Succesfully saved data.")
                }
            }
        }
    }
}
