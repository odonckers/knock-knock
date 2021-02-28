//
//  RecordList.swift
//  Knock-Knock
//
//  Created by Owen Donckers on 2/19/21.
//

import CoreData
import SwiftUI

struct RecordList: View {
    var territory: Territory?

    init(territory: Territory? = nil) {
        self.territory = territory

        var recordsPredicate = NSPredicate(format: "territory == NULL")
        if let territory = territory {
            recordsPredicate = NSPredicate(format: "territory == %@", territory)
        }

        recordsRequest = FetchRequest<Record>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Record.streetName, ascending: true)
            ],
            predicate: recordsPredicate,
            animation: .default
        )
    }

    @Environment(\.managedObjectContext)
    private var viewContext

    @EnvironmentObject private var sheet: SheetState<RecordsView.SheetStates>

    private var recordsRequest: FetchRequest<Record>
    private var records: FetchedResults<Record> { recordsRequest.wrappedValue }

    @SceneStorage("Record.selection")
    private var selection: String? // Record UUID

    var body: some View {
        List(
            records,
            id: \.wrappedID,
            selection: $selection
        ) { record in
            NavigationLink(
                destination: DoorsView(record: record),
                tag: record.wrappedID,
                selection: $selection
            ) {
                RecordRow(record: record)
            }
            .contextMenu {
                Button(action: { sheet.present(.recordForm, with: record) }) {
                    Label("Edit", systemImage: "pencil")
                }

                Menu {
                    Button(action: { delete(record) }) {
                        Label("Permenantly Delete", systemImage: "trash")
                    }
                } label: {
                    Label("Delete Record", systemImage: "trash")
                }
            }
        }
    }

    private func delete(_ item: NSManagedObject) {
        withAnimation {
            viewContext.delete(item)
            viewContext.unsafeSave()
        }
    }
}

#if DEBUG
struct RecordList_Previews: PreviewProvider {
    static var previews: some View {
        RecordList()
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
            .environmentObject(SheetState<RecordsView.SheetStates>())
            .previewLayout(.sizeThatFits)
    }
}
#endif
