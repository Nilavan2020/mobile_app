@extends('layouts.dashboard_master_layout')

@section('HeaderAssets')
  <title>Dashboard - Smart Safety Welfare App</title>

  <link href="{{asset('assets')}}/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/metismenu.min.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/icons.css" rel="stylesheet" type="text/css">
  <link href="{{asset('assets')}}/css/style.css" rel="stylesheet" type="text/css">
  
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  
  <style>
    #sriLankaMap {
      width: 100%;
      height: 600px;
      border-radius: 8px;
      z-index: 1;
    }
    .map-legend {
      position: absolute;
      bottom: 20px;
      right: 20px;
      background: rgba(255, 255, 255, 0.95);
      padding: 15px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
      z-index: 1000;
      font-size: 12px;
    }
    .legend-item {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
    }
    .legend-color {
      width: 20px;
      height: 20px;
      border-radius: 4px;
      margin-right: 10px;
      border: 1px solid #ccc;
    }
    .leaflet-popup-content {
      font-size: 14px;
    }
    .leaflet-popup-content strong {
      color: #DD671F;
    }
  </style>
@endsection

@section('PageContent')

<div class="container-fluid">
    <div class="page-title-box">
        <div class="row align-items-center">
          <div class="col-md-8">
            <div class="page-title-box">
                <h4 class="page-title">{{ __('messages.dashboard') }}</h4>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{ route('show.dashboard') }}">{{ __('messages.home') }}</a>
                    </li>
                    <li class="breadcrumb-item active">{{ __('messages.dashboard') }}</li>
                </ol>
            </div>
          </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Total Requests</h5>
                    <h2>{{ $stats['total_requests'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Pending Requests</h5>
                    <h2>{{ $stats['pending_requests'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Total Donations</h5>
                    <h2>{{ $stats['total_donations'] }}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Pending Donations</h5>
                    <h2>{{ $stats['pending_donations'] }}</h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Sri Lanka Map Heatmap -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-body" style="position: relative;">
                    <h4 class="card-title mb-4">Relief Requests Heatmap by District</h4>
                    <p class="text-muted mb-4">Districts with more requests are shown in darker red colors</p>
                    <div id="sriLankaMap"></div>
                    <div class="map-legend">
                        <h6 style="margin-bottom: 10px; font-weight: bold;">Request Intensity</h6>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #e0e0e0;"></div>
                            <span>No Requests</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #fff4e6;"></div>
                            <span>Low (1-2)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #ffcc99;"></div>
                            <span>Medium (3-5)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #ff9966;"></div>
                            <span>High (6-9)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #ff3300;"></div>
                            <span>Very High (10+)</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('FooterAssets')
    <style>
        .map-tooltip {
            background-color: rgba(30, 41, 59, 0.95) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            border-radius: 4px !important;
            color: #dee2e6 !important;
            padding: 8px 12px !important;
            font-size: 14px !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3) !important;
            font-weight: 500;
        }
        
        .leaflet-tooltip-top:before {
            border-top-color: rgba(30, 41, 59, 0.95) !important;
        }
        
        .leaflet-tooltip-bottom:before {
            border-bottom-color: rgba(30, 41, 59, 0.95) !important;
        }
        
        .leaflet-tooltip-left:before {
            border-left-color: rgba(30, 41, 59, 0.95) !important;
        }
        
        .leaflet-tooltip-right:before {
            border-right-color: rgba(30, 41, 59, 0.95) !important;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="{{asset('assets')}}/js/app.js"></script>
    
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    
    <script>
        // District request counts from backend
        const requestCounts = @json($requestCounts);
        
        // Function to get color based on request count
        function getColorForCount(count) {
            if (count === 0 || !count) return '#e0e0e0'; // Gray - no requests
            if (count <= 2) return '#fff4e6'; // Light orange - Low (1-2)
            if (count <= 5) return '#ffcc99'; // Medium orange - Medium (3-5)
            if (count <= 9) return '#ff9966'; // Dark orange - High (6-9)
            return '#ff3300'; // Red - Very High (10+)
        }
        
        // Initialize the map centered on Sri Lanka
        const map = L.map('sriLankaMap', {
            center: [7.8731, 80.7718],
            zoom: 7,
            zoomControl: true
        });
        
        // Add a base map layer so the map displays
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
            maxZoom: 19
        }).addTo(map);
        
        // Load GeoJSON data
        const geojsonUrl = '{{ asset("assets/geojson/sri-lanka-districts.geojson") }}';
        
        fetch(geojsonUrl)
            .then(response => {
                if (!response.ok) throw new Error('Failed to load GeoJSON');
                return response.json();
            })
            .then(data => {
                console.log('GeoJSON loaded:', data);
                
                L.geoJSON(data, {
                    style: function(feature) {
                        const district = feature.properties.district || '';
                        const count = requestCounts[district] || 0;
                        const color = getColorForCount(count);
                        
                        return {
                            fillColor: color,
                            weight: 2,
                            opacity: 1,
                            color: '#ffffff',
                            fillOpacity: 0.8
                        };
                    },
                    onEachFeature: function(feature, layer) {
                        const district = feature.properties.district || '';
                        const count = requestCounts[district] || 0;
                        
                        // Add tooltip on hover (instead of popup on click)
                        layer.bindTooltip(
                            '<strong>' + district + '</strong><br>' +
                            count + ' request' + (count !== 1 ? 's' : ''),
                            {
                                permanent: false,
                                direction: 'auto',
                                className: 'map-tooltip'
                            }
                        );
                        
                        // Add click event to navigate to filtered requests
                        layer.on('click', function(e) {
                            window.location.href = '{{ route("relief.requests") }}?district=' + encodeURIComponent(district);
                        });
                        
                        // Add hover effect with tooltip
                        layer.on({
                            mouseover: function(e) {
                                const layer = e.target;
                                layer.setStyle({
                                    weight: 4,
                                    color: '#333',
                                    fillOpacity: 1
                                });
                                // Change cursor to pointer
                                map.getContainer().style.cursor = 'pointer';
                                // Open tooltip on hover
                                layer.openTooltip();
                            },
                            mouseout: function(e) {
                                const layer = e.target;
                                const district = feature.properties.district || '';
                                const count = requestCounts[district] || 0;
                                const color = getColorForCount(count);
                                
                                layer.setStyle({
                                    weight: 2,
                                    color: '#ffffff',
                                    fillColor: color,
                                    fillOpacity: 0.8
                                });
                                // Reset cursor
                                map.getContainer().style.cursor = '';
                                // Close tooltip on mouseout
                                layer.closeTooltip();
                            }
                        });
                    }
                }).addTo(map);
                
                // Fit map to bounds of Sri Lanka
                const bounds = L.geoJSON(data).getBounds();
                if (bounds.isValid()) {
                    map.fitBounds(bounds, { padding: [50, 50] });
                } else {
                    // Fallback: Set view to Sri Lanka
                    map.setView([7.8731, 80.7718], 7);
                }
            })
            .catch(error => {
                console.error('Error loading GeoJSON:', error);
                // Show error message
                const mapDiv = document.getElementById('sriLankaMap');
                if (mapDiv) {
                    mapDiv.innerHTML = 
                        '<div style="padding: 40px; text-align: center; color: #666; background: #f5f5f5; border-radius: 8px;">' +
                        '<h5>Map Loading Error</h5>' +
                        '<p>Unable to load map data. Please check:</p>' +
                        '<ul style="text-align: left; display: inline-block;">' +
                        '<li>GeoJSON file exists at: assets/geojson/sri-lanka-districts.geojson</li>' +
                        '<li>File permissions are correct</li>' +
                        '<li>Browser console for detailed errors</li>' +
                        '</ul>' +
                        '<p style="margin-top: 20px;">Error: ' + error.message + '</p>' +
                        '</div>';
                }
            });
    </script>
@endsection
