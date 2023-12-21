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

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 's/messages.dart',
    swiftOut: 'ios/Classes/messages.g.swift',
    kotlinOut:
        'android/src/main/kotlin/com/google/maps/flutter/navigation/messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.google.maps.flutter.navigation'),
    dartOut: 'lib/src/method_channel/messages.g.dart',
    dartTestOut: 'test/messages_test.g.dart',
    copyrightHeader: 'pigeons/copyright.txt',
  ),
)

/// Object containing map options used to initialize Google Map view.
class MapOptionsDto {
  MapOptionsDto({
    required this.cameraPosition,
    required this.mapType,
    required this.compassEnabled,
    required this.rotateGesturesEnabled,
    required this.scrollGesturesEnabled,
    required this.tiltGesturesEnabled,
    required this.zoomGesturesEnabled,
    required this.scrollGesturesEnabledDuringRotateOrZoom,
    required this.mapToolbarEnabled,
    required this.minZoomPreference,
    required this.maxZoomPreference,
    required this.zoomControlsEnabled,
    required this.cameraTargetBounds,
  });

  /// The initial positioning of the camera in the map view.
  final CameraPositionDto cameraPosition;

  /// The type of map to display (e.g., satellite, terrain, hybrid, etc.).
  final MapTypeDto mapType;

  /// If true, enables the compass.
  final bool compassEnabled;

  /// If true, enables the rotation gestures.
  final bool rotateGesturesEnabled;

  /// If true, enables the scroll gestures.
  final bool scrollGesturesEnabled;

  /// If true, enables the tilt gestures.
  final bool tiltGesturesEnabled;

  /// If true, enables the zoom gestures.
  final bool zoomGesturesEnabled;

  /// If true, enables the scroll gestures during rotate or zoom.
  final bool scrollGesturesEnabledDuringRotateOrZoom;

  /// If true, enables the map toolbar.
  final bool mapToolbarEnabled;

  /// The minimum zoom level that can be set for the map.
  final double? minZoomPreference;

  /// The maximum zoom level that can be set for the map.
  final double? maxZoomPreference;

  /// If true, enables zoom controls for the map.
  final bool zoomControlsEnabled;

  /// Specifies a bounds to constrain the camera target, so that when users scroll and pan the map,
  /// the camera target does not move outside these bounds.
  final LatLngBoundsDto? cameraTargetBounds;
}

/// Object containing navigation options used to initialize Google Navigation view.
class NavigationViewOptionsDto {
  NavigationViewOptionsDto({
    required this.navigationUIEnabled,
  });

  /// Determines the initial visibility of the navigation UI on map initialization.
  final bool navigationUIEnabled;
}

/// A message for creating a new navigation view.
///
/// This message is used to initialize a new navigation view with a
/// specified initial parameters.
class NavigationViewCreationOptionsDto {
  NavigationViewCreationOptionsDto({
    required this.mapOptions,
    required this.navigationViewOptions,
  });
  final MapOptionsDto mapOptions;
  final NavigationViewOptionsDto navigationViewOptions;
}

/// Pigeon only generates messages if the messages are used in API.
/// [MapOptionsDto] is encoded and decoded directly to generate
/// a PlatformView creation message. This API should never be used directly.
@HostApi()
// ignore: unused_element
abstract class _NavigationViewCreationApi {
  // ignore: unused_element
  void _create(NavigationViewCreationOptionsDto msg);
}

enum MapTypeDto { none, normal, satellite, terrain, hybrid }

class CameraPositionDto {
  CameraPositionDto(
      {required this.bearing,
      required this.target,
      required this.tilt,
      required this.zoom});

  final double bearing;
  final LatLngDto target;
  final double tilt;
  final double zoom;
}

enum CameraPerspectiveDto { tilted, topDownHeadingUp, topDownNorthUp }

class MarkerDto {
  MarkerDto({required this.markerId, required this.options});

  /// Identifies marker
  final String markerId;

  /// Options for marker
  final MarkerOptionsDto options;
}

class MarkerOptionsDto {
  MarkerOptionsDto(
      {required this.alpha,
      required this.anchor,
      required this.draggable,
      required this.flat,
      required this.consumeTapEvents,
      required this.position,
      required this.rotation,
      required this.infoWindow,
      required this.visible,
      required this.zIndex});

