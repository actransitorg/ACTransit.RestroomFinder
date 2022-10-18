"use strict";
		
/* set Mobile API site */
var tlsMode = location.protocol == "https:";
var service = window.location.host;
if (service.indexOf("localhost") >= 0) {
    service = window.location.protocol + "//" + window.location.host.replace(window.location.port, window.location.port-1) + "/restroom-finder/"; // api is on :port-1
} else if (service.indexOf("devapps") >= 0) {
    service = "http" + (tlsMode ? "s" : "") + "://devapi.actransit.org/restroom-finder/";
} else if (service.indexOf("testapps") >= 0) {
    service = "http" + (tlsMode ? "s" : "") + "://testapi.actransit.org/restroom-finder/";
} else {
    service = "http" + (tlsMode ? "s" : "") + "://api.actransit.org/restroom-finder/"; 
}

var HOME = { lat: 37.8054133, lng: -122.2707171, streetAddress: '1600 Franklin St, Oakland', zoom: 18, API_KEY: 'Your Google Map API Key'}; // AC Transit General Office
jQuery.support.cors = true;
var AcTransitMap = {};

// map options
		
var mapOptions = {
    canvas: ".google-map",
    startAddress:  { // change this on entry to start()
        streetAddress: HOME.streetAddress,
        lat: HOME.lat, 
        lng: HOME.lng
    },
    address: function(newAddress) { 
        console.log('new address: ' + newAddress);
    },
    scrolling: function(enabled) { 
        console.log('scrolling: ' + enabled);
    },
    nearbyRestrooms: function (lat, lng) {  // this could probably be changed to nearbyRestrooms
        //var url = 'api/Restrooms';
        //$.ajax({
        //	url: service + url,
        //	contentType: "text/plain; charset=utf-8",
        //	xhrFields: {
        //		withCredentials: true
        //	}
        //}).fail(function (jqXHR, textStatus, errorThrown) {
        //	console.log("error: " + errorThrown);
        //}).done(function (data) {
        //	if (data.length == 0) return;
        //	AcTransitMap.FindMe.showNearbyRestrooms(data); // callback (could be restrooms here)
        //});
    },
    routes: []
};

// in case you want to load routes		
function loadMapRoutes() {
    try {
        $.getJSON(service + 'lines/line/' + params.name)
            .done(function (result) {
                mapOptions.Routes.removeAll();
                if (result.length < 1 || result.Routes[0] == null)
                    return;
                for (var index = 0; index < result.Routes.length; index++) {
                    mapOptions.Routes.push({
                        id: self.lineId(),
                        name: result.Routes[index].DirectionCode.Description + ', ' + result.Routes[index].DayCode.KeyValue.Value + ' Schedule'
                    });
                }
            }).fail(function (result) {
            });

    } catch (e) {
    }
};
		

/*
	lazyLoadGoogleMaps v1.0.1, updated 2015-11-07
	By Osvaldas Valutis, www.osvaldas.info
	Available for use under the MIT License
    http://osvaldas.info/lazy-loading-google-maps
*/

window.googleMapsScriptLoaded = function () {
    $(window).trigger('googleMapsScriptLoaded');
};

; (function ($, window, document, undefined) {
    'use strict';

    var $window = $(window),
		$body = $('body'),
		windowHeight = $window.height(),
		windowScrollTop = 0,

		debounce = function (delay, fn) {
		    var timer = null;
		    return function () {
		        var context = this, args = arguments;
		        clearTimeout(timer);
		        timer = setTimeout(function () { fn.apply(context, args); }, delay);
		    };
		},
		throttle = function (delay, fn) {
		    var last, deferTimer;
		    return function () {
		        var context = this, args = arguments, now = +new Date;
		        if (last && now < last + delay) {
		            clearTimeout(deferTimer);
		            deferTimer = setTimeout(function () { last = now; fn.apply(context, args); }, delay);
		        }
		        else {
		            last = now;
		            fn.apply(context, args);
		        }
		    };
		},
		apiScriptLoaded = false,
		apiScriptLoading = false,
		$containers = $([]),

		init = function (callback) {
		    windowScrollTop = $window.scrollTop();

		    $containers.each(function () {
		        var $this = $(this),
					thisOptions = $this.data('options');

		        if ($this.offset().top - windowScrollTop > windowHeight * 1)
		            return true;

		        if (!apiScriptLoaded && !apiScriptLoading) {
		            var apiArgs =
					{
					    callback: 'googleMapsScriptLoaded'
					};

		            if (thisOptions.api_key) apiArgs.key = thisOptions.api_key;
		            if (thisOptions.libraries) apiArgs.libraries = thisOptions.libraries;
		            if (thisOptions.language) apiArgs.language = thisOptions.language;
		            if (thisOptions.region) apiArgs.region = thisOptions.region;
		            if (thisOptions.sensor) apiArgs.sensor = thisOptions.sensor;

		            $body.append('<script src="https://maps.googleapis.com/maps/api/js?v=3&' + $.param(apiArgs) + '"></sc'+'ript>');
		            apiScriptLoading = true;
		        }

		        if (!apiScriptLoaded) return true;

		        var map = new google.maps.Map(this, { zoom: thisOptions.zoom });
		        if (thisOptions.callback !== false)
		            thisOptions.callback(this, map);

		        $containers = $containers.not($this);
		    });
		};

    $window
	.on('googleMapsScriptLoaded', function () {
	    apiScriptLoaded = true;
	    init();
	})
	.on('scroll', throttle(500, init))
	.on('resize', debounce(1000, function () {
	    windowHeight = $window.height();
	    init();
	}));

    $.fn.lazyLoadGoogleMaps = function (options) {
        options = $.extend(
					{
					    api_key: false,
					    libraries: false,
					    signed_in: false,
					    language: false,
					    region: false,
					    callback: false,
					    sensor: false,
					},
					options);

        this.each(function () {
            var $this = $(this);
            $this.data('options', options);
            $containers = $containers.add($this);
        });

        init();

        this.debounce = debounce;
        this.throttle = throttle;

        return this;
    };

})(jQuery, window, document);

