/**
 * Created by seongdonghun on 2016. 11. 21..
 */

GridWrapper = function (params) {
    this.id = params.targetLayer;
    this.actNm = params.actNm;
    this.qKey = params.qKey;
    this.width = (!$.comm.isNull(params.width) ? params.width+"px" : "100%");
    this.gridDataBodyId = params.targetLayer + "_tbody";
    this.gridNaviId   = (params.gridNaviId   ? params.gridNaviId   : params.targetLayer + "_navi");
    this.countId      = (params.countId      ? params.countId      : 'totCnt');
    this.headers      = (params.headers      ? params.headers      : null);
    this.paramsFormId = (params.paramsFormId ? params.paramsFormId : "commonForm");
    this.requestUrl   = (params.requestUrl   ? params.requestUrl   : "/common/selectGridPagingList.do");
    this.preScript    = (params.preScript    ? params.preScript    : null);
    this.postScript   = (params.postScript   ? params.postScript   : null);
    this.btns         = (params.controllers  ? params.controllers  : []);
    this.gatherParams = (params.paramsGetter ? params.paramsGetter : {});
    this.dbPoolName   = (params.dbPoolName   ? params.dbPoolName   : "default");

    this.firstLoad    = (!$.comm.isNull(params.firstLoad)   ? params.firstLoad      : true);
    this.check        = (!$.comm.isNull(params.check)       ? params.check          : false);
    this.onlyOneCheck = (!$.comm.isNull(params.onlyOneCheck)? params.onlyOneCheck   : false);
    this.checkPosit   = (!$.comm.isNull(params.checkPosit)  ? params.checkPosit     : false);
    this.checkScript  = (params.checkScript ? params.checkScript : null);

    this.totWidth     = 0;  // 테이블 전체 넓이
    this.cellHeight   = 36; // cell 높이
    this.checkId      = params.targetLayer+"Chk";
    this.checkAllId   = this.checkId + "All";

    this.totalCount   = 0; // Total count

    this.dataObj = new Array();

    //paging parameter
    this.PAGE_INDEX    = 0;
    this.PAGE_ROW      = (params.pageRow ? params.pageRow : 10);
    this.SCROLL_PAGING = (params.scrollPaging ? params.scrollPaging : false);
    this.IS_REQ_SCROLL = false;

    this.gridPageMoveId = params.targetLayer + "_page_index";

    this.IS_FIELD_SELECT = (!$.comm.isNull(params.fieldSelect)   ? params.fieldSelect : false);
    this.FIELD_SELECT_ID = (!$.comm.isNull(params.fieldSelectId) ? params.fieldSelectId : null);

    // css
    this.tableClass  = (params.tableClass  ? params.tableClass  : "tableList lineR");
    this.pagingClass = (params.pagingClass ? params.pagingClass : "paging");

    // 그리드 부속 display 여부
    this.displayNone = (params.displayNone ? params.displayNone : []);
    this.displayCountId = true;
    this.displayPageRowCombo = true;

    this.containId = this.id + "_contain";
    this.headerId  = this.id + "_header_bg";
    this.bodyId    = this.id + "_table_wrapper";

    this.headerTableId = this.id + "_header_table";
    this.bodyTableId   = this.id + "_table";

    // 소팅
    this.sortType = (params.sortType ? params.sortType : "multi"); // multi or sing
    this.defaultSort = params.defaultSort;
    this.sortColInfo = [];

    this.initializeLayer();
}

