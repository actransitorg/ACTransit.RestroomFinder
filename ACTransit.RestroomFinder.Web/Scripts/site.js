"use strict";

function initPage(options) {
    if (options.hasSortTable)
        initSortTable();
    if (options.hasSearchPanels)
        initSearchPanels();
}

function initSortTable() {

    //Set sorting image to the required cell
    var sortField = $("#SortField").val();
    var sortDirection = $("#SortDirection").val();

    const container = $("[data-sortfield='" + sortField + "']").closest("th").find("div");
    container.removeClass("glyphicon glyphicon-sort");
    container.addClass((sortDirection === "ascending"
        ? "glyphicon glyphicon-sort-by-attributes"
        : "glyphicon glyphicon-sort-by-attributes-alt"));

    //Define sorting actions when a header cell is clicked
    $(".sortable").click(function (e) {

        const sortfield = $(this).data("sortfield");

        if (sortField === sortfield) {
            if (sortDirection === "ascending")
                $("#SortDirection").val("descending");
            else
                $("#SortDirection").val("ascending");
        } else {
            $("#SortField").val(sortfield);
            $("#SortDirection").val("ascending");
        }
        e.preventDefault();
        $("#SearchForm").submit();
    });
}

function initSearchPanels() {
    $(".panel .panel-collapse").on('shown.bs.collapse', function () {
        const active = $(this).attr('id');
        $.cookie(active, "1");
    });

    $(".panel .panel-collapse").on('hidden.bs.collapse', function () {
        const active = $(this).attr('id');
        $.removeCookie(active);
    });
}

function resetForm($form, defaultSortField) {
    //Reset values and selections on input fields
    $form.find('input:text, input:password, input:hidden, input:file, select, textarea').val('');
    $form.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');

    //Set selections to defaults on dropdowns
    $('#ShowActive').val('All');

    //Set default values for sorting after resetting the form
    $('#SortField').val(defaultSortField);
    $('#SortDirection').val('ascending');
}

function setRestroomTableStyle(tableref) {
    if ($(window).width() <= 760) {
        if (tableref.hasClass("table table-bordered table-striped"))
            tableref.removeClass("table table-bordered table-striped")
    }
    else
        if (!tableref.hasClass("table table-bordered table-striped"))
            tableref.addClass("table table-bordered table-striped")
}

function reverseGeocode(address, callback) {
    var validatedAddress = null;
    $.get('https://maps.googleapis.com/maps/api/geocode/json',
        { address: address, key: 'AIzaSyBzfu3qHr2PXlQYxICUVovpWJU7SsFl0Eg' },
        function (data) {
            if (data.hasOwnProperty('error_message') && data.error_message.length > 0) {
                alert('Google API reported an error while trying to geocode the address: ' + data.error_message);
                console.log('Google API reported an error while trying to geocode the address: ' + data.error_message);
            }
            else {
                if (data.status === 'OK' && data.results.length > 0) {
                    var myaddress = data.results[0].formatted_address.split(',');
                    validatedAddress = {
                        Address: $.trim(myaddress[0]),
                        City: $.trim(myaddress[1]),
                        State: $.trim(myaddress[2]).split(" ")[0],
                        Zip: $.trim(myaddress[2]).split(" ")[1],
                        Lat: data.results[0].geometry.location.lat,
                        Lng: data.results[0].geometry.location.lng
                    };
                }
            }
        })
        .fail(function () {
            alert('There was an error trying to connect to Google\'s geocoding API');
            console.log('There was an error trying to connect to Google\'s geocoding API');
        })
        .always(function () {
            callback(validatedAddress);
        });
}

//Draggable modals
$(".modal-header").on("mousedown", function (mousedownEvt) {
    var $draggable = $(this);
    console.log('draggable Y' + mousedownEvt.pageY);
    console.log('draggable Y' + mousedownEvt.pageY);
    var x = mousedownEvt.pageX - $draggable.offset().left,
        y = mousedownEvt.pageY - $draggable.offset().top;
    $("body").on("mousemove.draggable", function (mousemoveEvt) {
        $draggable.closest(".modal-dialog").offset({
            "left": mousemoveEvt.pageX - x,
            "top": mousemoveEvt.pageY - y
        });
    });
    $("body").one("mouseup", function () {
        $("body").off("mousemove.draggable");
    });
    $draggable.closest(".modal").one("bs.modal.hide", function () {
        $("body").off("mousemove.draggable");
    });
});
