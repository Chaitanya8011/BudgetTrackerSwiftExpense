import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Transaction.entity(), sortDescriptors: [])
    private var transaction: FetchedResults<Transaction>

    @State private var showAddView = false
    @State private var postEdit: Transaction?

    var balance: Double {
        transaction.reduce(0) { result, transaction in
            if transaction.category == "income" {
                return result + transaction.amount
            } else if transaction.category == "expense" {
                return result - transaction.amount  // Fix: Subtract expenses
            }
            return result
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Balance Display
                HStack {
                    Text("Balance").font(.title)
                    Text("Rs \(balance, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(balance > 0 ? .green : .red)
                        .padding()
                }

                // Transaction List
                List(transaction, id: \.self) { transaction in
                    NavigationLink(destination: EditTransaction(transaction: transaction)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(transaction.amount, specifier: "%.2f")").font(.headline)
                                Text(transaction.desc ?? "No description").font(.subheadline)
                                Text(transaction.category ?? "No category")
                                    .font(.caption)
                                    .foregroundColor(transaction.category == "income" ? .green : .red)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteTransaction(transaction)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("All Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView()
            }
        }
    }

    // Move deleteTransaction outside the body
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