  final double alpha;
  final MarkerAnchorDto anchor;
  final bool draggable;
  final bool flat;
  final bool consumeTapEvents;
  final LatLngDto position;
  final double rotation;
  final InfoWindowDto infoWindow;
  final bool visible;
  final double zIndex;
}

class InfoWindowDto {
  const InfoWindowDto({this.title, this.snippet, required this.anchor});
  final String? title;
  final String? snippet;
  final MarkerAnchorDto anchor;
}

class MarkerAnchorDto {
  const MarkerAnchorDto({
    required this.u,
    required this.v,
  });

  final double u;
  final double v;
}

enum MarkerEventTypeDto {
  clicked,
  infoWindowClicked,
  infoWindowClosed,
  infoWindowLongClicked
}

class MarkerEventDto {
  MarkerEventDto(
      {required this.viewId, required this.markerId, required this.eventType});

  final int viewId;
  final String markerId;
  final MarkerEventTypeDto eventType;
}

enum MarkerDragEventTypeDto { drag, dragStart, dragEnd }

class MarkerDragEventDto {
  MarkerDragEventDto(
      {required this.viewId,
      required this.markerId,
      required this.eventType,
      required this.position});

  final int viewId;
  final String markerId;
  final MarkerDragEventTypeDto eventType;
  final LatLngDto position;
}

class PolygonDto {
  const PolygonDto({required this.polygonId, required this.options});

  final String polygonId;
  final PolygonOptionsDto options;
}

class PolygonOptionsDto {
  const PolygonOptionsDto(
      {required this.points,
      required this.holes,
      required this.clickable,
      required this.fillColor,
      required this.geodesic,
      required this.strokeColor,
      required this.strokeWidth,
      required this.visible,
      required this.zIndex});

  final List<LatLngDto?> points;
  final List<PolygonHoleDto?> holes;
  final bool clickable;
  final int fillColor;
  final bool geodesic;
  final int strokeColor;
  final double strokeWidth;
  final bool visible;
  final double zIndex;
}

class PolygonHoleDto {
  const PolygonHoleDto({required this.points});
  final List<LatLngDto?> points;
}

class PolygonClickedEventDto {
  PolygonClickedEventDto({required this.viewId, required this.polygonId});
  final int viewId;
  final String polygonId;
}

class StyleSpanStrokeStyleDto {
  StyleSpanStrokeStyleDto.solidColor({
    required this.solidColor,
  });
  StyleSpanStrokeStyleDto.gradientColor({
    required this.fromColor,
    required this.toColor,
  });

  int? solidColor;
  int? fromColor;
  int? toColor;
}

class StyleSpanDto {
  StyleSpanDto({
    required this.length,
    required this.style,
  });

  final double length;
  final StyleSpanStrokeStyleDto style;
}

class PolylineDto {
  const PolylineDto({
    required this.polylineId,
    required this.options,
  });

  final String polylineId;
  final PolylineOptionsDto options;
}

enum StrokeJointTypeDto { bevel, defaultJoint, round }

enum PatternTypeDto { dash, dot, gap }

class PatternItemDto {
  PatternItemDto({required this.type, this.length});
  final PatternTypeDto type;
  final double? length;
}

class PolylineOptionsDto {
  PolylineOptionsDto({
    required this.points,
    required this.clickable,
    required this.geodesic,
    required this.strokeColor,
    required this.strokeJointType,
    required this.strokePattern,
    required this.strokeWidth,
    required this.visible,
    required this.zIndex,
    required this.spans,
  });

  final List<LatLngDto?>? points;
  final bool? clickable;
  final bool? geodesic;
  final int? strokeColor;
  final StrokeJointTypeDto? strokeJointType;
  final List<PatternItemDto?>? strokePattern;
  final double? strokeWidth;
  final bool? visible;
  final double? zIndex;
  final List<StyleSpanDto?> spans;
}

class PolylineClickedEventDto {
  PolylineClickedEventDto({
    required this.viewId,
    required this.polylineId,
  });

  final int viewId;
  final String polylineId;
}

class CircleDto {
  CircleDto({required this.circleId, required this.options});

  /// Identifies circle.
  final String circleId;

  /// Options for circle.
  final CircleOptionsDto options;
}

