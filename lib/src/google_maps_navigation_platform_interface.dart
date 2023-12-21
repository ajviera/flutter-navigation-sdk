// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../google_maps_navigation.dart';

/// Callback signature for when a map view is ready.
///
/// `id` is the platform view's unique identifier.
/// @nodoc
typedef MapReadyCallback = void Function(int viewId);

/// Google Maps Navigation Platform Interface for iOS and Android implementations.
/// @nodoc
abstract class GoogleMapsNavigationPlatform extends PlatformInterface
    with NavigationSessionAPIInterface, NavigationViewAPIInterface {
  /// Constructs a GoogleMapsNavigationPlatform.
  GoogleMapsNavigationPlatform() : super(token: _token);

  static final Object _token = Object();

  static GoogleMapsNavigationPlatform? _instance;

  /// The default instance of [GoogleMapsNavigationPlatform] to use.
  ///
  /// Defaults to [GoogleMapsNavigationPlatform].
  static GoogleMapsNavigationPlatform get instance {
    if (_instance == null) {
      throw UnimplementedError('instance has not been set for the platform.');
    }
    return _instance!;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GoogleMapsNavigationPlatform] when
  /// they register themselves.
  static set instance(GoogleMapsNavigationPlatform instance) {
    _instance = instance;
    PlatformInterface.verifyToken(instance, _token);
  }

  /// Builds and returns a navigation view.
  ///
  /// This method is responsible for creating a navigation view with the
  /// provided [initializationOptions].
  ///
  /// The [onMapReady] callback is invoked once the platform view has been created
  /// and is ready for interaction.
  Widget buildView(
      {required NavigationViewInitializationOptions initializationOptions,
      required MapReadyCallback onMapReady});
}

/// API interface for actions of the navigation session.
abstract mixin class NavigationSessionAPIInterface {
  /// Creates navigation session in the native platform and returns navigation session controller.
  Future<void> createNavigationSession();

  /// Check whether navigator has been initialized.
  Future<bool> isInitialized();

  /// Cleanup navigation session.
  Future<void> cleanup();

  /// Show terms and conditions dialog.
  Future<bool> showTermsAndConditionsDialog(String title, String companyName,
      bool shouldOnlyShowDriverAwarenessDisclaimer);

  /// Check if terms of service has been accepted.
  Future<bool> areTermsAccepted();

  /// Resets terms of service acceptance state.
  Future<void> resetTermsAccepted();

  /// Has guidance been started.
  Future<bool> isGuidanceRunning();

  /// Starts navigation guidance.
  Future<void> startGuidance();

  /// Stops navigation guidance.
  Future<void> stopGuidance();

  /// Sets destination waypoints and other settings.
  Future<NavigationRouteStatus> setDestinations(Destinations destinations);

  /// Clears destinations.
  Future<void> clearDestinations();

  /// Continues to next waypoint.
  Future<NavigationWaypoint?> continueToNextDestination();

  /// Gets current time and distance left.
  Future<NavigationTimeAndDistance> getCurrentTimeAndDistance();

  /// Sets audio guidance settings.
  Future<void> setAudioGuidance(NavigationAudioGuidanceSettings settings);

  /// Sets user location.
  Future<void> setUserLocation(LatLng location);

  /// Unsets user location.
  Future<void> removeUserLocation();

  /// Simulates locations along existing route.
  Future<void> simulateLocationsAlongExistingRoute();

  /// Simulates locations along existing route with simulation options.
  Future<void> simulateLocationsAlongExistingRouteWithOptions(
    SimulationOptions options,
  );

  /// Simulates locations along new route.
  Future<NavigationRouteStatus> simulateLocationsAlongNewRoute(
    List<NavigationWaypoint> waypoints,
  );

  /// Simulates locations along new route with routing options.
  Future<NavigationRouteStatus>
      simulateLocationsAlongNewRouteWithRoutingOptions(
    List<NavigationWaypoint> waypoints,
    RoutingOptions routingOptions,
  );

  /// Simulates locations along new route with routing and simulation options.
  Future<NavigationRouteStatus>
      simulateLocationsAlongNewRouteWithRoutingAndSimulationOptions(
    List<NavigationWaypoint> waypoints,
    RoutingOptions routingOptions,
    SimulationOptions simulationOptions,
  );

  /// Pauses simulation.
  Future<void> pauseSimulation();

  /// Resumes simulation.
  Future<void> resumeSimulation();

  /// Sets state of allow background location updates. (iOS only)
  Future<void> allowBackgroundLocationUpdates(bool allow);

  /// Enables road snapped location updates.
  Future<void> enableRoadSnappedLocationUpdates();

  /// Disables road snapped location updates.
  Future<void> disableRoadSnappedLocationUpdates();

  /// Get route segments.
  Future<List<RouteSegment>> getRouteSegments();

  /// Get traveled route.
  Future<List<LatLng>> getTraveledRoute();

  /// Get current route segment.
  Future<RouteSegment?> getCurrentRouteSegment();

  /// Get navigation speeding event stream from the navigation session.
  Stream<SpeedingUpdatedEvent> getNavigationSpeedingEventStream();

  /// Get navigation road snapped location event stream from the navigation session.
  Stream<RoadSnappedLocationUpdatedEvent>
      getNavigationRoadSnappedLocationEventStream();

  /// Get navigation road snapped raw location event stream from the navigation session.
  Stream<RoadSnappedRawLocationUpdatedEvent>
      getNavigationRoadSnappedRawLocationEventStream();

  /// Get navigation session event stream from the navigation session.
  Stream<NavigationSessionEvent> getNavigationSessionEventStream();

  /// Get navigation on arrival event stream from the navigation session.
  Stream<OnArrivalEvent> getNavigationOnArrivalEventStream();

  /// Get navigation on rerouting event stream from the navigation session.
  Stream<void> getNavigationOnReroutingEventStream();

  /// Get navigation traffic updated event stream from the navigation session.
  Stream<void> getNavigationTrafficUpdatedEventStream();

  /// Get navigation on route changed event stream from the navigation session.
  Stream<void> getNavigationOnRouteChangedEventStream();

  /// Get navigation remaining time or distance event stream from the navigation session.
  Stream<RemainingTimeOrDistanceChangedEvent>
      getNavigationRemainingTimeOrDistanceChangedEventStream();

  /// Register remaining time or distance change listener with thresholds.
  Future<void> registerRemainingTimeOrDistanceChangedListener(
      int remainingTimeThresholdSeconds, int remainingDistanceThresholdMeters);
}

