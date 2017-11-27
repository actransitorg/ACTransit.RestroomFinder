(function ($) {
    $.fn.multiCheckCombo = function (options) {
        "use strict";
        var me = this;
        options = options || {};

        var _allButton = typeof (options.allButton) === 'undefined' ? null : options.allButton;
        var _delimiter = typeof (options.delimiter) === 'undefined' ? ';' : options.delimiter;

        var contentDiv, scrollDiv, ul;
        var _canBeClosedByFocusout = false;

        me.onClosed = function () {
            if (typeof (options.onClosed) !== 'undefined') {
                options.onClosed(null);
            }
        };

        me.onClosing = function () {
            var canContinue = true;
            if (typeof (options.onClosing) !== 'undefined') {
                var e = { 'continue': true };
                options.onClosing(e);
                canContinue = e["continue"];
            }
            if (canContinue) { setValues(); }
            return canContinue;
        };
        me.onOpen = function () {
            if (typeof (options.onOpen) !== 'undefined') {
                var e = { 'continue': true };
                options.onOpen(e);
                return e["continue"];
            }
            return true;
        };

        me.isOpen = function () {
            return $(contentDiv).is(':visible');
        };

        me.toggle = function () {
            var allowToProceed = false;
            var callClosed = false;
            if (me.isOpen()) {
                if (me.onClosing()) {
                    allowToProceed = true;
                    callClosed = true;
                }
            }
            else if (me.onOpen()) {
                allowToProceed = true;
            }
            if (allowToProceed)
                $(contentDiv).toggle(
                    {
                        duration: 100, done: function () {
                            if (callClosed) me.onClosed();
                        }
                    }
                );
        };

        me.close = function () {
            var allowToProceed = false;
            var closing = false;
            if (me.isOpen()) {
                closing = true;
                if (me.onClosing()) allowToProceed = true;
            }
            if (allowToProceed) {
                $(contentDiv).toggle();
                if (closing) me.onClosed();
            }
        };

        me.toString = function () {
            var selectedStr = '';
            $(ul).find('>li>input[type="checkbox"]').each(function () {
                if ($(this).attr('data-multiCombo-role') !== 'all') {
                    if ($(this).prop('checked')) {
                        if (selectedStr.length > 0) selectedStr += _delimiter + " ";
                        selectedStr += $(this).next('span').html();
                    }
                }
            });
            return selectedStr;
        };

        me.toSelectListItems = function () {
            var result = [];
            $(ul).find('>li>input[type="checkbox"]').each(function () {
                if ($(this).attr('data-multiCombo-role') !== 'all') {
                    var obj = new Object();
                    obj.Text = $(this).next('span').html();
                    obj.Value = $(this).attr('value');
                    obj.selected = $(this).prop('checked');
                    result.push(obj);
                }
            });
            return result;
        };

        me.toValueString = function () {
            var selectedStr = '';
            $(ul).find('>li>input[type="checkbox"]').each(function () {
                if ($(this).attr('data-multiCombo-role') !== 'all') {
                    if ($(this).prop('checked')) {
                        if (selectedStr.length > 0) selectedStr += _delimiter;
                        selectedStr += $(this).attr('value');
                    }
                }
            });
            return selectedStr;
        };

        me.toValues = function () {
            var selectedStr = [];
            $(ul).find('>li>input[type="checkbox"]').each(function () {
                if ($(this).attr('data-multiCombo-role') !== 'all') {
                    if ($(this).prop('checked')) {
                        selectedStr.push($(this).attr('value'));
                    }
                }
            });
            return selectedStr;
        };

        me.add = function (name, value, checked) {
            var checkedStr = '';
            if (checked)
                checkedStr = 'checked="checked"';
            $(ul).append('<li><input type="checkbox" value="' + value + '" ' + checkedStr + '/><span>' + name + '</span></li>');
        };

        me.remove = function (name, value, checked) {
            var input = $(ul).find('li input[value="' + value + '"');
            if (input.length > 0)
                input.parent('li').remove();
        };

        me.count = function () {
            return $(ul).find("li").length;
        };


        me.selectAll = function () { setAll(true); };

        me.deSelectAll = function () { setAll(false); };

        me.refresh = function () {
            initial();
            //initialValues();
        };

        function initial() {
            contentDiv = $(me).find('>div').first();
            scrollDiv = $(contentDiv).find('>div').first();
            ul = $(scrollDiv).find('>ul');

            if (ul.length === 0) ul = $(scrollDiv).find('>ol');



            $(me).addClass("multiCheckCombo");

            $(me).find('#multiCheckCombo_span_down').remove();
            $(me).find('>input[type="text"]').after("<span id='multiCheckCombo_span_down'>&or;</span>");

            if (_allButton && _allButton.top) ul.prepend("<li><input type='checkbox' data-multiCombo-role='all' />" + _allButton.text + "</li>");
            if (_allButton && !_allButton.top) ul.append("<li><input type='checkbox' data-multiCombo-role='all' />" + _allButton.text + "</li>");

            $(me).mouseleave(function () { _canBeClosedByFocusout = true; });
            $(me).mouseenter(function () { _canBeClosedByFocusout = false; });

            $(me).focusout(function () {
                if (_canBeClosedByFocusout) me.close();
            });

            $(me).unbind('click');
            $(me).click(function () {
                me.toggle();
            });

            $(contentDiv).unbind('click');
            $(contentDiv).click(function (e) {
                e.stopPropagation();
            });
            $(ul).find(">li").unbind('click');
            $(ul).find(">li").click(function (e) {
                var checked = $(this).find('>input[type="checkbox"]').prop('checked');
                $(this).find('>input[type="checkbox"]').prop('checked', !checked);
                $(this).find('>input[type="checkbox"]').each(function () { $(this).change(); });
                e.stopPropagation();
            });
            $(ul).find(">li>input[type='checkbox']").unbind('change');
            $(ul).find(">li>input[type='checkbox']").change(function (e) {
                var checked = $(this).prop('checked');
                if ($(this).attr('data-multiCombo-role') === 'all') {
                    $(ul).find(">li>input[type='checkbox']").prop('checked', checked);
                }
                checkforAll();
                //
            });
            $(ul).find(">li>input[type='checkbox']").unbind('click');
            $(ul).find(">li>input[type='checkbox']").click(function (e) {
                e.stopPropagation();
            });

            initialValues();
        }

        function initialValues() {
            setValues();
            checkforAll();
        }

        function checkforAll() {
            var allSelected = true;
            $(ul).find('>li>input[type=checkbox]').each(function (e) {
                if (!$(this).prop('checked') && $(this).attr('data-multiCombo-role') !== 'all') {
                    allSelected = false;
                    return;
                }
            });
            var all = $(ul).find('>li>input[type="checkbox"][data-multiCombo-role]');
            all.each(function () { $(this).prop('checked', allSelected); });
        }

        function setAll(checked) {
            $(ul).find('>li>input[type=checkbox]').each(function (e) {
                $(this).prop('checked', checked);
            });
            setValues();
        }

        function setValues() {
            $(me).find('>input[type="text"]').val(me.toString());
            $(me).find('>input[type="hidden"]').val(me.toValueString());
        }

        initial();
        return this;
    };

}(jQuery));
