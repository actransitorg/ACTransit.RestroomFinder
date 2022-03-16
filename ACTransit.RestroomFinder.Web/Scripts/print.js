PrintForm = function (selector, titleName, contentDir, scriptsDir) {
    var dispSetting = "toolbar=no,location=no,directories=no,menubar=no,scrollbars=no,width=816,height:1344,left=5,top=5";
    var printWindow = window.open("", "_blank", dispSetting);
    try {
        var content = ($(selector).length) ? $(selector).html() : $("body").html();
        var html =
            '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head><title>' + titleName +'</title>' +
            '<link type="text/css" rel="stylesheet" href="' + contentDir + '/bootstrap.min.css" />' +
            '<link type="text/css" rel="stylesheet" href="../' + contentDir + '/print.css" media="print"/>' +
            '<script src="' + scriptsDir + '/jquery-3.3.1.js"></script>' +
            '</head><body><div>' + content + '</div></body></html>';
        
        printWindow.document.open();
        printWindow.document.write(html);
    } catch (e) {
        alert("Error Printing: " + e.message);
    } finally {
        setTimeout(function () {
            printWindow.document.close();
            printWindow.print();
            setTimeout(function () {
                printWindow.close();
            }, 1000);
        }, 1000);
    }
}