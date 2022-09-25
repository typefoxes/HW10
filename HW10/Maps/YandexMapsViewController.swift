import UIKit
import YandexMapKit
import CoreLocation

class YandexMapsViewController: UIViewController, PlacesDataSource {
    
    @IBOutlet weak var mapView: YMKMapView!
   
    
    var places: [Place] = []
    private var placeAnnotations: [YMKPlacemarkMapObject] = []
    private var viewWasLoaded = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        setupMapView()
        updateAnnotations(with: places)
        centerMapAtAnnotations(placeAnnotations)
        viewWasLoaded = true
    }
    
    private func setupMapView() {
        setupUserLocationLayer()
        mapView.mapWindow.map.mapObjects.addTapListener(with: self)
    }
    
    private func setupUserLocationLayer() {
        let userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)
    }
    
    private func updateAnnotations(with places: [Place]) {
        places.forEach(addPlace)
    }
    
    private func addPlace(_ place: Place) {
        let objects = mapView.mapWindow.map.mapObjects
        let point = YMKPoint(latitude: place.latitude, longitude: place.longitude)
        let image = UIImage(systemName: "flag")!.withTintColor(UIColor(hex: place.color))
        
        let placemark = objects.addPlacemark(with: point, image: image)

        placeAnnotations.append(placemark)
    }
    
    private func centerMapAtAnnotations(_ annotations: [YMKPlacemarkMapObject]) {
        let coordinates = annotations.map{ CLLocationCoordinate2D(latitude: $0.geometry.latitude, longitude: $0.geometry.longitude) }
        let box = YMKBoundingBox(southWest: YMKPoint(coordinate: .southWest(for: coordinates)),
                                 northEast: YMKPoint(coordinate: .northEast(for: coordinates)))
        
        mapView.mapWindow.map.move(with:
            mapView.mapWindow.map.cameraPosition(with: box))
    }
    
    deinit {
        if viewWasLoaded {
            mapView.mapWindow.map.mapObjects.removeTapListener(with: self)
        }
    }
    @IBAction func zoomIn(_ sender: Any) {

    }
    
    @IBAction func zoomOut(_ sender: Any) {

    }
    
    
}

extension YandexMapsViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        view.accuracyCircle.fillColor = UIColor.green
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

extension YandexMapsViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        let index = placeAnnotations.firstIndex(of: placemark)!
        let title = places[index].name
        
        print("did select annotation: \"\(title)\" at: \(point)")
        return false
    }
}
