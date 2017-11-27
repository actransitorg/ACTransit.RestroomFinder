function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
      s4() + '-' + s4() + s4() + s4();
}
var Attachment = function (file, data, tag, options) {
    var me = this;
    this.getFileType = function (name) {
        if (name) {
            var s = name.split('.');
            return s[s.length-1].toLowerCase();
        }
        return "";
    };
    this.getImageSrc = function (fileName, thumbnail, options) {
        var res = '';
        var fileType = me.getFileType(fileName);
        var basePath = options.imagePath;
        switch (fileType) {
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
                var d = data;
                if (thumbnail && options.dataType == "url")
                    d += "&asImage=false&thumbnail=true";
                res= d;
                break;
            case "svg":
                res=basePath + "svg.jpg";
                break;
            case "pdf":
                res=basePath + "pdf.jpg";
                break;
            case "xlsx":
            case "xls":
                res=basePath + "excel.png";
                break;
            case "docx":
            case "doc":
                res=basePath + "word.png";
                break;
            default:
                res=basePath + "unknown.png";
                break;
        }
        return res;
    };
    options = options || {};
    options.target = options.target || '';
    options.size = options.size || 'small';
    options.downloadEnabled = typeof options.downloadEnabled === "undefined" ? true : options.downloadEnabled;
    options.deleteEnabled = typeof options.deleteEnabled === "undefined" ? true : options.deleteEnabled;
    options.unDeleteEnabled = typeof options.unDeleteEnabled === "undefined" ? true : options.unDeleteEnabled;
    options.onDownload = options.onDownload || null;
    options.onDelete = options.onDelete || null;
    options.onUnDelete = options.onUnDelete || null;
    options.imagePath = options.imagePath || (window.location.protocol + "//" + window.location.host + "/Content/Images/");
    options.dataType = options.dataType || "url";

    options.target = guid();

    if (typeof file === "undefined" || typeof file.name === "undefined" || typeof data === "undefined") return;
    var divParent = $("<div class='attachment " + options.size + "'></div>");
    var divPanel = $("<div class='panel panel-default'></div>");
    var anchor = $("<a href='#" + options.target + "' data-rel='popup' data-position-to='window' data-transition='fade'></a>");
    $(anchor).attr('title', file.name);
    var image = $("<img class='thumbnail img-responsive'/>");

    var src = me.getImageSrc(file.name, true, options);
    $(image).attr('src', src);

    
    var divAction = $("<div class='action'></div>");
    var spanDownload = $("<span class='glyphicon glyphicon-download' aria-hidden='true' title='Download'></span>");
    var spanDelete = $("<span class='glyphicon glyphicon-trash' aria-hidden='true' title='Delete'></span>");
    var divUndelete = null;


    var p = $("<p class='pull-right'></p>");
    var maxFileName = options.size.toLowerCase() == "xsmall" ? 9 : 18;
    var fName = file.name;
    //if (fName.length > (maxFileName+2))
        //fName = file.name.slice(0, maxFileName) + "...";
    $(p).html(fName);
    $(p).attr('title',fName);
    if (options.downloadEnabled) {
        $(spanDownload).click(function () {
            if (options.onDownload)
                if (!options.onDownload(me, file, data, tag)) return;
            window.open(data);
        });
        $(divAction).append(spanDownload);
    }
    if (options.deleteEnabled) {
        $(spanDelete).click(function () {
            if (options.onDelete)
                if (!options.onDelete(me, file, data, tag)) return;
            if (options.unDeleteEnabled && divUndelete) {
                $(divUndelete).show();
            }
            else {
                $(divParent).remove();
            }

        });
        $(divAction).append(spanDelete);
    }

    $(divAction).append(p);

    $(anchor).append(image);
    $(divPanel).append(anchor);
    $(divPanel).append(divAction);

    if (options.unDeleteEnabled) {
        divUndelete = $("<div class='overlay'><div></div></div>");
        var btnUndelete = $("<a class='btn btn-default' data-role='none' title='Undelete'>Undelete</a>");
        $(btnUndelete).click(function () {
            if (options.onUnDelete)
                if (!options.onUnDelete(me, file, data, tag)) return;
            $(divUndelete).hide();
        });
        $(divUndelete).append(btnUndelete);
        $(divPanel).append(divUndelete);
    }
    $(divParent).append(divPanel);

    var divPopup = $('<div data-role="popup" id="' + options.target + '" class="photopopup" data-overlay-theme="a" data-corners="false" data-tolerance="30,15"></div>')[0];
    var anchor = $('<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>');
    var header = $('<div data-role="header" data-theme="a"></div>');
   
    var headerH1 = $('<h2>' + file.name + '</h2>');
    var headerH2 = $('<h3>' + "Uploaded: " + file.date + '</h3>');
    $(header).append(headerH1);
    if (file.date) $(header).append(headerH2);
    

    $(divPopup).append(anchor);

    if (file.name) $(divPopup).append(header);

    var img1 = $(image).clone();
    src = me.getImageSrc(file.name, false, options);    
    $(img1).attr('src', "");
    $(divPopup).append(img1);

    $(divPopup).on("popupbeforeposition", function (event, ui, data) {
        var img = $(event.currentTarget).find('img');
        $(img1).attr('src', src);
    });


    $(divParent).prepend(divPopup);
    $(divParent).enhanceWithin().popup();
    return divParent;
}

