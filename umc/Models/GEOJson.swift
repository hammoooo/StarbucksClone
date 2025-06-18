import Foundation

struct GeoJSONFeatureCollection: Decodable {
    let features: [GeoJSONFeature]
}

struct GeoJSONFeature: Decodable {
    let properties: GeoJSONProperties
    let geometry: GeoJSONGeometry
}

struct GeoJSONProperties: Decodable {
    let Sotre_nm: String
    let Category: String
    let Address: String?
}

struct GeoJSONGeometry: Decodable {
    let coordinates: [Double]
}
