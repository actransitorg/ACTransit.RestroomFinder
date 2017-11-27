var currentPage = null;
$(document).on("pagecontainerbeforeshow", function (event, ui) {
    var id = "";
    if (ui && ui.toPage && $(ui.toPage)[0])
        id=$(ui.toPage)[0].id;

    switch (id) {
        case "index":
            currentPage = indexPage;
            break;
        case "edit":
            currentPage = editPage;
            break;
        default:
            currentPage = null;
            break;
    }
    if (currentPage!=null) currentPage.pageShow(event, ui);
});
$(document).on("pagecontainerbeforehide", function (event, ui) {
    currentPage = null;
});

var indexPage = {
    loaded: false,
    mapInitilized: false,
    map: null,
    center: null,
    mapId: 'map_canvas',
    stopIds: [],
    attachmentsURL:'',
    initial: function (stopIds, editURL, attachmentsURL) {
        var me = this;
        currentPage = indexPage;
        me.stopIds = stopIds;
        me.attachmentsURL = attachmentsURL;
        me.editURL = editURL;
        if (!this.loaded) {
            //$(document).on("pagecontainerbeforechange", function (event, ui) { alert('here'); });

            //$(document).delegate("#index", "pagebeforecreate", function () {
            //    me.initPage("index");
            //});
            //$(document).delegate("#index", "pagebeforeshow", function (e, ui) {
            //    if (typeof me.pageShow != "undefined" && me.pageShow) me.pageShow(e, ui,"index");
            //});
            $(document).delegate("#index", "pageshow", function () {});
            $(window).resize(me.setSize.bind(me));
            $("#index #tabList").click(function () {                
            }).bind(me);
            $("#index #tabMap").click(function () {
                me.initialMap();
            }).bind(me);
            this.loaded = true;
        }
    },
    initPage: function (e, ui,pageName) {
        
    },
    pageShow: function (e, ui) {
        var me = this;
        if (typeof me.initPage != "undefined" && me.initPage) me.initPage(e, ui,"index");
        $("#tabs").tabs( "refresh" );
    },

    initialMap: function () {        
        var me = this;
        if (!me.mapInitilized) {
            //me.center = new google.maps.LatLng(37.867931, -122.267784);
            //me.initializeMap();
            MapEngine.initilize(37.867931, -122.267784);
            me.setSize();
            //google.maps.event.addDomListener(window, 'load', me.initializeMap.apply(me));
            //google.maps.event.addDomListener(window, "resize", me.resizeMap.apply(me));
            me.mapInitilized = true;
        }
        else {
            me.setSize();
        }
        me.setStops(me.stopIds,me.editURL, me.attachmentsURL);
    },
    setStops: function (data,editURL, attachmentsURL) {
        MapEngine.setStops(data, editURL, attachmentsURL);
    },

    setSize: function () {
        var me = this;
        try {
  
        }
        catch (e) {
            alert(e);
        }

        setTimeout(function () {
            try {

                var tabMap = '#tabMap';
                var footer = 'div[data-role="footer"]';
                //alert($('div[data-role="footer"]').height());
                //alert($(tabMap).height());
                var height = $(window).height() - $(tabMap).offset().top - $(tabMap).height() - 29;
                if ($(footer).is(':visible')) {
                    height = height - $(footer).height();
                }

                var width = $(window).width();
                $("#" + me.mapId).height(height);


                MapEngine.resize();
            }
            catch (e) {}
        }, 100);    
    },
}

var editPage = {
    loaded: false,
    initial: function () {
        var me = this;
        currentPage = editPage;
        if (!this.loaded) {
            //$(document).delegate("#edit", "pagebeforecreate", function () {
            //    if (typeof me.initPage != "undefined" && me.initPage) me.initPage("edit");
            //});
            //$(document).delegate("#edit", "pagebeforeshow", function (e, ui) {
            //    if (typeof me.pageShow != "undefined" && me.pageShow) me.pageShow(e, ui,"edit");
            //});
            this.loaded = true;
        }
    },
    pageShow: function (e, ui, pageName) {
        var me = this;
        if (typeof me.initPage != "undefined" && me.initPage) me.initPage(e, ui, pageName);
        $("select:disabled").each(function () {
            var val = $(this).find("option:selected").val();
            var name = $(this).attr('name');
            var input = $('<input name="' + name + '" type="hidden" value="' + val + '" />');
            $(this).after(input);
            return;
        });
        $('.readonly').change(preventDefault);
        $('.readonly input').change(preventDefault);
        $('.readonly').click(preventDefault);
        $('.readonly input').click(preventDefault);
        $("input.readonly[type='checkbox']").checkboxradio('disable');
        function preventDefault(e) {
            e.preventDefault ? e.preventDefault() : (e.returnValue = false);
            return false;
        }
    },
    handleSubmit: function(parent, lastIndex, url, succUrl, files){
        $(parent).find("form").submit(function (e) {
            //e.preventDefault();                        
            $(parent).find('div[data-filerole="newfiles"]').remove();
            for (var i = 0; i < files.length; i++) {
                editPage.createAttachments(parent, files[i].file, files[i].data, lastIndex+i);
            }
            //$.post(url, $(this).serialize(), function (response) {
            //    $.mobile.changePage(succUrl, {
            //        allowSamePageTransition: true,
            //        transition: 'none',
            //        reloadPage: true});
            //});

            return true;
        });

    },
    createAttachments: function (parent, file, data, index) {
        var div = $('<div data-filerole="newfiles"></div>');
        var inp1 = $('<input type="hidden" id="Attachments[' + index + ']_WorkOrderId" name="Attachments[' + index + '].WorkOrderId" value="0" />');
        var inp2 = $('<input type="hidden" id="Attachments[' + index + ']_WorkOrderAttachmentId" name="Attachments[' + index + '].WorkOrderAttachmentId" value="0" />');
        var inp3 = $('<input type="hidden" id="Attachments[' + index + ']_MimeType" name="Attachments[' + index + '].MimeType" value="' + file.type + '" />');
        var inp4 = $('<input type="hidden" id="Attachments[' + index + ']_ShouldDelete" name="Attachments[' + index + '].ShouldDelete" value="false" />');
        var inp5 = $('<input type="hidden" id="Attachments[' + index + ']_Base64Data" name="Attachments[' + index + '].Base64Data"  value="' + data + '" />');
        var inp6 = $('<input type="hidden" id="Attachments[' + index + ']_Name" name="Attachments[' + index + '].Name" value="' + file.name + '" />');
        var inp7 = $('<input type="hidden" id="Attachments[' + index + ']_FileSizeKB" name="Attachments[' + index + '].FileSizeKB" value="' + Math.round(file.size / 1024) + '" />');
        $(div).append(inp1);
        $(div).append(inp2);
        $(div).append(inp3);
        $(div).append(inp4);
        $(div).append(inp5);
        $(div).append(inp6);
        $(div).append(inp7);
        $(parent).find('form').append(div);
    }
}