var AttachmentViewer = function (parent, options) {
    var me = this;
    var files = [];
    options.target = options.target || 'popupPhotoPortrait';
    if (options.target.slice(0, 1) == "#") options.target = options.target.slice(1, options.target.length);
    options.size = options.size || 'small';
    options.downloadEnabled = typeof options.downloadEnabled === "undefined" ? true : options.downloadEnabled;
    options.deleteEnabled = typeof options.deleteEnabled === "undefined" ? true : options.deleteEnabled;
    options.unDeleteEnabled = typeof options.unDeleteEnabled === "undefined" ? true : options.unDeleteEnabled;
    options.onDownload = options.onDownload || null;
    options.onDelete = options.onDelete || null;
    options.imagePath = options.imagePath || null;

    this.currentAnchor = null;
    this.initial = function () {        
        ////var divPopup = $("#popupPhotoPortrait");
        //var divPopup = $('<div data-role="popup" id="' + options.target + '" class="photopopup" data-overlay-theme="a" data-corners="false" data-tolerance="30,15"></div>')[0];
        //var anchor = $('<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>');
        //$(divPopup).append(anchor);
        //$(parent).prepend(divPopup);
        
        //$(divPopup).off("popupbeforeposition");
        //$(divPopup).off("popupafterclose");

        ////$(divPopup).on("popupbeforeposition", function (event, ui, data) {
        //    var img = $(event.currentTarget).find('img');
        //    if (img && typeof img != 'undefined' && img != null)
        //        $(img).remove();
        //    var img = $($(me.currentAnchor).html());
        //    $(img).css('max-width', $(window).width() - 40);
        //    //$(img).css('max-height', $(window).height() - 100);
        //    $(event.currentTarget).append(img);
        //});
        //$(divPopup).on("popupafterclose", function (event, ui, data) {
        //    var img = $(event.currentTarget).find('img');
        //    $(img).remove();
        //    //$(event.currentTarget).remove
        //});
    };
    this.add = function (file, data, tag, dataType) {
        if (typeof file === "undefined" || typeof file.name === "undefined" || typeof data === "undefined") return;
        dataType = dataType || "url";
        var img = new Attachment(file, data, tag, {                        
            target: options.target,
            size: options.size,
            imagePath: options.imagePath,
            downloadEnabled: options.downloadEnabled,
            deleteEnabled: options.deleteEnabled,
            unDeleteEnabled: options.unDeleteEnabled,
            dataType: dataType,
            onDownload: options.onDownload,
            onUnDelete: options.onUnDownload,
            onDelete: function (imgObj, f, d, t) {
                if (options.onDelete)
                    if (!options.onDelete(imgObj, f, d, t)) return;
                var found = false;
                for (var i = 0; i < files.length; i++) {
                    if (files[i].file.name == f.name && files[i].data == d) {
                        files.splice(i, 1);
                        found = true;
                        break;
                    }
                }
                return found;
            },
            onUnDelete: function (imgObj, f, d, t) {
                if (options.onUnDelete)
                    if (!options.onUnDelete(imgObj, f, d, t)) return false;
                files.push({ 'file': f, 'data': d });
                return true;
            }
        });
        $(img).find("a[href='#" + options.target + "']").click(function () {
            me.currentAnchor = this;
            return true;
        });
        $(parent).append(img);
        files.push({ 'file': file, 'data': data });
    };
    this.clear = function () {
        $(parent).find(".attachment").remove();
    };
    this.getFiles = function () {
        return files;
    };
    this.initial();
}

