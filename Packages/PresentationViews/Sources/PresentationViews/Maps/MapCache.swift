import Foundation
import PDFKit

public enum MapCache {

    public static func isCached(_ mapLink: MapLink) -> Bool {
        FileManager.default.fileExists(atPath: fileURL(for: mapLink).path)
    }

    public static func loadCachedDocument(for mapLink: MapLink) -> PDFDocument? {
        let url = fileURL(for: mapLink)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return PDFDocument(url: url)
    }

    public static func isStale(_ mapLink: MapLink, maxAge: TimeInterval = 7 * 24 * 60 * 60) -> Bool {
        let url = fileURL(for: mapLink)
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
            let modified = attributes[.modificationDate] as? Date
        else {
            return true
        }
        return Date().timeIntervalSince(modified) > maxAge
    }

    public static func cache(data: Data, for mapLink: MapLink) throws {
        let directory = cacheDirectory
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try data.write(to: fileURL(for: mapLink))
    }

    public static func downloadAndCache(for mapLink: MapLink) async throws -> PDFDocument {
        let (data, _) = try await URLSession.shared.data(from: mapLink.url)
        guard let document = PDFDocument(data: data) else {
            throw MapCacheError.invalidPDF
        }
        try cache(data: data, for: mapLink)
        return document
    }

    private static var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Maps", isDirectory: true)
    }

    private static func fileURL(for mapLink: MapLink) -> URL {
        cacheDirectory.appendingPathComponent(mapLink.url.lastPathComponent)
    }
}

public enum MapCacheError: LocalizedError {
    case invalidPDF

    public var errorDescription: String? {
        String(localized: .mapsLoadingErrorInvalidPdf)
    }
}