GridWrapper.prototype = {

    initializeLayer : function () {
        if(this.paramsFormId == "commonForm"){
            $("#commonForm")[0].reset();
            $("#commonForm").empty();
        }

        for(var i=0; i<this.displayNone.length; i++){
            var obj = this.displayNone[i];
            if(obj == "countId"){
                this.displayCountId = false;
            }else if (obj == "pageRowCombo"){
                this.displayPageRowCombo = false;
            }
        }

        $('#' + this.id).attr('class', "list_typeB grid_scroll");

        this.addParam("qKey", this.qKey);

        // 필드변경
        var actionMenuId = $.page.getMenuId();
        if(actionMenuId){
            var h = localStorage.getItem(actionMenuId);
            if(!$.comm.isNull(h)){
                var headerArr = JSON.parse(h);
                $.each(this.headers, function (idx, data) {
                    var fieldName = data["FIELD_NAME"];
                    if($.inArray(fieldName, headerArr) < 0){
                        data["HIDDEN"] = "true";
                    }else{
                        data["HIDDEN"] = "false";
                    }
                })
            }
        }

        // 그리드 생성
        this.drawGrid();

        if(this.firstLoad){
            this.requestToServer();
        }

        for(var i=0; i<this.btns.length; i++){
            var currObj = $('#' + this.btns[i]["btnName"])[0];
            if(!currObj){
                //alert(this.btns[i]["btnName"] + " is not defined!");
                continue;
            }

            currObj.btn_type   = this.btns[i]["type"];
            currObj.targetURI  = this.btns[i]["targetURI"];
            currObj.preScript  = this.btns[i]["preScript"];
            currObj.postScript = this.btns[i]["postScript"];
            currObj.qKey       = this.btns[i]["qKey"];

            currObj.wrapper = this.id;

            currObj.onclick = $.comm.bindAsListener(this.buttonClick, this);
        }

        $('#PAGE_ROW').val(this.PAGE_ROW);

        this.paramsAddOnclickEvent();

        if(this.SCROLL_PAGING){
            $("#" + this.bodyId).scroll($.comm.bindAsListener(this.scrollPaging, this));
        }
    },
    drawGrid : function () {
        this.totWidth  = 0;
        var checkWidth = 53; // CHECK BOX 넓이
        var noWidth    = 57; // No 넓이

        var containDiv = $("<div>");
        containDiv.css({"position":"relative", "overflow":"hidden", "border-width":"0px", "width":"100%", "height":"100%"});
        containDiv.attr("id", this.containId);

        var headerDiv = $("<div>");
        headerDiv.addClass("header_bg");
        headerDiv.attr("id", this.headerId);

        var bodyDiv = $("<div>");
        bodyDiv.addClass("table_wrapper");
        bodyDiv.attr("id", this.bodyId);

        var headerTable = $("<table>");
        headerTable.attr("style", "width:" + this.width);
        headerTable.attr("id", this.headerTableId);

        var bodyTable = $("<table>");
        bodyTable.attr("style", "width:" + this.width);
        bodyTable.attr("id", this.bodyTableId);

        var thead = $("<thead>");
        var tr = $("<tr>");
        var th = $("<th>");
        var div = "<div>";

        // 체크박스 생성
        if(this.check && !this.onlyOneCheck){
            th.attr("width", checkWidth);

            div = $("<div>");
            div.addClass("th_text");
            div.attr("style", "height: " + this.cellHeight + "px");

            div.append('<input type="checkbox" id="' + this.checkAllId + '">');
            div.append('<label for="' + this.checkAllId + '"><span style="margin-top: 12px;"></span></label>');

            th.append(div);
            tr.append(th);

            this.totWidth += checkWidth; // 전체 넓이에 추가

        }else if(this.onlyOneCheck){
            th.attr("width", checkWidth);

            div = $("<div>");
            div.addClass("th_text");
            div.html("선택");

            th.append(div);
            tr.append(th);

            this.totWidth += checkWidth;
        }

        // No 생성
        th = $("<th>");
        th.attr("width", noWidth);

        div = $("<div>");
        div.addClass("th_text");
        div.html("No");

        th.append(div);
        tr.append(th);

        this.totWidth += noWidth;

        if($.comm.isNull(this.sortType) && !$.comm.isNull(this.defaultSort)) {
            this.sortType = "sing";
        }

        // 데이터 컬럼 생성
        for(var i=0; i<this.headers.length; i++){
            if(this.headers[i].HIDDEN == "true")
                continue;

            var isMand = this.headers[i]["IS_MAND"];

            th = $("<th>");
            th.attr("width", this.headers[i]["WIDTH"]);

            div = $("<div>");
            div.addClass("th_text");
            div.attr("fieldName", this.headers[i]["FIELD_NAME"]);

            var headText = this.headers[i]["HEAD_TEXT"];
            // Sortting 중일때 처리
            if($('[fieldName="' + this.headers[i]["FIELD_NAME"] + '"]').length > 0){
                headText = $('[fieldName="' + this.headers[i]["FIELD_NAME"] + '"]').html();
            }
            div.html((isMand == "true" ? '<span> *</span>' : "") + headText);

            if(!$.comm.isNull(this.sortType) && $.comm.isNull(this.headers[i]["BTN_FNC"])) {
                var obj = {
                    "header"      : this.headers[i],
                    "gridObj"     : this
                }
                div.css("cursor", "pointer");
                div.on("click", $.comm.bindAsListener(this.headerSort, obj));

            }

            th.append(div);
            tr.append(th);

            this.totWidth += parseInt(this.headers[i]["WIDTH"]);
        }

        thead.append(tr);

        headerTable.append(thead);
        headerDiv.append(headerTable);

        bodyTable.append(headerTable.html());

        var tbody = $("<tbody>");
        tbody.attr("id", this.gridDataBodyId);
        bodyTable.append(tbody);

        bodyDiv.append(bodyTable);

        containDiv.append(headerDiv).append(bodyDiv);

        $('#' + this.id).empty();
        $('#' + this.id).append(containDiv);

        var tableId = this.headerTableId;
        $('#' + this.bodyId).on('scroll', function(){
            $('#' + tableId).css('left', $(this).scrollLeft() * -1);
        })

        this.PAGE_INDEX = 0;
        if($.comm.getInitPageParam() != null){
            var d = $.comm.getInitPageParam()[this.id + '_PAGE_ROW'];
            if(!$.comm.isNull(d)){
                this.PAGE_ROW = parseInt(d);
            }

            d = $.comm.getInitPageParam()[this.id + '_PAGE_INDEX'];
            if(!$.comm.isNull(d)){
                this.PAGE_INDEX = parseInt(d);
            }
        }

        this.resize();
        $(window).on("resize", $.comm.bindAsListener(this.resize, this));
        $('#' + this.checkAllId).on("click", $.comm.bindAsListener(this.checkAll, this));
    },
    clearSort : function () {
        $.each(this.sortColInfo, function(index, obj){
            var colId = obj["COL_ID"];
            var text = $('[fieldName="' + colId + '"]').html().replace("↑", "").replace("↓", "");
            $('[fieldName="' + colId + '"]').html(text);
        })

        this.sortColInfo = [];
    },
    headerSort : function () {
        var sortColInfo = this.gridObj.sortColInfo;
        var colId       = this.header["FIELD_NAME"];
        var headText    = this.header["HEAD_TEXT"];

        var sortTitleDraw = function (sort, colId, text){
            if(sort == "ASC"){
                $('[fieldName="' + colId + '"]').html("↑" + text);
            }else if(sort == "DESC"){
                $('[fieldName="' + colId + '"]').html("↓" + text);
            }else{
                if($.comm.isNull(text)){
                    text = $('[fieldName="' + colId + '"]').html().replace("↑", "").replace("↓", "");
                }

                $('[fieldName="' + colId + '"]').html(text);
            }
        }

        var setSortColInfo = function (sortCol, sort, colId, headText, index){
            sortCol["SORT"] = sort;
            sortTitleDraw(sort, colId, headText);
            sortColInfo[index] = sortCol;
        }

        if(this.gridObj.sortType == "sing"){
            var sortCol;
            if(sortColInfo.length > 0){
                if(sortColInfo[0]["COL_ID"] != colId){ // 다른 컬럼이 있을때 컬럼명에서 화살표 삭제
                    sortTitleDraw(null, sortColInfo[0]["COL_ID"], null);
                    setSortColInfo({"COL_ID" : colId}, "ASC", colId, headText, 0);

                }else{ // 같은 컬럼을 클릭 했을때
                    sortCol = sortColInfo[0];
                    var sort = sortCol["SORT"];

                    if(sort == "ASC"){
                        setSortColInfo(sortCol, "DESC", colId, headText, 0);

                    }else if(sort == "DESC"){
                        sortTitleDraw(null, colId, headText);
                        this.gridObj.sortColInfo = [];
                    }
                }
            }else{
                setSortColInfo({"COL_ID" : colId}, "ASC", colId, headText, 0);
            }

        }else{
            var findSortCol = function (colId) {
                var sortCol;
                for(var i in sortColInfo){
                    sortCol = sortColInfo[i];
                    if(colId == sortCol["COL_ID"]){
                        return [i, sortCol];
                    }
                }

                sortCol = {
                    "COL_ID" : colId,
                    "SORT"   : null
                }

                return [sortColInfo.length, sortCol];
            }

            var ret = findSortCol(colId);

            var index   = ret[0]; // sortting 순서
            var sortCol = ret[1];

            var sort = sortCol["SORT"];

            if(sort == null) {
                setSortColInfo(sortCol, "ASC", colId, headText, index);

            }else if(sort == "ASC"){
                setSortColInfo(sortCol, "DESC", colId, headText, index);

            }else if(sort == "DESC"){
                sortTitleDraw(null, colId, headText);
                sortColInfo.splice(index, 1);
            }
        }

        this.gridObj.requestToServer();
    },
    resize : function () {
        var currLayerWidth = $('#' + this.id).width();

        if($('#' + this.bodyId).length > 0){
            // 세로 스크롤이 있을때 헤더의 넓이를 조정하여 세로 스크롤이 가리지 않게 처리
            (function($) {
                $.fn.hasVerticalScrollBar = function() {
                    return (this.prop("scrollHeight") == 0 && this.prop("clientHeight") == 0)
                        || (this.prop("scrollHeight") > this.prop("clientHeight"));
                }
            })(jQuery);

            if($('#' + this.bodyId).hasVerticalScrollBar()){
                var orgHeaderIdHeight = Math.ceil(Number($('#' + this.headerId).width()));
                $('#' + this.headerId).css("width", "calc(100% - 17px)");
                if($('#' + this.headerId).width() > (orgHeaderIdHeight - 17)){
                    $('#' + this.headerId).css("width", "100%");
                    $('#' + this.headerId).width(Number($('#' + this.headerId).width()) - 17);
                }
            }else{
                $('#' + this.headerId).width("99.99%");
            }
        }

        if(currLayerWidth <= this.totWidth){
            $('#' + this.headerTableId).width(this.totWidth+"px");
            $('#' + this.bodyTableId).width(this.totWidth+"px");

        }else{
            $('#' + this.headerTableId).width("99.99%");
            $('#' + this.bodyTableId).width("99.99%");

        }
    },
    scrollPaging : function(){
        if(this.totalCount == this.getSize()) return;

        var obj = $('#' + this.bodyId);

        if(obj.get(0) && obj.get(0).scrollHeight > obj.innerHeight()){ // 세로 스크롤바가 있을때만
            if (obj[0].scrollHeight - obj.scrollTop() <= obj.outerHeight()){
                this.PAGE_INDEX++;
                this.IS_REQ_SCROLL = true;
                this.requestToServer();
            }
        }
    },
    /**
     * 그리드 조회
     * @param eventResrc
     */
    requestToServer : function (eventResrc) {
        $("input:checkbox[id='" + this.checkAllId + "']").prop("checked", false);

        if (this.IS_REQ_SCROLL == false && this.preScript != null) {
            var returnVal = ($.isFunction(this.preScript) ? this.preScript() : eval(this.preScript+"(this)"));
            if (!returnVal)
                return;
        }

        if(this.actNm){
            this.addParam("ACTION_NM", this.actNm);
        }

        this.addParam("dbPoolName", this.dbPoolName);

        if($('#'+this.gridNaviId).length > 0 || this.SCROLL_PAGING == true){
            this.addParam("PAGE_INDEX", String(this.PAGE_INDEX));
            this.addParam("PAGE_ROW"  , String(this.PAGE_ROW));
        }

        if(this.sortColInfo.length > 0){
            var sort = "";
            for(var index in this.sortColInfo){
                var sortCol = this.sortColInfo[index];

                sort += sortCol["COL_ID"] + " " + sortCol["SORT"] + ",";
            }

            sort = sort.substring(0, sort.length - 1);
            this.addParam("SORT_STR", sort);
        }else{

            this.addParam("SORT_STR", this.defaultSort);
        }

        var requestParam = $.extend({}, this.gatherParams);
        var titleParam   = null;

        if(this.paramsFormId != "commonForm"){
            // 필수 체크
            if($.comm.mandCheck(this.paramsFormId) == false){
                return;
            }

            // 날짜 기간 체크
            if($.comm.dueCalendarCheck(this.paramsFormId) == false){
                return;
            }

            var a = $('#' + this.paramsFormId).serializeArray();
            $.each(a, function () {
                //if(this.value != null && this.value != ''){
                // 날짜필드이면 '-' 삭제
                if($('#'+this.name).is('[datefield]')){
                    this.value = this.value.trim().replace(/\/|-/g, '');
                }

                var tagName = ($('input[name="' + this.name + '"]').length > 0 ? $('input[name="' + this.name + '"]')[0].tagName : "");
                var tagType = ($('input[name="' + this.name + '"]').length > 0 ? $('input[name="' + this.name + '"]')[0].type : "");
                if(tagName.toUpperCase() == "INPUT" && tagType.toUpperCase() == "CHECKBOX"){
                    var arr = $('input[name="' + this.name + '"]').serializeArray();
                    var valueArray = [];
                    $.each(arr, function () {
                        valueArray.push(this.value);
                    })

                    requestParam[this.name] = valueArray;
                }else{
                    requestParam[this.name] = this.value;
                }

                if(titleParam == null) titleParam = {};

                if($("label[for='"+this.name+"']")){
                    titleParam[this.name] = $("label[for='"+this.name+"']").html();
                }
                //}
            })
        }

        if(titleParam != null){
            requestParam["titleParameter"] = titleParam;
        }

        // 엑셀
        if (eventResrc && eventResrc.btn_type == "EXCEL") {
            if (document.getElementById('iframe_csv_download') == null) {
                var iframeref = $("<div></div>");
                iframeref.html('<iframe style="display:none" height=0 width=0 id="iframe_csv_download" name="iframe_csv_download"></iframe>');
                $("body").append(iframeref);
            }

            var form_down = $("<form></form>");
            $("body").append(form_down);

            form_down.attr("id", 'form_excel_download');
            form_down.attr("method", "POST");
            form_down.attr("target", "iframe_csv_download");
            form_down.attr("action", "/common/excelDownload.do");

            var excelParam = {};
            excelParam["qKey"] = $.comm.isNull(eventResrc.qKey) ? this.qKey : eventResrc.qKey;
            excelParam["headers"] = this.headers;
            excelParam["params"] = requestParam;

            var input_text = $("<input>");
            input_text.attr("type", 'hidden');
            input_text.attr("name", 'params');
            input_text.attr("value", encodeURIComponent((JSON.stringify(excelParam)).split("null").join('')));
            $(form_down).append(input_text);

            var menuInputStr = $.page.createMenuInfoInputStr();
            menuInputStr += $.page.createActionNmInputStr(this.actNm + " 엑셀다운로드");
            menuInputStr += $.page.createSessionDivInputStr();

            $(form_down).append(menuInputStr);

            form_down.submit().remove();

            // 삭제
        }else if (eventResrc && eventResrc.btn_type == "D") {
            var size = this.getSelectedSize();
            if(size == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없스니다.
                return;
            }

            if(!confirm($.comm.getMessage("C00000001"))){ // 삭제 하시겠습니까?
                return;
            }

            var rows = this.getSelectedRows();
            var actionNm = this.actNm.replace("조회","삭제");
            if(actionNm.indexOf("삭제") < 0){
                actionNm = this.actNm + " 삭제";
            }

            var paramData = JSON.parse(decodeURIComponent($.comm.getAjaxData(rows, actionNm)));
            paramData.data["qKey"] = eventResrc.qKey;
            paramData.data = $.extend({}, this.gatherParams, paramData.data);

            paramData = encodeURIComponent((JSON.stringify(paramData)).split("null").join(''));

            var url = ($.comm.isNull(eventResrc.targetURI) ? "/common/deleteList.do" : eventResrc.targetURI);
            $.comm.send(url, paramData,
                function (data, status, ownerObj) {ownerObj.requestToServer();},
                actionNm, null, false, this, true);

            if(!$.comm.isNull(eventResrc.postScript)){
                $.isFunction(eventResrc.postScript) ? eventResrc.postScript(this) : eval(eventResrc.postScript+"(this)");
            }
        }else{
            $.comm.send(this.requestUrl, requestParam, $.comm.bindAsListener(this.loadData, this));
        }
    },
    loadData : function (data) {
        if(data.status == -1){
            alert(data.msg);
            return;
        }
        var body = $('#' + this.gridDataBodyId);

        if(this.IS_REQ_SCROLL == false){
            body.empty();
            this.dataObj = new Array();
            $('#' + this.id).scrollTop(0);
        }

        var resultList = data.dataList;
        var total      = (data.total == 0 ? resultList.length : data.total);
        this.totalCount = total;

        if(this.IS_REQ_SCROLL && total == 0){
            this.IS_REQ_SCROLL = false;
            this.PAGE_INDEX--;
            return;
        }

        var totStr = $.comm.numberWithCommas(total);
        if($('#'+this.gridNaviId).length > 0 && this.SCROLL_PAGING == false){
            var pageRow   = parseInt(this.PAGE_ROW);
            var currPage = parseInt(this.PAGE_INDEX) + 1; // 현재페이지 (0 부터시작)
            totStr += " (" + $.comm.numberWithCommas(currPage) + "/" + $.comm.numberWithCommas(Math.ceil(total / pageRow)) + ")";
        }

        if(this.displayCountId == true) {
            if ($('#' + this.countId).length > 0) {
                $('#' + this.countId).html(totStr);

            } else {

                if ($('#' + this.id + '_total').length > 0) $('#' + this.id + '_total').remove();

                var totalTag = '<p class="total" id="' + this.id + '_total">Total <span>' + totStr + '</span></p>';
                $.each($('#' + this.id).siblings(), function (obj) {
                    if (this.className == "util_frame") {
                        $(this).prepend(totalTag);
                        return false;
                    }
                })
            }
        }

        if(total == 0 && this.IS_REQ_SCROLL == false){
            var colSize = this.headers.length+1;
            if(this.check){
                colSize++;
            }

            var str = "<tr>" +
                "<td colspan='" + colSize + "'>검색된 자료가 없습니다.</td>" +
                "</tr>";

            body.append(str);

            // paging
            $("#" + this.gridNaviId).empty();
            $("#" + this.gridNaviId).append("<strong>1</strong>");

            this.resize();
        }else{
            var index = this.dataObj.length;

            if(this.dataObj.length == 0){
                this.dataObj = resultList;
            }else{
                this.dataObj = $.merge( this.dataObj, resultList );
            }

            if(this.SCROLL_PAGING == false){
                this.renderingPaging(total);
            }

            this.drawBody(index, resultList);
        }

        if(this.IS_REQ_SCROLL == false && this.postScript != null) {
            $.isFunction(this.postScript) ? this.postScript(this) : eval(this.postScript+"(this)");
        }

        this.IS_REQ_SCROLL = false;
    },
    appendRow : function (index, rowIdx, rowData) {
        var centerAlignClass = "text-center";
        var leftAlignClass   = "text-left";
        var rightAlignClass  = "text-right";

        var value = rowData;

        var row = $("<tr>");

        // 체크박스 컬럼 생성
        if(this.check || this.onlyOneCheck){
            var checkCol = $("<td>");
            var check   = $("<input>");
            check.attr("type" , "checkbox");
            check.attr("id"   , this.checkId+(index+rowIdx));
            check.attr("name" , this.checkId);
            check.attr("value", index+rowIdx);

            if(value["CHK"] && (value["CHK"] == "1" || value["CHK"] == "Y")){
                check.prop("checked", true);
            }

            var label = $("<label>");
            var span = $("<span>");
            label.attr("for", this.checkId+(index+rowIdx));
            label.append(span);

            checkCol.append(check);
            checkCol.append(label);

            if(this.onlyOneCheck == true){
                check.on("click", $.comm.bindAsListener(this.checkOnlyOne, this));
            }else{
                check.on("click", $.comm.bindAsListener(this.onCheckClick, this));
            }


            if(this.checkPosit == true){
                check.attr("onclick", "gfn_gridPostion('" + (index+rowIdx) + "', '" + this.checkId + "')");
            }

            row.append(checkCol);
        }

        var col = $("<td>");

        // No. 컬럼 생성
        col.html((value["RN"] ? value["RN"] : (index+rowIdx+1)));
        row.append(col);

        var dataTypeConvertor = function (val, type) {
            if (type == "NUM") {
                if(!$.comm.isNull(val)){
                    return $.comm.numberWithCommas($.comm.numberWithoutCommas(val));
                }
            }else if (type == "DAT") {
                if(!$.date.isValidDate(val)){
                    return "";
                }else{
                    val = val.trim().replace(/\/|-/g, '');
                    if(val.length == 8){
                        return val.toDate("YYYYMMDD").format("YYYY-MM-DD");
                    }
                }
            }
        }

        var dataTypeAlign = function (type) {
            if (type == "NUM") {
                return rightAlignClass;
            }else if (type == "DAT"){
                return centerAlignClass;
            }

        }

        for(var k=0; k<this.headers.length; k++) {
            var obj = this.headers[k];

            var text      = obj.HEAD_TEXT;  // head title
            var link      = obj.LINK;       // 컬럼 링크 함수명/함수
            var position  = obj.POSIT;      // 링크시 로우배경 지정
            var htmlFn    = obj.HTML_FNC;   // html code 반환 함수명/함수
            var btnFn     = obj.BTN_FNC;    // 버튼 생성 및 버튼 onclick event 함수명/함수
            var colr      = obj.COLR;       // color
            var fieldType = obj.FIELD_TYPE; // 필드 타입
            var dataType  = obj.DATA_TYPE;  // 데이터 타입
            var align     = (obj.ALIGN) ? obj.ALIGN : "center"; // 정렬

            var alignClass = "";    // 정렬 css class

            if (!(obj.HIDDEN && obj.HIDDEN == "true")) {
                var val = value[obj.FIELD_NAME]; //eval("value." + obj.FIELD_NAME);

                if (fieldType) {
                    alignClass = centerAlignClass;

                } else if (dataType){
                    alignClass = dataTypeAlign(dataType);

                } else {
                    if (align.toLowerCase() == "center") {
                        alignClass = centerAlignClass;
                    } else if (align.toLowerCase() == "left") {
                        alignClass = leftAlignClass;
                    } else if (align.toLowerCase() == "right") {
                        alignClass = rightAlignClass;
                    } else {
                        alignClass = centerAlignClass;
                    }
                }

                val = ($.comm.isNull(val) ? "" : String(val));

                col = $("<td>");
                col.attr("title", val);

                var valueDiv = $("<div>");
                $(valueDiv).addClass(alignClass);
                if (fieldType) {
                    var style = "";
                    // select box
                    if (fieldType == "CMB") {
                        var combo = obj.COMBO;
                        if (combo) {
                            var arr = null;

                            var selectCol = $("<select>");
                            selectCol.attr("id"   , obj.FIELD_NAME + "_" + rowIdx);
                            selectCol.attr("name" , obj.FIELD_NAME);
                            selectCol.attr("style", "width:98%; height: 28px; font-size: 12px;");

                            if ($.type(combo) === 'array') {
                                arr = combo;
                            } else if ($.isFunction(combo)) {
                                arr = eval(combo).call(this, rowIdx, val, obj.FIELD_NAME);
                            }

                            if (arr) {
                                $.each(arr, function (idx, cmbObj) {
                                    var option = $("<option>");
                                    option.attr("value", cmbObj.code);
                                    option.html(cmbObj.value);

                                    selectCol.append(option);
                                })
                            }

                            selectCol.val(val);
                        }
                        valueDiv.append(selectCol);

                        // Number or Date or Text
                    } else {
                        if (fieldType == "NUM") {
                            if(!$.comm.isNull(val))
                                val = $.comm.numberWithCommas(val);

                            style = "text-align:right;";

                        } else {
                            style = "text-align:" + align.toLowerCase() + ";";
                        }

                        var input = $("<input>");
                        input.attr("id"   , obj.FIELD_NAME + "_" + rowIdx);
                        input.attr("name" , obj.FIELD_NAME);
                        input.attr("value", val);
                        input.attr("style", style + ";width:98%; height: 28px; font-size: 12px; padding-right: 5px; padding-left: 5px;");

                        // Number Type 일때 comma 처리
                        if (fieldType == "NUM") {
                            input.focus(function(){
                                this.value = $.comm.numberWithoutCommas(this.value);
                            });
                            input.blur(function(){
                                this.value = $.comm.numberWithCommas(this.value);
                            });
                        }else if (fieldType == "DAT") {
                            input.datepicker();
                            input.css("datepicker");

                            input.blur(function(){
                                if(!$.date.isValidDate(this.value)){
                                    this.value = "";
                                }else{
                                    var val = this.value.trim().replace(/\/|-/g, '');
                                    if(val.length == 8){
                                        this.value = val.toDate("YYYYMMDD").format("YYYY-MM-DD");
                                    }
                                }
                            });
                        }

                        if(obj.LENGTH){
                            input.attr("maxlength", obj.LENGTH);
                        }

                        valueDiv.append(input);
                    }
                } else if (link) {
                    var anchor = $("<a>");
                    anchor.attr("style"  , "color: " + (colr ? colr : "#0000ff"));

                    if($.comm.isNull(position) || position == "true" || position == true){
                        //onclick시 배경색 지정
                        gfn_addHilightEvent(anchor);
                    }

                    if(rowIdx == 0 && !$.comm.isNull(position) && (position == "true" || position == true)){
                        row.css("background-color", "#bffcfe");
                        row.attr("point","true");
                    }

                    if($.isFunction(link)){
                        (function(link) {
                            anchor.click(function () {
                                return link.call(this, (index+rowIdx));
                            });
                        })(link);

                    }else{
                        anchor.attr("onclick", "gfn_gridLink(\"" + link + "\", \"" + (index + rowIdx) + "\")");
                    }
                    if (dataType){
                        val = dataTypeConvertor(val,  dataType);
                    }
                    anchor.html(val);

                    valueDiv.append(anchor);

                } else if (htmlFn) {
                    valueDiv.append(eval(htmlFn).call(this, (index + rowIdx), val, obj.FIELD_NAME));

                } else if (btnFn) {
                    var anchor = $("<a>");
                    anchor.addClass("btn_inquiryC");
                    anchor.attr("onclick", "gfn_gridLink(\"" + btnFn + "\", \"" + (index + rowIdx) + "\")");
                    anchor.html(obj.FIELD_NAME);

                    valueDiv.append(anchor);

                } else if (colr) {
                    var span = $("<span>");
                    span.attr("style", "color:" + colr);

                    if (dataType){
                        val = dataTypeConvertor(val,  dataType);
                    }

                    span.html(val);

                    valueDiv.append(span);

                } else {
                    if (dataType){
                        val = dataTypeConvertor(val,  dataType);
                    }

                    valueDiv.html(val);
                }

                col.append(valueDiv);
            }

            row.append(col);
        }

        return row;
    },
    drawBody : function (index, resultList) {
        var body  = $('#' + this.gridDataBodyId);

        for(var i=0; i<resultList.length; i++){
            this.dataObj[index+i]["RIDX"] = String(index+i);
            body.append(this.appendRow(index, i, resultList[i]));
        }

        body.find(".btn_inquiryC").css("padding-top", "6px"); // 그리드 셀에 버튼이 있을경우 padding-top을 조정

        this.resize();
    },
    checkOnlyOne : function (obj) {
        var id   = $.comm.getTarget(obj).id;
        var name = $.comm.getTarget(obj).name;

        var val = "0";
        if($("input:checkbox[id='" + id + "']").is(":checked")){
            val = "1";
        }

        $("input:checkbox[name='" + name + "']").prop("checked", false);

        //dataObj 처리
        var idx = id.substr(id.length -1);
        var index = parseInt(idx);

        for(var i=0; i<this.dataObj.length; i++){
            this.dataObj[i]["CHK"] = "0";
        }

        if(val == "1"){
            $("input:checkbox[id='" + id + "']").prop("checked", true);
        }

        this.dataObj[index]["CHK"] = val;

        if(this.checkScript != null){
            $.isFunction(this.checkScript) ? this.checkScript(index) : eval(this.checkScript+"("+index+")");
        }
    },
    onCheckClick : function (obj) {
        var id   = $.comm.getTarget(obj).id;
        var idx = id.replace(this.checkId, '');
        var index = parseInt(idx);
        var val = "0";
        if($("input:checkbox[id='" + id + "']").is(":checked"))
            val = "1";

        this.dataObj[index]["CHK"] = val;

        if(this.checkScript != null){
            $.isFunction(this.checkScript) ? this.checkScript(index) : eval(this.checkScript+"("+index+")");
        }
    },
    paramsAddOnclickEvent : function () {
        if(this.paramsFormId != "commonForm"){
            var formEle = $("#" + this.paramsFormId)[0].elements;
            for(var i=0; i<formEle.length; i++){
                var obj = formEle[i];

                // changeNoSearch 속성이 있으면 Event를 걸지 않음
                if($(obj).is("[changeNoSearch]")){
                    continue;
                }

                if(obj.tagName == "INPUT" && obj.type == "text"){
                    obj.onkeydown = $.comm.bindAsListener(this.onKeydown, this);

                }else if(obj.tagName == "SELECT" || (obj.tagName == "INPUT" && (obj.type == "radio" || obj.type == "checkbox"))){
                    obj.onchange = $.comm.bindAsListener(this.onChange, this);

                }
            }
        }
    },
    onKeydown : function (event) {
        if(event.keyCode == 13) {
            this.PAGE_INDEX = 0;
            event.preventDefault();

            var target = $.comm.getTarget(event);
            if($(target).is("[pk]")){
                $(target).blur();
            }

            this.clearSort();
            this.requestToServer();
        }
    },
    onChange : function (event) {
        event.preventDefault();
        this.PAGE_INDEX = 0;

        this.clearSort();
        this.requestToServer();
    },
    buttonClick : function (event) {
        var target = $.comm.getTarget(event);

        event.preventDefault();

        if(target.preScript != null){
            var returnVla = (target.preScript instanceof Function ? target.preScript() : eval(target.preScript));

            if(!returnVla) return;
        }

        if(target.btn_type == "S" || target.btn_type == "D" || target.btn_type == "EXCEL"){
            if(target.btn_type == "S"){
                this.clearSort();
            }
            this.PAGE_INDEX = 0;
            //this.requestToServer($('#' + target.id).html());
            this.requestToServer(target);

        }
    },
    renderingPaging : function (totalCount) {
        if($("#" + this.gridNaviId).length == 0)
            return;

        var iPage = parseInt(this.PAGE_INDEX) + 1;
        var iPageSize = parseInt(this.PAGE_ROW);
        var iPageCnt = 10;
        var iTotalPageCnt = Math.ceil(totalCount / iPageSize);

        if(iTotalPageCnt == 0){
            iTotalPageCnt = 1;
        }

        if(iPage > iTotalPageCnt){
            iPage = iTotalPageCnt;
        }

        var iStartPage = parseInt((iPage - 1) / iPageCnt) * iPageCnt + 1;
        var iEndPage = iStartPage + iPageCnt - 1;

        if(iEndPage >  iTotalPageCnt){
            iEndPage = iTotalPageCnt;
        }

        var pagehtml = "";

        var fieldSelectId = this.id + '_FIELD_SELECT';
        if(this.IS_FIELD_SELECT){
            if (this.FIELD_SELECT_ID == null){
                pagehtml += '<a href="#" class="btn cancel bottom_blue" id="' + fieldSelectId + '" style="color: #FFFFFF">필드선택</a>';
            }else{
                fieldSelectId = this.FIELD_SELECT_ID;
            }
        }
        pagehtml += "<a href=\"#\" name='" + this.gridPageMoveId + "' class=\"first\" page=\"1\"></a>";     // 첫 페이지
        if(iPage > iPageCnt){
            pagehtml += "<a href=\"#\" name='" + this.gridPageMoveId + "' class=\"prev\" page=\"" + (iStartPage - 1) + "\"></a>";   // 이전 페이지
        }


        for(var i = iStartPage; i <= iEndPage; i++){
            if(i > iTotalPageCnt){
                break;
            }

            if(i == iPage){
                pagehtml += "<strong>" + i + "</strong>";
            }else{
                pagehtml += "<a href='#' name='" + this.gridPageMoveId + "' page='" + i + "'>" + i + "</a>";
            }
        }

        if(iTotalPageCnt - iStartPage >= iPageCnt){
            pagehtml += "<a href=\"#\" name='" + this.gridPageMoveId + "' class=\"next\" page=\"" + (iEndPage + 1) + "\"></a>";   // 다음 페이지
        }

        // 마지막 페이지
        pagehtml += "<a href=\"#\" name='" + this.gridPageMoveId + "' class=\"last\" page=\"" + iTotalPageCnt + "\"></a>"; // 끝 페이지

        var rowIndexHtml = '';
        if(this.displayPageRowCombo == true) {
            rowIndexHtml += '<select name="' + this.id + '_PAGE_ROW" id="' + this.id + '_PAGE_ROW" class="bundle_select">';
            rowIndexHtml += '<option value="5" ' + (this.PAGE_ROW == 5 ? "selected" : "") + ' >5건씩 보기</option>';
            rowIndexHtml += '<option value="10" ' + (this.PAGE_ROW == 10 ? "selected" : "") + ' >10건씩 보기</option>';
            rowIndexHtml += '<option value="15" ' + (this.PAGE_ROW == 15 ? "selected" : "") + ' >15건씩 보기</option>';
            rowIndexHtml += '<option value="30" ' + (this.PAGE_ROW == 30 ? "selected" : "") + ' >30건씩 보기</option>';
            rowIndexHtml += '<option value="50" ' + (this.PAGE_ROW == 50 ? "selected" : "") + ' >50건씩 보기</option>';
            rowIndexHtml += '</select>';
        }

        $("#" + this.gridNaviId).html(pagehtml + rowIndexHtml);

        if($('#' + this.id + "_PAGE_INDEX").length == 0){
            $("#" + this.gridNaviId).append('<input type="hidden" name="' + this.id + '_PAGE_INDEX" id="' + this.id + '_PAGE_INDEX" value="' + this.PAGE_INDEX + '">');
        }

        $("a[name='"+this.gridPageMoveId+"']").on("click", $.comm.bindAsListener(this.movePage, this));
        $("#" + this.id + "_PAGE_ROW").on("change", $.comm.bindAsListener(this.changePageRow, this));

        if(this.IS_FIELD_SELECT) {
            $("#" + fieldSelectId).unbind('click').on("click", $.comm.bindAsListener(this.fieldSelection, this));
        }
    },
    fieldSelection : function (event) {
        var params = $.extend([], this.headers);
        $.each(params, function (idx, data) {
            data["RIDX"] = idx;
        })
        $.comm.setModalArguments(params);
        var spec = "width:500px;height:700px;scroll:auto;status:no;center:yes;resizable:yes;windowName:gridFieldSelection";
        $.comm.dialog('/jspView.do?jsp=cmm/popup/gridFieldPopup', spec,
            $.comm.bindAsListener(function () {
                var retArr = $.comm.getModalReturnVal();
                if(retArr){
                    $.each(this.headers, function (idx, data) {
                        var fieldName = data["FIELD_NAME"];
                        if($.inArray(fieldName, retArr) < 0){
                            data["HIDDEN"] = "true";
                        }else{
                            data["HIDDEN"] = "false";
                        }
                    })

                    var actionMenuId = $.page.getMenuId();
                    if(actionMenuId){
                        localStorage.setItem(actionMenuId, JSON.stringify(retArr));
                    }
                }
                this.drawGrid();
                this.requestToServer();
            }, this)
        ) // 모달 호츨
    },
    changePageRow : function (event) {
        var target = $.comm.getTarget(event);
        this.PAGE_INDEX = 0;
        this.PAGE_ROW = target.value;

        event.preventDefault();

        this.requestToServer();
    },
    movePage : function (event) {
        var target = $.comm.getTarget(event);
        var page = target.attributes['page'].nodeValue;
        this.PAGE_INDEX = parseInt(page) - 1;

        $("#" + this.id + "_PAGE_INDEX").val(this.PAGE_INDEX);

        event.preventDefault();

        this.requestToServer();
    },
    /**
     * 조회 파라미터 추가
     * @param key : 키
     * @param value : 값
     */
    addParam : function (key, value) {
        this.gatherParams[key] = value;
    },
    /**
     * 조회 파라미터 삭제
     * @param key : 키
     */
    delParam : function (key){
        delete this.gatherParams[key];
    },
    /**
     * 파라미터 로우의 데이터를 반환
     * @param rowIndex : 로우 index
     * @returns {*}
     */
    getRowData : function (rowIndex) {
        return this.dataObj[rowIndex];
    },
    /**
     * 체크박스가 선택된 로우의 데이터를 반환
     * @returns {Array}
     */
    getSelectedRows : function () {
        var chkArr = $('input:checkbox[name="'+this.checkId+'"]:checked');
        var arr = [];
        for(var i=0; i < chkArr.length; i++){
            arr.push(this.dataObj[parseInt(chkArr[i].value)]);
        }
        return arr;
    },
    /**
     * 체크박스가 선택된 로우의 수를 반환
     * @returns {number|jQuery}
     */
    getSelectedSize : function () {
        return $('input:checkbox[name="'+this.checkId+'"]:checked').length;
    },
    /**
     * 그리드 로우의 전체 건수를 반환
     * @returns {Number}
     */
    getSize : function () {
        return this.dataObj.length;
    },
    /**
     * 그리드 로우의 전체 데이터를 반환
     * @returns {Array}
     */
    getData : function () {
        var modDataList = [];
        var dataList = this.dataObj;
        for(var i=0; i<dataList.length; i++){
            var data = dataList[i];
            var newData = data;
            $.each(this.headers, function (k, obj) {
                var colId = obj.FIELD_NAME;
                if(obj.FIELD_TYPE){
                    var val = $('#' + colId + "_" + i).val();

                    if(obj.FIELD_TYPE == 'NUM'){
                        val = $.comm.numberWithoutCommas(val);

                    }else if (obj.FIELD_TYPE == "DAT") {
                        val = val.trim().replace(/\/|-/g, '');
                    }

                    newData[colId] = val;
                }
            });

            modDataList.push(newData);
        }

        return modDataList;
    },
    /**
     * 그리드 데이터를 지정
     * @param data
     */
    setData : function (data) {
        this.dataObj = data;
    },
    /**
     * 파라미터의 row index에 컬럼 id에 해당하는 데이터를 반환
     * @param rowIdx
     * @param colId
     * @returns {*}
     */
    getCellData: function (rowIdx, colId) {
        return this.dataObj[rowIdx][colId];
    },
    /**
     * 파라미터의 row index에 컬럼 id에 value 값을 지정
     * @param rowIdx
     * @param colId
     * @param value
     */
    setCellData: function (rowIdx, colId, value) {
        this.dataObj[rowIdx][colId] = value;
        var data = {
            "dataList" : this.dataObj,
            "status"   : 0,
            "total"    : this.dataObj.length
        }

        this.loadData(data);
        /*if(colId == "CHK"){
         this.setCheck(rowIdx, (value == "1" ? true : false));
         }*/
    },
    /**
     * 그리드 필드가 변경된 로우데이터를 반환
     * @returns {Array}
     */
    getUpdateData : function () {
        var modDataList = [];
        var dataList = this.dataObj;
        for(var i=0; i<dataList.length; i++){
            var data = dataList[i];
            var newData = null;

            for(var k=0; k<this.headers.length; k++){
                var obj = this.headers[k];
                var colId = obj.FIELD_NAME;
                if(obj.FIELD_TYPE){
                    var orgVal = ($.comm.isNull(data[colId]) ? "" : String(data[colId]));
                    var val = $('#' + colId + "_" + i).val();

                    if(obj.FIELD_TYPE == 'NUM'){
                        val = $.comm.numberWithoutCommas(val);

                    }else if (obj.FIELD_TYPE == "DAT") {
                        val = val.trim().replace(/\/|-/g, '');
                    }

                    if(orgVal != val){
                        if(newData == null){
                            newData = $.extend({}, data);
                        }
                        newData[colId] = val;
                    }

                    var isMand = obj.IS_MAND;
                    if(isMand && isMand == "true"){
                        if($.comm.isNull(val)){
                            alert($.comm.getMessage("W00000004", obj.HEAD_TEXT)); // $을(를) 입력하십시오.
                            return null;
                        }
                    }
                }
            }
            if(newData != null){
                modDataList.push(newData);
            }
        }

        return modDataList;
    },
    /**
     * 입력한 데이터의 길이를 체크
     * @returns {boolean}
     */
    checkLength : function () {
        var targetList = this.getUpdateData();
        for(var i=0; i<targetList.length; i++){
            var rowData = targetList[i];
            $.each(this.headers, function () {
                if(this.LENGTH){
                    var name   = this.HEAD_TEXT;
                    var length = parseInt(this.LENGTH);
                    var value  = rowData[this.FIELD_NAME];

                    var valLen = $.comm.bytelength(value);

                    if(length < valLen){
                        alert($.comm.getMessage("W00000006", name)); // $의 글자수가 최대 글자수를 초과 하였습니다.
                        return false;
                    }
                }
            })
        }

        return true;
    },
    /**
     * 파라미터의 컬럼id가 value의 값을 갖는 첫번째 row index를 반환
     * @param colId
     * @param value
     * @returns {*}
     */
    findRow : function (colId, value) {
        for(var i=0; i<this.getSize(); i++){
            var val = this.dataObj[i][colId];
            if(val == value){
                //return this.dataObj[i];
                return i;
            }
        }
    },
    /**
     * 조회 쿼리 id를 지정
     * @param qKey
     */
    setQKey : function (qKey) {
        this.qKey = qKey;
        this.addParam("qKey", qKey);
    },
    /**
     * 조회할 DB를 지정
     * @param dbPoolName
     */
    setDbPoolName : function (dbPoolName) {
        this.dbPoolName = dbPoolName;
        this.addParam("dbPoolName", dbPoolName);
    },
    /**
     * 조회 파라미터를 지정
     * @param params
     */
    setParams : function (params) {
        this.gatherParams = $.extend(this.gatherParams, params);
    },
    /**
     * 그리드 헤더 정보를 지정
     * @param headers
     */
    setHeaders : function (headers) {
        this.headers = headers;
    },
    /**
     * 그리드 헤더 정보를 반환
     */
    getHeaders : function () {
        return this.headers;
    },
    /**
     * 페이징의 한페이지 로우수를 지정
     * @param row
     */
    setPageRow : function(row){
        this.PAGE_ROW = row;
    },
    /**
     * 체크박스의 전체 선택 또는 전체 해제
     */
    checkAll : function () {
        var checked = false;
        if($("input:checkbox[id='" + this.checkAllId + "']").is(":checked"))
            checked = true;

        $("input:checkbox[name='" + this.checkId + "']:enabled").prop("checked", checked);

        $.each(this.dataObj, function () {
            this["CHK"] = (checked == true ? "1" : "0");
        })
    },
    /**
     * 파라미터의 boolean으로 체크박스 전체 선택 또는 전체 해제
     * @param checked
     */
    setCheckAll : function (checked) {
        $("input:checkbox[name='" + this.checkId + "']:enabled").prop("checked", checked);

        $.each(this.dataObj, function () {
            this["CHK"] = (checked == true ? "1" : "0");
        })

    },
    /**
     * 파라미터의 row index의 체크박스를 checked의 값으로 지정
     * @param row
     * @param checked
     */
    setCheck : function (row, checked) {
        $("input:checkbox[id='" + (this.checkId + row) + "']").prop("checked", checked);
        this.dataObj[row]["CHK"] = (checked == true ? "1" : "0");
    },
    /**
     * 파라미터의 row index의 체크박스를 bool의 값으로 disabled 지정
     * @param row
     * @param bool
     */
    setCheckDisabled : function (row, bool) {
        if(bool == true){
            $("input:checkbox[id='" + (this.checkId + row) + "']").attr("disabled", true);
        }else{
            $("input:checkbox[id='" + (this.checkId + row) + "']").removeAttr("disabled");
        }
    }
}