AcTransitMap.FindMe = {
    options: {},
    completed: false,
    start: function (options) {
        var me = this;
        me.WATCH_TIMEOUT = 500, me.CHECK_TIMEOUT = 5000, me.MinAvgCount = 8, me.avgPos = [], me.MIN_ACCURACY = 30, me.MAXIMUM_AGE = 10000;
        $.extend(me.options, options);
        var mapOptions = {
            api_key: HOME.API_KEY,
            libraries: false, // libraries to load, i.e. 'geometry,places'
            language: 'en-US',
            region: 'US',
            offsetWidth: 0,
            zoom: HOME.zoom,
            callback: me.initApi
        };
        if (!me.completed)
            $(me.options.canvas).lazyLoadGoogleMaps(mapOptions);
        else 
            me.restart();
    },
    abort: function (options) {
        var me = this;
        $.extend(me.options, options);
    },
    scroll: function (enabled) {
        var me = this;
        me.options.scrolling(enabled);
    },
    initApi: function (container, map) {
        console.log("FindMe ready");
        AcTransitMap.FindMe.initMap(container, map);
    },
    startAddress: function(map, marker, info, msg) { 
        var me = this;
        if (typeof info !== "undefined")
            me.info = info;
		var lookupAddress = me.options.startAddress.streetAddress == '' || me.options.startAddress.lat == '' || me.options.startAddress.lng == ''; 
		if (!lookupAddress) 
			return new google.maps.LatLng(me.options.startAddress.lat, me.options.startAddress.lng);
		var geocoder = new google.maps.Geocoder();	
		geocoder.geocode({ 'address': me.options.startAddress.streetAddress}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				me.geocodePosition(me.map, results[0].geometry.location, me.marker, me.info);
			}
		});
		return null;
	},
	restart: function() {
        var me = this;	
		var address = me.startAddress(me.map, me.marker, me.info, null);
		if (address != null)
			me.geocodePosition(me.map, me.startAddress(), me.marker, me.info);		
	},
    initMap: function (container, map) {
        var me = this;
        me.map = map;
        if (!navigator.geolocation) {
            alert("Geolocation disabled");
            return;
        }
        var marker = new google.maps.Marker({
            map: map,
            draggable: true
        });
        me.marker = marker;
        var info = new google.maps.InfoWindow({ map: map });
        var posOptions = {
            enableHighAccuracy: true,
            timeout: me.WATCH_TIMEOUT,
            maximumAge: me.MAXIMUM_AGE
        };
        google.maps.event.addListener(marker, 'dragstart', function () {
        });
        google.maps.event.addListener(marker, 'dragend', function () {
            me.avgPos = []; // marker moved, throw away averages
            me.geocodePosition(map, marker.getPosition(), marker, info);
        });
        google.maps.event.addListener(marker, 'dragend', function () {
            me.avgPos = []; // marker moved, throw away averages
            me.geocodePosition(map, marker.getPosition(), marker, info);
        });
        google.maps.event.addListener(map, "click", function (e) {
            me.geocodePosition(map, e.latLng, marker, info);
        });

        var address = me.startAddress(map, marker, info, null);
        if (address != null)
            me.geocodePosition(map, me.startAddress(), marker, info);
    },
    useDirectionsAPI: false,
    geocodePosition: function (map, pos, marker, info, msg) {
        var me = this;
        if (typeof info !== "undefined")
            me.info = info;
        var mLatLong = pos;
        marker.setPosition(mLatLong);
        map.setCenter(mLatLong);

        if (typeof msg !== "undefined") {
            me.info.setContent(msg);
            me.info.open(map, marker);
            me.completed = false;
            return;
        }

        if (me.snapToRestroom(marker))
            return;

        function setLocation(address, addressLatLong) {
            address = address.replace(", USA", "");
            marker.setPosition(addressLatLong);
            map.setCenter(addressLatLong);
            me.info.setContent(address);
            me.info.open(map, marker);
            me.options.address(address);
            //me.scroll(true);
            console.log("new lat/lng: " + addressLatLong.lat() + "," + addressLatLong.lng());
            me.options.nearbyRestrooms(addressLatLong.lat(), addressLatLong.lng());
            me.completed = true;
        }

        if (me.useDirectionsAPI) {
            var directionsService = new google.maps.DirectionsService();
            var request = {
                origin: mLatLong || marker.getPosition(),
                destination: mLatLong || marker.getPosition(),
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };
            directionsService.route(request, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    var address = response.routes[0].legs[0].start_address.replace(", USA", "");
                    var addressLatLong = response.routes[0].legs[0].start_location;
                    //marker.setPosition(addressLatLong);
                    map.setCenter(addressLatLong);
                    me.info.setContent(address);
                    me.info.open(map, marker);
                    me.options.address(address);
                    console.log("new lat/lng: " + addressLatLong.lat() + "," + addressLatLong.lng());
                    me.options.nearbyRestrooms(addressLatLong.lat(), addressLatLong.lng());
                    me.completed = true;
                } else {
                    console.log('directionsService failed: ' + status);
                }
            });
        }
        else {
            var geocoder = new google.maps.Geocoder;
            var addressLatLong = mLatLong || marker.getPosition();
            geocoder.geocode({ 'location': mLatLong || marker.getPosition() }, function (results, status) {
                if (status === 'OK') {
                    if (results[0]) {
                        var address = results[0].formatted_address;
                        setLocation(address, addressLatLong);
                    } else {
                        console.log('No results found');
                    }
                } else {
                    console.log('Geocoder failed due to: ' + status);
                }
            });
        }
    },
    snapToRestroom: function(marker) {
        var me = this;
        // if marker placed on top of another RestroomMarker, assume same Restroom
        var nearRestroomMarkers = me.RestroomMarker.filter(function (item) {
            item.dist = google.maps.geometry.spherical.computeDistanceBetween(marker.getPosition(), item.position);
            return item.dist < 25;
        });
        if (nearRestroomMarkers.length > 0) {
            nearRestroomMarkers.sort(function (a, b) {
                if (a.dist < b.dist) return -1;
                if (a.dist > b.dist) return 1;
                return 0;
            });
            var RestroomMarker = nearRestroomMarkers[0];
            var Restroom = me.Restrooms.filter(function (item) {
                return RestroomMarker.title == me.getRestroomTitle(item);
            });
            if (Restroom.length == 1) {
                me.options.address(Restroom[0].RestroomDescription.replace(":", " and ") + " (" + Restroom[0].Id511 + ")");
                me.options.routes('Routes for this Restroom: ' + Restroom[0].FlagRoute);
                marker.setPosition(RestroomMarker.position);
                me.map.setCenter(RestroomMarker.position);
                console.log("snap lat/lng: " + RestroomMarker.position.lat() + "," + RestroomMarker.position.lng());
                return true;
            }
        }
        return false;
    },
    RestroomInfo: [],
    RestroomMarker: [],
    Restrooms: [],
    showNearbyRestrooms: function(Restrooms) {
        var me = this;
        me.Restrooms = Restrooms;
        console.log("Restroom count: " + Restrooms.length);
        // clear any previous markers
        for (var i = 0; i < me.RestroomMarker.length; i++) {
            if (me.RestroomMarker[i]) {
                if (me.RestroomMarker[i].infoWindow) {
                    me.RestroomMarker[i].infoWindow.setMap(null);
                    me.RestroomMarker[i].infoWindow = null;
                }
                me.RestroomMarker[i].setMap(null);
            }
        }
        me.RestroomInfo = [];
        me.RestroomMarker = [];
        for (var i = 0; i < Restrooms.length; i++) {
            var m = new google.maps.Marker({
                position: new google.maps.LatLng(Restrooms[i].LatDec, Restrooms[i].LongDec),
                map: me.map,
                title: me.getRestroomTitle(Restrooms[i]),
                icon: "./images/Bus_icon_black.jpg"
            });
            var iw = new google.maps.InfoWindow({
                content: '<div class="info"><p>' + me.getRestroomTitle(Restrooms[i]) + '</p></div>',
            });
            me.RestroomMarkerInfo(m, iw, me.map);
            me.RestroomMarker.push(m);
            me.RestroomInfo.push(iw);
        }
        me.snapToRestroom(me.marker);
    },
    RestroomMarkerInfo: function (marker, infoWindow, map) {
        marker.addListener('click', function () {
            var imap = infoWindow.getMap();
            if (imap !== null && typeof imap !== "undefined")
                infoWindow.close();
            else
                infoWindow.open(map, marker);
        });
    },
    getRestroomTitle: function(Restroom) {
        return Restroom.RestroomName + (Restroom.Address !== null ? ' (' + Restroom.Address + ')' : '');
    }
}