class CircleOptionsDto {
  const CircleOptionsDto({
    required this.position,
    required this.radius,
    required this.strokeWidth,
    required this.strokeColor,
    required this.strokePattern,
    required this.fillColor,
    required this.zIndex,
    required this.visible,
    required this.clickable,
  });

  final LatLngDto position;
  final double radius;
  final double strokeWidth;
  final int strokeColor;
  final List<PatternItemDto?> strokePattern;
  final int fillColor;
  final double zIndex;
  final bool visible;
  final bool clickable;
}

class CircleClickedEventDto {
  CircleClickedEventDto({
    required this.viewId,
    required this.circleId,
  });

  final int viewId;
  final String circleId;
}

@HostApi(dartHostTestHandler: 'TestNavigationViewApi')
abstract class NavigationViewApi {
  @async
  void awaitMapReady(int viewId);

  bool isMyLocationEnabled(int viewId);
  void enableMyLocation(int viewId, bool enabled);
  LatLngDto? getMyLocation(int viewId);

  MapTypeDto getMapType(int viewId);
  void setMapType(int viewId, MapTypeDto mapType);
  void setMapStyle(int viewId, String styleJson);
  bool isNavigationTripProgressBarEnabled(int viewId);
  void enableNavigationTripProgressBar(int viewId, bool enabled);
  bool isNavigationHeaderEnabled(int viewId);
  void enableNavigationHeader(int viewId, bool enabled);
  bool isNavigationFooterEnabled(int viewId);
  void enableNavigationFooter(int viewId, bool enabled);
  bool isRecenterButtonEnabled(int viewId);
  void enableRecenterButton(int viewId, bool enabled);
  bool isSpeedLimitIconEnabled(int viewId);
  void enableSpeedLimitIcon(int viewId, bool enabled);
  bool isSpeedometerEnabled(int viewId);
  void enableSpeedometer(int viewId, bool enabled);
  bool isIncidentCardsEnabled(int viewId);
  void enableIncidentCards(int viewId, bool enabled);
  bool isNavigationUIEnabled(int viewId);
  void enableNavigationUI(int viewId, bool enabled);

  CameraPositionDto getCameraPosition(int viewId);
  LatLngBoundsDto getVisibleRegion(int viewId);

  void followMyLocation(
      int viewId, CameraPerspectiveDto perspective, double? zoomLevel);
  @async
  bool animateCameraToCameraPosition(
      int viewId, CameraPositionDto cameraPosition, int? duration);
  @async
  bool animateCameraToLatLng(int viewId, LatLngDto point, int? duration);
  @async
  bool animateCameraToLatLngBounds(
      int viewId, LatLngBoundsDto bounds, double padding, int? duration);
  @async
  bool animateCameraToLatLngZoom(
      int viewId, LatLngDto point, double zoom, int? duration);
  @async
  bool animateCameraByScroll(
      int viewId, double scrollByDx, double scrollByDy, int? duration);
  @async
  bool animateCameraByZoom(int viewId, double zoomBy, double? focusDx,
      double? focusDy, int? duration);
  @async
  bool animateCameraToZoom(int viewId, double zoom, int? duration);

  void moveCameraToCameraPosition(int viewId, CameraPositionDto cameraPosition);
  void moveCameraToLatLng(int viewId, LatLngDto point);
  void moveCameraToLatLngBounds(
      int viewId, LatLngBoundsDto bounds, double padding);
  void moveCameraToLatLngZoom(int viewId, LatLngDto point, double zoom);
  void moveCameraByScroll(int viewId, double scrollByDx, double scrollByDy);
  void moveCameraByZoom(
      int viewId, double zoomBy, double? focusDx, double? focusDy);
  void moveCameraToZoom(int viewId, double zoom);
  void showRouteOverview(int viewId);

  void enableMyLocationButton(int viewId, bool enabled);
  void enableZoomGestures(int viewId, bool enabled);
  void enableZoomControls(int viewId, bool enabled);
  void enableCompass(int viewId, bool enabled);
  void enableRotateGestures(int viewId, bool enabled);
  void enableScrollGestures(int viewId, bool enabled);
  void enableScrollGesturesDuringRotateOrZoom(int viewId, bool enabled);
  void enableTiltGestures(int viewId, bool enabled);
  void enableMapToolbar(int viewId, bool enabled);
  void enableTraffic(int viewId, bool enabled);