var FileUploader = function (parent, popupId, baseImagePath) {
    var me = this;
    //var files = [];
    var attachmentViewer = null;
    this.initial = function (popupId) {
        var file = $("div.file")[0];
        var filedrag = $(parent).find("#filedrag");
        var fileselect = $(parent).find("#fileselect");
        attachmentViewer = new AttachmentViewer(filedrag, {
            target: popupId,
            size: 'xsmall',
            unDeleteEnabled: false,
            downloadEnabled: false,
            imagePath:baseImagePath
        });

        if (window.File && window.FileList && window.FileReader) {
            $(fileselect).on('change',me.fileSelectHandler);
            $(file).on(
                'dragover', me.fileDragHover
                //function (e) {
                //    e.preventDefault();
                //    e.stopPropagation();
                //}
            )
            $(file).on(
                'dragenter', me.fileDragHover
                //function (e) {
                //    e.preventDefault();
                //    e.stopPropagation();
                //}
            )
            $(file).on(
                'drop',me.fileSelectHandler    
                //function (e) {
                //    fileSelectHandler(e);
                ////    if (e.originalEvent.dataTransfer) {
                ////        if (e.originalEvent.dataTransfer.files.length) {
                ////            e.preventDefault();
                ////            e.stopPropagation();
                ////            /*UPLOAD FILES HERE*/
                ////            upload(e.originalEvent.dataTransfer.files);
                ////        }
                ////    }
                //}
            );
        }
       

        //if (window.File && window.FileList && window.FileReader) {
        //    var fileselect = document.getElementById("fileselect"),
        //        filedrag = document.getElementById("filedrag");
        //    fileselect.addEventListener("change", me.fileSelectHandler, false);
        //    if (new XMLHttpRequest().upload) {
        //        filedrag.addEventListener("dragover", me.fileDragHover, false);
        //        filedrag.addEventListener("dragleave", me.fileDragHover, false);
        //        filedrag.addEventListener("drop", me.fileSelectHandler, false);                
        //        // not supported by IE (as of current v11)
        //        if (navigator.userAgent.indexOf('MSIE ') == -1 && navigator.userAgent.indexOf('Trident/') == -1)
        //            filedrag.style.visibility = "visible";
        //    }
        //}
    };
    this.getFiles = function () {
        return attachmentViewer.getFiles();
    }
    this.appendFile = function (file, data) {
        attachmentViewer.add(file, data,null, "base64");
    };

    this.parseFile = function (file) {
        var reader = new FileReader();
        reader.onload = function (e) {
            me.appendFile(file, e.target.result);
        }
        reader.readAsDataURL(file);
    };

    this.fileDragHover = function (e) {
        e.stopPropagation();
        e.preventDefault();
        //e.target.className = (e.type == "dragover" ? "hover" : "");
    };

    this.fileSelectHandler = function (e) {
        me.fileDragHover(e);
        var files = e.target.files;
        if (e.dataTransfer)
            files = files || e.dataTransfer.files;
        else
            files = files || e.originalEvent.dataTransfer.files;
        for (var i = 0, f; f = files[i]; i++) {
            me.parseFile(f);
        }
    };


    this.initial(popupId);
}

