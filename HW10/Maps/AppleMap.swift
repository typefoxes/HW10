import UIKit
import MapKit


class AppleMapsViewController: UIViewController, PlacesDataSource {

    @IBOutlet weak var mapView: MKMapView!
    
    var places: [Place] = []
    var locationManager: CLLocationManager!
    var placeAnnotations: [PlaceAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapTrackingButton()
        setupMapView()
        setupLocationManager()
        updateAnnotations(with: places)
        centerMapAtAnnotations(placeAnnotations)
     
        locationManager.requestWhenInUseAuthorization()
    }
 
    private func setupMapView() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PlaceAnnotation")
        
        mapView.mapType = .mutedStandard
        mapView.delegate = self
    }
    
    private func centerMapAtAnnotations(_ annotations: [MKAnnotation]) {
        mapView.showAnnotations(annotations, animated: false)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    private func updateAnnotations(with places: [Place]) {
        placeAnnotations = places.map { PlaceAnnotation(place: $0) }
        placeAnnotations.forEach(mapView.addAnnotation)
    }
    
    @IBAction func zoomIN(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
                region.span.latitudeDelta /= 2.0
                region.span.longitudeDelta /= 2.0
                mapView.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
                region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
                region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
                mapView.setRegion(region, animated: true)
    }
    @objc func centerMapOnUserButtonClicked() {
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    func addMapTrackingButton(){
            let image = UIImage(named: "UserArrow") as UIImage?
            let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
            button.frame = CGRect(origin: CGPoint(x:340, y: 640), size: CGSize(width: 50, height: 50))
            button.setImage(image, for: .normal)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(AppleMapsViewController.centerMapOnUserButtonClicked), for:.touchUpInside)
            mapView.addSubview(button)
        }
    
    
}

extension AppleMapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotation")
        if let placeAnnotation = annotation as? PlaceAnnotation {
            if let image = placeAnnotation.image {
                annotationView.glyphImage = image
            } else {
                annotationView.glyphText = placeAnnotation.title?.first.map{ String($0) }
            }
            annotationView.markerTintColor = placeAnnotation.color
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let title = (annotation.title ?? "") ?? ""
            print("did select annotation: \"\(title)\" at: \(annotation.coordinate)")
        }
    }
}

extension AppleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
        default:
            mapView.showsUserLocation = false
        }
    }
}

