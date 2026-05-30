import PDFKit
import SwiftUI

public struct MapDetailView: View {

    public let mapLink: MapLink

    @State private var pdfDocument: PDFDocument?
    @State private var loadingError: String?

    public init(mapLink: MapLink) {
        self.mapLink = mapLink
    }

    public var body: some View {
        Group {
            if let pdfDocument {
                PDFKitView(document: pdfDocument)
                    .ignoresSafeArea(edges: .bottom)
            } else if let loadingError {
                ContentUnavailableView(
                    .mapsLoadingErrorTitle,
                    systemImage: "exclamationmark.triangle",
                    description: Text(loadingError)
                )
            } else {
                ProgressView()
            }
        }
        .navigationTitle(Text(mapLink.title))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadPDF()
        }
    }

    private func loadPDF() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: mapLink.url)
            if let document = PDFDocument(data: data) {
                pdfDocument = document
            } else {
                loadingError = String(localized: .mapsLoadingErrorInvalidPDF)
            }
        } catch {
            loadingError = error.localizedDescription
        }
    }
}

private struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = document
    }
}

#Preview {
    NavigationStack {
        MapDetailView(mapLink: .dayTubeMap)
    }
}
