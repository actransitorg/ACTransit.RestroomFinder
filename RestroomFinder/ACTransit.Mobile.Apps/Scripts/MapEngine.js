var iconBase = 'https://maps.google.com/mapfiles/kml/shapes/';
var icons = {
    parking: {
        icon: iconBase + 'parking_lot_maps.png'
    },
    library: {
        icon: iconBase + 'library_maps.png'
    },
    info: {
        icon: iconBase + 'info-i_maps.png'
    },
    bus: {
        icon: 'http://localhost:61880/Content/busicon.png'
    }
};

var MapEngine = {};
MapEngine.map = {};
MapEngine.markerStore = {};
MapEngine.stopStore = {};
MapEngine.center = null;
MapEngine.attachmentsURL = '';
MapEngine.editURL = '';
MapEngine.infoWindow = null;
MapEngine.initilize = function (lat, long) {
    var me = this;
    var myLatlng = new google.maps.LatLng(lat, long);
    var myOptions = {
        zoom: 13,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
    }
    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);    
    //google.maps.event.addDomListener(window, "resize", me.resize);

    MapEngine.map = map;
    //MapEngine.setMarker(new MarkerModel("currentPosition", "Current Position", lat, long, "Drivers Current Position", "This is your Current Position", icons['bus'].icon));
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(document.getElementById('legend'));
    //MapEngine.move(lat, long);
}

MapEngine.setStops = function (data, editURL, attachmentsURL) {
    MapEngine.stopStore = {};
    MapEngine.attachmentsURL = attachmentsURL;
    MapEngine.editURL = editURL;
    $(data).each(function () {
        var d = this;
        MapEngine.setMarker(new MarkerModel(d.stopId, d.stopId, d.lat, d.long, "Stop:" + d.stopId, "", d.workOrders, icons['bus'].icon), true);
    });
    
}
MapEngine.move = function (lat, long) {
    //MapEngine.setMarker(new MarkerModel("currentPosition", "Current Position", lat, long, "Drivers Current Position", "This is your Current Position", icons['info'].icon));
    //setTimeout(function () {
        //var la = lat;
        //var lo = long;
        //la = la + 0.001;
        //MapEngine.setMarker(new MarkerModel("currentPosition", "Current Position", la, lo, "Drivers Current Position", "This is your Current Position", icons['bus'].icon));
        //MapEngine.move(la, lo);
    //}, 1000);
}
MapEngine.setMarker = function (markerModel, isStop) {
    var marker;
    if (isStop)
    {
        if (MapEngine.stopStore.hasOwnProperty(markerModel.id)) {
            MapEngine.stopStore[markerModel.id].setPosition(new google.maps.LatLng(markerModel.lat, markerModel.long));
        }
        else {
            marker = new google.maps.Marker({
                position: new google.maps.LatLng(markerModel.lat, markerModel.long),
                title: markerModel.tooltip,
                map: MapEngine.map,
            });
            MapEngine.addListener(marker, markerModel);
            MapEngine.stopStore[markerModel.id] = marker;
        }
    }
    else {
        if (MapEngine.markerStore.hasOwnProperty(markerModel.id)) {
            MapEngine.markerStore[markerModel.id].setPosition(new google.maps.LatLng(markerModel.lat, markerModel.long));
        }
        else {            
            marker = new google.maps.Marker({
                position: new google.maps.LatLng(markerModel.lat, markerModel.long),
                title: markerModel.tooltip,
                map: MapEngine.map,
                icon: markerModel.icon
            });
            MapEngine.addListener(marker, markerModel);
            MapEngine.markerStore[markerModel.id] = marker;
        }
        //MapEngine.center = new google.maps.LatLng(MapEngine.markerStore[i].lat, MapEngine.markerStore[i].long);
    }
    //alert(markerModel.description);
}
MapEngine.addListener = function (marker, markerModel) {
    var me=this;
    marker.addListener('click', function () {
        var hasImage = false;
        $('#map_popup p.header').html(markerModel.title);
        if (markerModel.workOrders && markerModel.workOrders.length > 0) {
            for (var i = 0; i < markerModel.workOrders.length; i++) {
                markerModel.description = markerModel.workOrders[i].issueDescription;
                $('#map_popup>a.edit').attr('href', me.editURL + "/" + markerModel.workOrders[i].workOrderId);
                if (markerModel.workOrders[i].attachments && markerModel.workOrders[i].attachments.length>0)
                {
                    var w = $(window).width();
                    var h = $(window).height();
                    if (w < 300) w = 300;
                    if (h < 300) h = 300;
                    var url = me.attachmentsURL + '?workOrderId=' + markerModel.workOrders[i].workOrderId + '&workOrderAttachmentId=' + markerModel.workOrders[i].attachments.split(',')[0]
                    //$('#map_popup img.main')        .attr('src', url);
                    $('#map_popup img.thumbnail').attr('src', url);
                    $('#imgMain').attr('src', url);
                    $('#imgMain').css('max-width',w);
                    $('#imgMain').css('max-height', h);                    
                    $('#map_popup [href="#popupPhotoPortrait"]').show();
                    hasImage = true;
                    break;
                }
            }
        }
        $('#map_popup p.content').html(markerModel.description);
        if (!hasImage)
        {
            $('#map_popup img.thumbnail').attr('src', '');
            $('#imgMain').attr('src', '');
            $('#map_popup [href="#popupPhotoPortrait"]').hide();
            //$('#map_popup img.main').attr('src', '');
        }

        if (MapEngine.infoWindow != null)
            me.infoWindow.close();
        me.infoWindow = new google.maps.InfoWindow({ content: $('#map_popup').html() });
        me.infoWindow.open(MapEngine.map, marker);
    });
};
MapEngine.setCenter = function () {
    for(var i in MapEngine.markerStore)
    {
        //var center = new google.maps.LatLng(MapEngine.markerStore[i].lat, MapEngine.markerStore[i].long);
        MapEngine.map.setCenter(MapEngine.markerStore[i].position);
    }        
}
MapEngine.resize = function () {
    if (google) {
        google.maps.event.trigger(MapEngine.map, "resize");
        MapEngine.setCenter();
    }
}


function MarkerModel(id, tooltip, lat, long, title, description,workOrders, icon) {
    this.id = id;
    this.tooltip = tooltip;
    this.lat = lat;
    this.long = long;
    this.title = title;
    this.description = description;
    this.icon = icon;
    this.workOrders = workOrders;
}