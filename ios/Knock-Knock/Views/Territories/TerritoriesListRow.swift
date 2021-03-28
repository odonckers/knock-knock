//
//  TerritoriesListRow.swift
//  Knock-Knock
//
//  Created by Owen Donckers on 2/19/21.
//

import SwiftUI

extension TerritoriesView {
    struct LclRow: View {
        @ObservedObject var territory: Territory

        var body: some View {
            HStack {
                Image(systemName: "folder")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                FramedSpacer(spacing: .small, direction: .horizontal)
                VStack(alignment: .leading) {
                    Text(territory.wrappedName)
                        .font(.headline)
                    Text("territories.numberOfRecords \(territory.recordCount)")
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#if DEBUG
struct TerritoriesListRow_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext

        let territory = Territory(context: viewContext)
        territory.name = "D2D-50"

        return TerritoriesView.LclRow(territory: territory)
            .frame(width: 414, alignment: .leading)
            .padding(.horizontal)
            .previewLayout(.sizeThatFits)
    }
}
#endif
