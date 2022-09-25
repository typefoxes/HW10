import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    static func northEast(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        guard coordinates.count > 0 else { return CLLocationCoordinate2D.init() }
        
        let la = coordinates.map{ $0.latitude }.max()!
        let lo = coordinates.map{ $0.longitude }.min()!
        return CLLocationCoordinate2D(latitude: la, longitude: lo)
    }
    static func southWest(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        guard coordinates.count > 0 else { return CLLocationCoordinate2D.init() }
        
        let la = coordinates.map{ $0.latitude }.min()!
        let lo = coordinates.map{ $0.longitude }.max()!
        return CLLocationCoordinate2D(latitude: la, longitude: lo)
    }
    static func center(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let northEastCoordinate = northEast(for: coordinates)
        let southWestCoordinate = southWest(for: coordinates)
        
        let la = (northEastCoordinate.latitude + southWestCoordinate.latitude) / 2
        let lo = (northEastCoordinate.longitude + southWestCoordinate.longitude) / 2
        
        return CLLocationCoordinate2D(latitude: la, longitude: lo)
    }
}

extension CLLocationCoordinate2D: Comparable {
    public static func <(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude < right.latitude && left.longitude < right.longitude
    }
    public static func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
}