  bool isMyLocationButtonEnabled(int viewId);
  bool isZoomGesturesEnabled(int viewId);
  bool isZoomControlsEnabled(int viewId);
  bool isCompassEnabled(int viewId);
  bool isRotateGesturesEnabled(int viewId);
  bool isScrollGesturesEnabled(int viewId);
  bool isScrollGesturesEnabledDuringRotateOrZoom(int viewId);
  bool isTiltGesturesEnabled(int viewId);
  bool isMapToolbarEnabled(int viewId);
  bool isTrafficEnabled(int viewId);

  List<MarkerDto> getMarkers(int viewId);
  List<MarkerDto> addMarkers(int viewId, List<MarkerDto> markers);
  List<MarkerDto> updateMarkers(int viewId, List<MarkerDto> markers);
  void removeMarkers(int viewId, List<MarkerDto> markers);
  void clearMarkers(int viewId);
  void clear(int viewId);

  List<PolygonDto> getPolygons(int viewId);
  List<PolygonDto> addPolygons(int viewId, List<PolygonDto> polygons);
  List<PolygonDto> updatePolygons(int viewId, List<PolygonDto> polygons);
  void removePolygons(int viewId, List<PolygonDto> polygons);
  void clearPolygons(int viewId);

  List<PolylineDto> getPolylines(int viewId);
  List<PolylineDto> addPolylines(int viewId, List<PolylineDto> polylines);
  List<PolylineDto> updatePolylines(int viewId, List<PolylineDto> polylines);
  void removePolylines(int viewId, List<PolylineDto> polylines);
  void clearPolylines(int viewId);

  List<CircleDto> getCircles(int viewId);
  List<CircleDto> addCircles(int viewId, List<CircleDto> circles);
  List<CircleDto> updateCircles(int viewId, List<CircleDto> circles);
  void removeCircles(int viewId, List<CircleDto> circles);
  void clearCircles(int viewId);
}

@FlutterApi()
abstract class NavigationViewEventApi {
  void onMapClickEvent(int viewId, LatLngDto latLng);
  void onMapLongClickEvent(int viewId, LatLngDto latLng);
  void onRecenterButtonClicked(int viewId);
  void onMarkerEvent(MarkerEventDto msg);
  void onMarkerDragEvent(MarkerDragEventDto msg);
  void onPolygonClicked(PolygonClickedEventDto msg);
  void onPolylineClicked(PolylineClickedEventDto msg);
  void onCircleClicked(CircleClickedEventDto msg);
}

class NavigationSessionEventDto {
  NavigationSessionEventDto({
    required this.type,
    required this.message,
  });
  final NavigationSessionEventTypeDto type;
  final String message;
}

enum NavigationSessionEventTypeDto {
  arrivalEvent,
  routeChanged,
  errorReceived;
}

class DestinationsDto {
  DestinationsDto({
    required this.waypoints,
    required this.displayOptions,
    this.routingOptions,
  });
  final List<NavigationWaypointDto?> waypoints;
  final NavigationDisplayOptionsDto displayOptions;
  final RoutingOptionsDto? routingOptions;
}

enum AlternateRoutesStrategyDto {
  all,
  none,
  one,
}

enum RoutingStrategyDto {
  defaultBest,
  deltaToTargetDistance,
  shorter,
}

enum TravelModeDto {
  driving,
  cycling,
  walking,
  twoWheeler,
  taxi,
}

class RoutingOptionsDto {
  RoutingOptionsDto({
    this.alternateRoutesStrategy,
    this.routingStrategy,
    this.targetDistanceMeters,
    this.travelMode,
    this.avoidTolls,
    this.avoidFerries,
    this.avoidHighways,
    this.locationTimeoutMs,
  });

  final AlternateRoutesStrategyDto? alternateRoutesStrategy;
  final RoutingStrategyDto? routingStrategy;
  final List<int?>? targetDistanceMeters;
  final TravelModeDto? travelMode;
  final bool? avoidTolls;
  final bool? avoidFerries;
  final bool? avoidHighways;
  final int? locationTimeoutMs;
}

class NavigationDisplayOptionsDto {
  NavigationDisplayOptionsDto(
    this.showDestinationMarkers,
    this.showStopSigns,
    this.showTrafficLights,
  );

  final bool? showDestinationMarkers;
  final bool? showStopSigns;
  final bool? showTrafficLights;
}

