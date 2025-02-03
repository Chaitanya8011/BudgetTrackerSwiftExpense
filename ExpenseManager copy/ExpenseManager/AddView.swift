//
//  AddView.swift
//  ExpenseManager
//
//  Created by admin on 03/02/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext)private var viewContext
    @Environment(\.dismiss)private var dismiss
    @State private var amount = ""
    @State private var desc = ""
    @State private var category = "income"
    var body: some View {
        NavigationView(content: {
            Form{
                Section(header:Text("Transaction DEtails")){
                    TextField("Enter amount",text:$amount).keyboardType(.decimalPad)
                    TextField("Enter description",text:$desc)
                    Picker("Category",selection: $category){
                        Text("Income").tag("income")
                        Text("Expense").tag("expense")
                    }
                    .pickerStyle(SegmentedPickerStyle())
            }
            }.navigationBarTitle("adda new transactiom",displayMode: .inline)
            .navigationBarItems(leading:Button("cancel")
                                {
                dismiss()
            },trailing: Button("Save")
                                {
                addTransaction()
                dismiss()
            }.disabled(amount.isEmpty||desc.isEmpty))
            
        })
    }
    func addTransaction()
    {
        let newtransaction = Transaction(context:viewContext)
        newtransaction.id = UUID()
        newtransaction.desc = desc
        newtransaction.category = category
        if let isDouble = Double(amount)
        {
            newtransaction.amount = isDouble
        }
        else
        {
            newtransaction.amount = 0.0
        }
        do{
            try viewContext.save()
            desc = ""
            amount = ""
            category = ""
        }catch{
            print("Error saving transaction:\(error)")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
