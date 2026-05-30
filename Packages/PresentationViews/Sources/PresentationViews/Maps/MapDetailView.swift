import PDFKit
import SwiftUI

public struct MapDetailView: View {

    public let mapLink: MapLink

    @State private var pdfDocument: PDFDocument?
    @State private var loadingError: String?
    @State private var isRefreshing = false

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
        .toolbar {
            if pdfDocument != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await refreshPDF() }
                    } label: {
                        if isRefreshing {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    .disabled(isRefreshing)
                }
            }
        }
        .task {
            await loadPDF()
        }
    }

    private func loadPDF() async {
        if let cached = MapCache.loadCachedDocument(for: mapLink) {
            pdfDocument = cached
            if MapCache.isStale(mapLink) {
                _ = try? await MapCache.downloadAndCache(for: mapLink)
            }
            return
        }
        await downloadPDF()
    }

    private func refreshPDF() async {
        isRefreshing = true
        await downloadPDF()
        isRefreshing = false
    }

    private func downloadPDF() async {
        do {
            let document = try await MapCache.downloadAndCache(for: mapLink)
            pdfDocument = document
            loadingError = nil
        } catch {
            if pdfDocument == nil {
                loadingError = error.localizedDescription
            }
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