class NavigationWaypointDto {
  NavigationWaypointDto({
    required this.title,
    this.target,
    this.placeID,
    this.preferSameSideOfRoad,
    this.preferredSegmentHeading,
  });

  String title;
  LatLngDto? target;
  String? placeID;
  bool? preferSameSideOfRoad;
  int? preferredSegmentHeading;
}

enum RouteStatusDto {
  internalError,
  statusOk,
  routeNotFound,
  networkError,
  quotaExceeded,
  apiKeyNotAuthorized,
  statusCanceled,
  duplicateWaypointsError,
  noWaypointsError,
  locationUnavailable,
  waypointError,
  travelModeUnsupported,
  locationUnknown,
  quotaCheckFailed,
  unknown
}

class NavigationTimeAndDistanceDto {
  NavigationTimeAndDistanceDto({
    required this.time,
    required this.distance,
  });

  final double time;
  final double distance;
}

enum AudioGuidanceTypeDto {
  silent,
  alertsOnly,
  alertsAndGuidance,
}

class NavigationAudioGuidanceSettingsDto {
  NavigationAudioGuidanceSettingsDto({
    this.isBluetoothAudioEnabled,
    this.isVibrationEnabled,
    this.guidanceType,
  });

  final bool? isBluetoothAudioEnabled;
  final bool? isVibrationEnabled;
  final AudioGuidanceTypeDto? guidanceType;
}

class SimulationOptionsDto {
  SimulationOptionsDto({
    required this.speedMultiplier,
  });
  final double speedMultiplier;
}

