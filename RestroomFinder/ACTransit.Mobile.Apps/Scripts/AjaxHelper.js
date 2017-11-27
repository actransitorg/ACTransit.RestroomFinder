
var Ajax = {
    ajax: function (url, options, waitBox) {
        var wb = waitBox;
        var prom = $.Deferred();
        if (wb != null)
            wb.show();

        $.ajax(url, options).success(function (data) {
            try {
                prom.resolve(data);
            } catch (e) {
                alert(e.message);
            }
        }).fail(function (e, eType, message) {
            prom.reject();
            var m = message;
            if (typeof (e.responseJSON) !== 'undefined' && typeof (e.responseJSON.error) !== 'undefined' && e.responseJSON.error)
                m = e.responseJSON.message;
            modal.show("Failed", m, { showRefresh: false });
        }).always(function () {
            if (wb != null) wb.hide();
        });
        return prom;
    },
}
