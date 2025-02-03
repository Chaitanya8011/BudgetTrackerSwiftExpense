//
//  EditView.swift
//  ExpenseManager
//
//  Created by admin on 03/02/25.
//

import SwiftUI

struct EditTransaction: View {
    @Environment(\.managedObjectContext)private var viewContext
    @Environment (\.dismiss)private var dismiss
    @ObservedObject var transaction:Transaction
    @State private var amount = ""
    @State private var desc = ""
    @State private var category = ""
    var body: some View {
        NavigationView(content: {
            Form{
                Section(header:Text("edit title"))
                {
                    TextField("edit posy title",text:$amount)
                    TextField("EWdit post desc",text:$desc)
                }
            }.navigationBarTitle("EditPost",displayMode: .inline)
                .navigationBarItems(leading:Button("cancel")
                                    {
                    dismiss()
                },trailing: Button("Update")
                                    {
                    transaction.desc = desc
                    transaction.amount = Double(amount) ?? 0.0
                    transaction.category = category
                    saveContext()
                    dismiss()
                    
                   
                    transaction.desc = desc
                    saveContext()
                    dismiss()
                }.disabled(amount.isEmpty||desc.isEmpty)).onAppear{
                    amount = String(format:"%2f",transaction.amount)
                    desc = transaction.desc ?? ""
                }
        })
    }
    func saveContext()
    {
        do{
            try viewContext.save()
        }catch{
            print ("error inaediting\(error)")
        }
    }
}