/// API interface for actions of the navigation view.
/// @nodoc
abstract mixin class NavigationViewAPIInterface {
  /// Awaits the platform view to be ready for communication.
  Future<void> awaitMapReady({required int viewId});

  /// Get the preference for whether the my location should be enabled or disabled.
  Future<bool> isMyLocationEnabled({required int viewId});

  /// Enabled location in the navigation view.
  Future<void> enableMyLocation({required int viewId, required bool enabled});

  /// Get the map type.
  Future<MapType> getMapType({required int viewId});

  /// Modified visible map type.
  Future<void> setMapType({required int viewId, required MapType mapType});

  /// Set map style by json string.
  Future<void> setMapStyle(int viewId, String? styleJson);

  /// Enables or disables the my-location button.
  Future<void> enableMyLocationButton(
      {required int viewId, required bool enabled});

  /// Enables or disables the zoom gestures.
  Future<void> enableZoomGestures({required int viewId, required bool enabled});

  /// Enables or disables the zoom controls.
  Future<void> enableZoomControls({required int viewId, required bool enabled});

  /// Enables or disables the compass.
  Future<void> enableCompass({required int viewId, required bool enabled});

  /// Sets the preference for whether rotate gestures should be enabled or disabled.
  Future<void> enableRotateGestures(
      {required int viewId, required bool enabled});

  /// Sets the preference for whether scroll gestures should be enabled or disabled.
  Future<void> enableScrollGestures(
      {required int viewId, required bool enabled});

  /// Sets the preference for whether scroll gestures can take place at the same time as a zoom or rotate gesture.
  Future<void> enableScrollGesturesDuringRotateOrZoom(
      {required int viewId, required bool enabled});

  /// Sets the preference for whether tilt gestures should be enabled or disabled.
  Future<void> enableTiltGestures({required int viewId, required bool enabled});

  /// Sets the preference for whether the Map Toolbar should be enabled or disabled.
  Future<void> enableMapToolbar({required int viewId, required bool enabled});

  /// Turns the traffic layer on or off.
  Future<void> enableTraffic({required int viewId, required bool enabled});

  /// Get the preference for whether the my location button should be enabled or disabled.
  Future<bool> isMyLocationButtonEnabled({required int viewId});

  /// Gets the preference for whether zoom gestures should be enabled or disabled.
  Future<bool> isZoomGesturesEnabled({required int viewId});

  /// Gets the preference for whether zoom controls should be enabled or disabled.
  Future<bool> isZoomControlsEnabled({required int viewId});

  /// Gets the preference for whether compass should be enabled or disabled.
  Future<bool> isCompassEnabled({required int viewId});

  /// Gets the preference for whether rotate gestures should be enabled or disabled.
  Future<bool> isRotateGesturesEnabled({required int viewId});

  /// Gets the preference for whether scroll gestures should be enabled or disabled.
  Future<bool> isScrollGesturesEnabled({required int viewId});

  /// Gets the preference for whether scroll gestures can take place at the same time as a zoom or rotate gesture.
  Future<bool> isScrollGesturesEnabledDuringRotateOrZoom({required int viewId});

  /// Gets the preference for whether tilt gestures should be enabled or disabled.
  Future<bool> isTiltGesturesEnabled({required int viewId});

  /// Gets whether the Map Toolbar is enabled/disabled.
  Future<bool> isMapToolbarEnabled({required int viewId});

  /// Checks whether the map is drawing traffic data.
  Future<bool> isTrafficEnabled({required int viewId});

  /// Sets the Camera to follow the location of the user.
  Future<void> followMyLocation(
      {required int viewId,
      required CameraPerspective perspective,
      required double? zoomLevel});

  /// Gets users current location.
  Future<LatLng?> getMyLocation({required int viewId});

  /// Gets the current position of the camera.
  Future<CameraPosition> getCameraPosition({required int viewId});

  /// Gets the current visible area / camera bounds.
  Future<LatLngBounds> getVisibleRegion({required int viewId});

  /// Animates the movement of the camera.
  Future<void> animateCamera(
      {required int viewId,
      required CameraUpdate cameraUpdate,
      required int? duration,
      AnimationFinishedCallback? onFinished});

  /// Moves the camera.
  Future<void> moveCamera(
      {required int viewId, required CameraUpdate cameraUpdate});

  /// Is the navigation trip progress bar enabled.
  Future<bool> isNavigationTripProgressBarEnabled({required int viewId});

  /// Enable navigation trip progress bar.
  Future<void> enableNavigationTripProgressBar(
      {required int viewId, required bool enabled});

  /// Is the navigation header enabled.
  Future<bool> isNavigationHeaderEnabled({required int viewId});

  /// Enable navigation header.
  Future<void> enableNavigationHeader(
      {required int viewId, required bool enabled});

  /// Is the navigation footer enabled.
  Future<bool> isNavigationFooterEnabled({required int viewId});

  /// Enable the navigation footer.
  Future<void> enableNavigationFooter(
      {required int viewId, required bool enabled});

  /// Is the recenter button enabled.
  Future<bool> isRecenterButtonEnabled({required int viewId});

  /// Enable the recenter button.
  Future<void> enableRecenterButton(
      {required int viewId, required bool enabled});

  /// Is the speed limit displayed.
  Future<bool> isSpeedLimitIconEnabled({required int viewId});

  /// Should display speed limit.
  Future<void> enableSpeedLimitIcon(
      {required int viewId, required bool enable});

  /// Is speedometer displayed.
  Future<bool> isSpeedometerEnabled({required int viewId});

  /// Should display speedometer.
  Future<void> enableSpeedometer({required int viewId, required bool enable});

  /// Is incident cards displayed.
  Future<bool> isIncidentCardsEnabled({required int viewId});

  /// Should display incident cards.
  Future<void> enableIncidentCards({required int viewId, required bool enable});

  /// Is navigation UI enabled.
  Future<bool> isNavigationUIEnabled({required int viewId});

  /// Enable navigation UI.
  Future<void> enableNavigationUI({required int viewId, required bool enabled});

  /// Show route overview.
  Future<void> showRouteOverview({required int viewId});

  /// Get map clicked event stream from the navigation view.
  Stream<MapClickEvent> getMapClickEventStream({required int viewId});

  /// Get map long clicked event stream from the navigation view.
  Stream<MapLongClickEvent> getMapLongClickEventStream({required int viewId});

  /// Get navigation recenter button clicked event stream from the navigation view.
  Stream<NavigationViewRecenterButtonClickedEvent>
      getNavigationRecenterButtonClickedEventStream({required int viewId});

  /// Get all markers from map view.
  Future<List<Marker?>> getMarkers({required int viewId});

  /// Add markers to map view.
  Future<List<Marker?>> addMarkers(
      {required int viewId, required List<MarkerOptions> markerOptions});

  /// Update markers to map view.
  Future<List<Marker?>> updateMarkers(
      {required int viewId, required List<Marker> markers});

  /// Remove markers from map view.
  Future<void> removeMarkers(
      {required int viewId, required List<Marker> markers});

  /// Remove all markers from map view.
  Future<void> clearMarkers({required int viewId});

  /// Removes all markers, polylines, polygons, overlays, etc from the map.
  Future<void> clear({required int viewId});

  /// Get all polygons from map view.
  Future<List<Polygon?>> getPolygons({required int viewId});

  /// Add polygons to map view.
  Future<List<Polygon?>> addPolygons(
      {required int viewId, required List<PolygonOptions> polygonOptions});

  /// Update polygons to map view.
  Future<List<Polygon?>> updatePolygons(
      {required int viewId, required List<Polygon> polygons});

  /// Remove polygons from map view.
  Future<void> removePolygons(
      {required int viewId, required List<Polygon> polygons});

  /// Remove all polygons from map view.
  Future<void> clearPolygons({required int viewId});

  /// Get all polylines from map view.
  Future<List<Polyline?>> getPolylines({required int viewId});

  /// Add polylines to map view.
  Future<List<Polyline?>> addPolylines(
      {required int viewId, required List<PolylineOptions> polylineOptions});

  /// Update polylines to map view.
  Future<List<Polyline?>> updatePolylines(
      {required int viewId, required List<Polyline> polylines});

  /// Remove polylines from map view.
  Future<void> removePolylines(
      {required int viewId, required List<Polyline> polylines});

  /// Remove all polylines from map view.
  Future<void> clearPolylines({required int viewId});

  /// Get all circles from map view.
  Future<List<Circle?>> getCircles({required int viewId});

  /// Add circles to map view.
  Future<List<Circle?>> addCircles(
      {required int viewId, required List<CircleOptions> options});

  /// Update circles to map view.
  Future<List<Circle?>> updateCircles(
      {required int viewId, required List<Circle> circles});

  /// Remove circles from map view.
  Future<void> removeCircles(
      {required int viewId, required List<Circle> circles});

  /// Remove all circles from map view.
  Future<void> clearCircles({required int viewId});

  /// Get navigation view marker event stream from the navigation view.
  Stream<MarkerEventDto> getMarkerEventStream({required int viewId});

  /// Get navigation view marker drag event stream from the navigation view.
  Stream<MarkerDragEventDto> getMarkerDragEventStream({required int viewId});

  /// Get navigation view polygon clicked event stream from the navigation view.
  Stream<PolygonClickedEventDto> getPolygonClickedEventStream(
      {required int viewId});

  /// Get navigation view polyline clicked event stream from the navigation view.
  Stream<PolylineClickedEventDto> getPolylineDtoClickedEventStream(
      {required int viewId});

  /// Get navigation view circle clicked event stream from the navigation view.
  Stream<CircleClickedEventDto> getCircleDtoClickedEventStream(
      {required int viewId});

  /// Populates [GoogleNavigationInspectorPlatform.instance] to allow
  /// inspecting the platform map state.
  @visibleForTesting
  void enableDebugInspection() {
    throw UnimplementedError(
        'enableDebugInspection() has not been implemented.');
  }
}