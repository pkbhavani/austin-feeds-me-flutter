import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:austin_feeds_me/model/location.dart';


class EventMapView extends StatefulWidget {
  EventMapView({Key key}) : super(key: key);

  @override
  _GoogleMaps createState() => new _GoogleMaps();
}

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

final LatLng austinLatLng = new LatLng(30.2669444, -97.7427778);

class _GoogleMaps extends State<EventMapView> {
    GoogleMapOverlayController mapOverlayController;
    List<Location> locations = List<Location>();

    @override
    void dispose() {
      mapOverlayController.overlayController.deactivateOverlay();
      super.dispose();
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
    }

    @override
    void deactivate() {
      super.deactivate();
    }

    @override
    void initState() {
      locations.add(Location(
          id: 1,
          name: 'Sydney Opera House',
          address1: 'Bennelong Point',
          address2: 'Sydney NSW 2000, Australia',
          lat: '-33.856159',
          long: '151.215256',
          imageUrl:
          'https://www.planetware.com/photos-large/AUS/australia-sydney-opera-house-2.jpg'));
      locations.add(Location(
          id: 2,
          name: 'Sydney Harbour Bridge',
          address1: '',
          address2: 'Sydney NSW, Australia',
          lat: '-33.857013',
          long: '151.207694',
          imageUrl:
          'https://www.planetware.com/photos-large/AUS/australia-sydney-harbour-bridge.jpg'));
      super.initState();
    }

    void _onMapChanged() {
      if (mounted) {
        setState(() {
        });
      }
    }

    void buildMap() async {
      if (mapOverlayController != null) return;

      var mq = MediaQuery.of(context);
      // add delay so overlay is positioned correctly
      await new Future<Null>.delayed(new Duration(milliseconds: 20));

      var mapHeight = (mq.size.height - 138.0);

      debugPrint("navigationbarheight is: " +kBottomNavigationBarHeight.toString());
      debugPrint("screen height is: " +mq.size.height.toString());
      debugPrint("map height is: " +mapHeight.toString());

      mapOverlayController = GoogleMapOverlayController.fromSize(
        width: mq.size.width,
        height: mapHeight,
        options: GoogleMapOptions(
          cameraPosition: new CameraPosition(target: austinLatLng, zoom: 14.0),
          trackCameraPosition: true,
        ),
      );
      mapOverlayController.mapController.addListener(_onMapChanged);
      mapOverlayController.overlayController.activateOverlay();
      locations.forEach((loc) {
        mapOverlayController.mapController.addMarker(MarkerOptions(
            zIndex: loc.id.toDouble(),
            position: LatLng(double.parse(loc.lat), double.parse(loc.long)),
            infoWindowText:
            InfoWindowText(loc.name, loc.address1 + ', ' + loc.address2)));
      });
      mapOverlayController.mapController.onInfoWindowTapped.add((Marker marker) {
        mapOverlayController.overlayController.deactivateOverlay();
        var index = marker.options.zIndex.toInt() - 1;
        debugPrint(locations[index].toString());
      });
      setState(() {});
    }

    Widget renderMap() {
      if (mapOverlayController == null) {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Loading.. please wait...",
                      ),
                    ),
                  ),
                ]));
      } else {
        return GoogleMapOverlay(controller: mapOverlayController);
      }
    }

    @override
    Widget build(BuildContext context) {
      buildMap();
      return renderMap();
    }
}