//
//  ContentView.swift
//  GroceryTracker
//
//  Created by Prithvij Rajesh on 9/21/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var name = ""
    @State private var quantity = 1
    @State private var purchaseDate = Date()
    @State private var expirationDate = Date()
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Item Name", text: $name)
                    Stepper(value: $quantity,in: 1...20) {
                        Text("Quantity: \(quantity)")
                    }
                    DatePicker("Purchase Date", selection:  $purchaseDate, displayedComponents: .date)
                    DatePicker("Expiration Date", selection:  $expirationDate, displayedComponents: .date)
                    Button("Add Item") {
                        addItem()
                    }
                }
                List {
                    ForEach(items) {
                        item in
                        VStack(alignment: .leading){
                            Text(item.name ?? "Unnamed").font(.headline)
                            Text("Quantity: \(item.quantity)")
                            Text("Purchased: \(item.purchaseDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                            Text("Expires: \(item.expirationDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Grocery Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    EditButton()
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = name
            newItem.quantity = Int16(quantity)
            newItem.purchaseDate = purchaseDate
            newItem.expirationDate = expirationDate
            
            do {
                try viewContext.save()
                name = ""
                quantity = 1
                purchaseDate = Date()
                expirationDate = Date()
            }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved Error \(nsError), \(nsError.userInfo)" )
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
