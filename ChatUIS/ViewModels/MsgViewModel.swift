//
//  MsgViewModel.swift
//  ChatUIS
//
//  Created by Camilo Moreno on 20/04/21.
//

import Foundation
import FirebaseFirestore

class MsgViewModel: ObservableObject {
    @Published var msgModel = [MsgModel]()
    
    private var db = Firestore.firestore()
    
    func fetchData(){
        db.collection("mensajes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No documents")
                return
            }
                self.msgModel = documents.map { (queryDocumentSnapshot) -> MsgModel in
                let data = queryDocumentSnapshot.data()
                let mensaje = data["mensaje"] as? String ?? ""
                let usuario = data["usuario"] as? String ?? ""
                let timeStamp = data["hora"]  as? Date ?? Date()
                
                return MsgModel(msg: mensaje, user: usuario, timeStamp: timeStamp)
                
            }
        }
    }
    
    
}