class LatLngDto {
  const LatLngDto({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class LatLngBoundsDto {
  LatLngBoundsDto({
    required this.southwest,
    required this.northeast,
  });

  final LatLngDto southwest;
  final LatLngDto northeast;
}

enum SpeedAlertSeverityDto { unknown, notSpeeding, minor, major }

class SpeedingUpdatedEventDto {
  SpeedingUpdatedEventDto({
    required this.percentageAboveLimit,
    required this.severity,
  });

  final double percentageAboveLimit;
  final SpeedAlertSeverityDto severity;
}

class RoadSnappedLocationUpdatedEventDto {
  RoadSnappedLocationUpdatedEventDto({
    required this.location,
  });

  final LatLngDto location;
}

class RoadSnappedRawLocationUpdatedEventDto {
  RoadSnappedRawLocationUpdatedEventDto({
    required this.location,
  });

  final LatLngDto? location;
}

class OnArrivalEventDto {
  OnArrivalEventDto({
    required this.waypoint,
  });

  final NavigationWaypointDto waypoint;
}

class RemainingTimeOrDistanceChangedEventDto {
  RemainingTimeOrDistanceChangedEventDto({
    required this.remainingTime,
    required this.remainingDistance,
  });

  final double remainingTime;
  final double remainingDistance;
}

class RouteChangedEventDto {
  RouteChangedEventDto({
    required this.message,
  });

  final String message;
}

class ReroutingEventDto {
  ReroutingEventDto({
    required this.message,
  });

  final String message;
}

class TrafficUpdatedEventDto {
  TrafficUpdatedEventDto({
    required this.message,
  });

  final String message;
}

class SpeedAlertOptionsThresholdPercentageDto {
  SpeedAlertOptionsThresholdPercentageDto({
    required this.percentage,
    required this.severity,
  });

  final double percentage;
  final SpeedAlertSeverityDto severity;
}

class SpeedAlertOptionsDto {
  SpeedAlertOptionsDto({
    required this.minorSpeedAlertThresholdPercentage,
    required this.majorSpeedAlertThresholdPercentage,
    required this.severityUpgradeDurationSeconds,
  });

  final double severityUpgradeDurationSeconds;
  final double minorSpeedAlertThresholdPercentage;
  final double majorSpeedAlertThresholdPercentage;
}

enum RouteSegmentTrafficDataStatusDto { ok, unavailable }

class RouteSegmentTrafficDataRoadStretchRenderingDataDto {
  RouteSegmentTrafficDataRoadStretchRenderingDataDto({
    required this.style,
    required this.lengthMeters,
    required this.offsetMeters,
  });

  final RouteSegmentTrafficDataRoadStretchRenderingDataStyleDto style;
  final int lengthMeters;
  final int offsetMeters;
}

enum RouteSegmentTrafficDataRoadStretchRenderingDataStyleDto {
  unknown,
  slowerTraffic,
  trafficJam
}

class RouteSegmentTrafficDataDto {
  RouteSegmentTrafficDataDto({
    required this.status,
    required this.roadStretchRenderingDataList,
  });

  final RouteSegmentTrafficDataStatusDto status;
  final List<RouteSegmentTrafficDataRoadStretchRenderingDataDto?>
      roadStretchRenderingDataList;
}

class RouteSegmentDto {
  RouteSegmentDto({
    this.trafficData,
    required this.destinationLatLng,
    required this.latLngs,
    required this.destinationWaypoint,
  });

  final RouteSegmentTrafficDataDto? trafficData;
  final LatLngDto destinationLatLng;
  final List<LatLngDto?>? latLngs;
  final NavigationWaypointDto? destinationWaypoint;
}

@HostApi(dartHostTestHandler: 'TestNavigationSessionApi')
abstract class NavigationSessionApi {
  /// General.
  @async
  void createNavigationSession();
  bool isInitialized();
  void cleanup();
  @async
  bool showTermsAndConditionsDialog(String title, String companyName,
      bool shouldOnlyShowDriverAwarenessDisclaimer);
  bool areTermsAccepted();
  void resetTermsAccepted();

  /// Navigation.
  bool isGuidanceRunning();
  void startGuidance();
  void stopGuidance();
  @async
  RouteStatusDto setDestinations(DestinationsDto msg);
  void clearDestinations();
  NavigationWaypointDto? continueToNextDestination();
  NavigationTimeAndDistanceDto getCurrentTimeAndDistance();
  void setAudioGuidance(NavigationAudioGuidanceSettingsDto settings);
  void setSpeedAlertOptions(SpeedAlertOptionsDto options);
  List<RouteSegmentDto> getRouteSegments();
  List<LatLngDto> getTraveledRoute();
  RouteSegmentDto? getCurrentRouteSegment();

  /// Simulation
  void setUserLocation(LatLngDto location);
  void removeUserLocation();
  void simulateLocationsAlongExistingRoute();
  void simulateLocationsAlongExistingRouteWithOptions(
    SimulationOptionsDto options,
  );
  @async
  RouteStatusDto simulateLocationsAlongNewRoute(
    List<NavigationWaypointDto> waypoints,
  );
  @async
  RouteStatusDto simulateLocationsAlongNewRouteWithRoutingOptions(
    List<NavigationWaypointDto> waypoints,
    RoutingOptionsDto routingOptions,
  );
  @async
  RouteStatusDto simulateLocationsAlongNewRouteWithRoutingAndSimulationOptions(
    List<NavigationWaypointDto> waypoints,
    RoutingOptionsDto routingOptions,
    SimulationOptionsDto simulationOptions,
  );
  void pauseSimulation();
  void resumeSimulation();

  /// Simulation (iOS only)
  void allowBackgroundLocationUpdates(bool allow);

  /// Road snapped location updates.
  void enableRoadSnappedLocationUpdates();
  void disableRoadSnappedLocationUpdates();

  void registerRemainingTimeOrDistanceChangedListener(
      int remainingTimeThresholdSeconds, int remainingDistanceThresholdMeters);
}

@FlutterApi()
abstract class NavigationSessionEventApi {
  // Android and iOS errors need to be unified first.
  void onNavigationSessionEvent(NavigationSessionEventDto msg);
  void onSpeedingUpdated(SpeedingUpdatedEventDto msg);
  void onRoadSnappedLocationUpdated(RoadSnappedLocationUpdatedEventDto msg);
  void onRoadSnappedRawLocationUpdated(
      RoadSnappedRawLocationUpdatedEventDto msg);
  void onArrival(OnArrivalEventDto msg);
  void onRouteChanged(RouteChangedEventDto msg);
  void onRemainingTimeOrDistanceChanged(
      RemainingTimeOrDistanceChangedEventDto msg);

  /// Android only event.
  void onTrafficUpdated(TrafficUpdatedEventDto msg);

  /// Android only event.
  void onRerouting(ReroutingEventDto msg);
}

@HostApi()
abstract class NavigationInspector {
  bool isViewAttachedToSession(int viewId);
}