function gfn_gridLink(fn, args){
    try{
        event.preventDefault();
    }catch(e){}

    //eval(fn + "(" + args + ")");
    if($.isFunction(fn)){
        fn();
    }else{
        eval(fn).call(this, args);
    }
}


function gfn_gridPostion(index, checkName){
    var obj = $('#' + (checkName + index));
    var rowObj = $(obj).closest("tbody").find("tr");

    rowObj.css("background-color", "#ffffff");
    rowObj.removeAttr("point");

    $(rowObj).hover(
        function(){
            $(this).css("background-color", "#bffcfe");
        },
        function(){
            if($(this).attr("point") != "true"){
                $(this).css("background-color", "#ffffff");
            }
        }
    )

    $.each($("input[name="+checkName+"]:checkbox:checked"), function(){
        $(this).closest("tr").css("background-color", "#bffcfe");
        $(this).closest("tr").attr("point","true");
    })
}

function gfn_addHilightEvent(anchor){
    anchor.on("click", function () {
        var rowObj = $(this).closest("tbody").find("tr");
        rowObj.css("background-color", "#ffffff");
        rowObj.removeAttr("point");

        $(rowObj).hover(
            function(){
                $(this).css("background-color", "#bffcfe");
            },
            function(){
                if($(this).attr("point") != "true"){
                    $(this).css("background-color", "#ffffff");
                }
            }
        )

        $(this).closest("tr").css("background-color", "#bffcfe");
        $(this).closest("tr").attr("point","true");
    })
}