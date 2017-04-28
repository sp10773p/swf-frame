/**
 * Created by seongdonghun on 2016. 11. 21..
 */

GridWrapper = function (params) {
    this.id = params.targetLayer;
    this.actNm = params.actNm;
    this.qKey = params.qKey;
    this.headers      = (params.headers      ? params.headers      : null);
    this.requestUrl   = (params.requestUrl   ? params.requestUrl   : "/common/selectGridPagingList.do");
    this.preScript    = (params.preScript    ? params.preScript    : null);
    this.postScript   = (params.postScript   ? params.postScript   : null);
    this.gatherParams = (params.paramsGetter ? params.paramsGetter : {});
    this.dbPoolName   = (params.dbPoolName   ? params.dbPoolName   : "default");
    this.countId      = (params.countId      ? params.countId      : 'totCnt');

    this.firstLoad    = (!$.comm.isNull(params.firstLoad)   ? params.firstLoad      : true);
    this.check        = (!$.comm.isNull(params.check)       ? params.check          : false);
    this.checkScript  = (params.checkScript ? params.checkScript : null);

    this.checkId      = params.targetLayer+"Chk";
    this.totalCount   = 0; // Total count

    this.dataObj = new Array();

    //paging parameter
    this.PAGE_INDEX    = 0;
    this.PAGE_ROW      = (params.pageRow ? params.pageRow : 10);
    this.SCROLL_PAGING = true;
    this.IS_REQ_SCROLL = false;

    this.MORE_BTN_ID = "btnMore";
    this.initializeLayer();
}

GridWrapper.prototype = {

    initializeLayer : function () {
        var ulClassName = "list_style";
        if(this.check){
            ulClassName += " checklist";

            // 전체선택, 선택해제 버튼 추가
            if($('.btn_frame').length > 0){
                var html = '<a href="#0" class="btn white_btn uncheck_all">선택해제 (<span class="list_chk_num"></span>)</a>';
                $(html).prependTo(".btn_frame");

                html = '<a href="#0" class="btn white_btn check_all">전체선택</a>';
                $(html).prependTo(".btn_frame");

                //체크박스 전체선택 및 해제 이벤트
                $("input[name="+this.checkId+"]:checkbox").on('click', function(){
                    $('.list_chk_num').html($("input[name="+this.checkId+"]:checkbox:checked").length);
                    if($("input[name="+this.checkId+"]").is(":checked") === true){
                        $(".check_all").css('display','none');
                        $(".uncheck_all").css('display','block');
                    } else{
                        $(".uncheck_all").css('display','none');
                        $(".check_all").css('display','block');
                    }
                });

                $(".check_all").on("click", $.comm.bindAsListener(this.setCheckAll, this));
                $(".uncheck_all").on("click", $.comm.bindAsListener(this.setCheckAll, this));
            }
        }
        $('#' + this.id).attr('class', ulClassName);

        this.addParam("qKey", this.qKey);

        if(this.firstLoad){
            this.requestToServer();
        }

        $('#PAGE_ROW').val(this.PAGE_ROW);
    },
    /**
     * 그리드 조회
     * @param eventResrc
     */
    requestToServer : function () {
        //$("input:checkbox[id='" + this.checkAllId + "']").prop("checked", false);

        if (this.IS_REQ_SCROLL == false && this.preScript != null) {
            var returnVal = ($.isFunction(this.preScript) ? this.preScript() : eval(this.preScript+"(this)"));
            if (!returnVal)
                return;
        }

        if(this.actNm){
            this.addParam("ACTION_NM", this.actNm);
        }

        this.addParam("dbPoolName", this.dbPoolName);
        this.addParam("PAGE_INDEX", String(this.PAGE_INDEX));
        this.addParam("PAGE_ROW"  , String(this.PAGE_ROW));

        var requestParam = $.extend({}, this.gatherParams);

        $.comm.send(this.requestUrl, requestParam, $.comm.bindAsListener(this.loadData, this));
    },
    loadData : function (data) {
        if(data.status == -1){
            alert(data.msg);
            return;
        }
        var body = $('#' + this.id);

        if(this.IS_REQ_SCROLL == false){
            body.empty();
            this.dataObj = new Array();

            $(".uncheck_all").css('display','none');
            $(".check_all").css('display','block');
        }

        var resultList = data.dataList;
        var total      = (data.total == 0 ? resultList.length : data.total);
        this.totalCount = total;

        if(this.IS_REQ_SCROLL && total == 0){
            this.IS_REQ_SCROLL = false;
            this.PAGE_INDEX--;
            return;
        }

        var totStr = "Total <span>" + total + "</span>";
        if($('#' + this.countId).length > 0){
            $('#' + this.countId).html($.comm.numberWithCommas(totStr));

        }else{
            $('.total').html($.comm.numberWithCommas(totStr));

        }

        if(resultList.length > 0){
            var index = this.dataObj.length;

            if(this.dataObj.length == 0){
                this.dataObj = resultList;
            }else{
                this.dataObj = $.merge( this.dataObj, resultList );
            }

            this.drawBody(index, resultList);
        }else{
            if($('#' + this.MORE_BTN_ID).length > 0){
                $('#' + this.MORE_BTN_ID).remove();
            }
        }

        if(this.IS_REQ_SCROLL == false && this.postScript != null) {
            $.isFunction(this.postScript) ? this.postScript(this) : eval(this.postScript+"(this)");
        }

        this.IS_REQ_SCROLL = false;
    },
    appendRow : function (index, rowIdx, rowData) {
        var value = rowData;

        var row = $("<li>");

        // 체크박스 컬럼 생성
        if(this.check){
            var check   = $("<input>");
            check.attr("type" , "checkbox");
            check.attr("id"   , this.checkId+(index+rowIdx));
            check.attr("name" , this.checkId);
            check.attr("value", index+rowIdx);

            if(value["CHK"] && (value["CHK"] == "1" || value["CHK"] == "Y")){
                check.prop("checked", true);
            }

            check.on("click", $.comm.bindAsListener(this.onCheckClick, this));
            row.append(check);
        }

        var anchor = $("<a>");
        var ul = $("<ul>");

        row.append(anchor);

        for(var k=0; k<this.headers.length; k++) {
            var obj = this.headers[k];

            var text = obj.HEAD_TEXT;  // head title
            var link = obj.LINK;       // 컬럼 링크 함수명/함수

            var val = value[obj.FIELD_NAME]; //eval("value." + obj.FIELD_NAME);

            val = ($.comm.isNull(val) ? "" : String(val));

            var col;
            if (k == 0) {
                col = $("<h2>");
                col.html(text + " : " + val);
                anchor.append(col);

                if(link){
                    if($.isFunction(link)){
                        (function(link) {
                            anchor.click(function () {
                                return link.call(this, (index+rowIdx));
                            });
                        })(link);

                    }else{
                        anchor.attr("onclick", "gfn_gridLink(\"" + link + "\", \"" + (index + rowIdx) + "\")");
                    }
                }
            }else{
                col = $("<li>");
                var span = $("<span>");
                span.html(text + ":");

                col.append(span);
                col.append(" " + val + " ");

                ul.append(col);
            }
        }
        anchor.append(ul);

        return row;
    },
    drawBody : function (index, resultList) {
        var body  = $('#' + this.id);

        for(var i=0; i<resultList.length; i++){
            this.dataObj[index+i]["RIDX"] = String(index+i);
            body.append(this.appendRow(index, i, resultList[i]));
        }

        if(this.totalCount > this.dataObj.length && $('#' + this.MORE_BTN_ID).length == 0){
            var div = $("<div>");
            div.attr("class", "btn_frame btm_btn");
            div.attr("id"   , this.MORE_BTN_ID);

            var anchor = $("<a>");
            anchor.attr("class", "btn white_btn");
            anchor.attr("style", "float: initial;margin-top: 5px;");
            anchor.html("더보기");

            anchor.on("click", $.comm.bindAsListener(this.moreSearch, this));
            div.append(anchor);
            body.after(div);
        }

        if(this.totalCount == this.dataObj.length && $('#' + this.MORE_BTN_ID).length > 0){
            $('#' + this.MORE_BTN_ID).remove();
        }
    },
    moreSearch : function () {
        if(this.totalCount == this.getSize()) return;
        this.PAGE_INDEX++;
        this.IS_REQ_SCROLL = true;
        this.requestToServer();
    },
    onCheckClick : function (obj) {
        var id   = $.comm.getTarget(obj).id;
        var idx = id.replace(this.checkId, '');
        var index = parseInt(idx);
        var val = "0";
        if($("input:checkbox[id='" + id + "']").is(":checked"))
            val = "1";

        $('.list_chk_num').text($("input[name=" + this.checkId + "]:checkbox:checked").length);

        if($("input[name="+this.checkId+"]").is(":checked") === true){
            $(".check_all").css('display','none');
            $(".uncheck_all").css('display','block');
        } else{
            $(".uncheck_all").css('display','none');
            $(".check_all").css('display','block');
        }

        this.dataObj[index]["CHK"] = val;

        if(this.checkScript != null){
            $.isFunction(this.checkScript) ? this.checkScript(index) : eval(this.checkScript+"("+index+")");
        }
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
     * 파라미터의 컬럼id가 value의 값을 갖는 첫번째 row index를 반환
     * @param colId
     * @param value
     * @returns {*}
     */
    findRow : function (colId, value) {
        for(var i=0; i<this.getSize(); i++){
            var val = this.dataObj[i][colId];
            if(val == value){
                return this.dataObj[i];
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
     * 파라미터의 boolean으로 체크박스 전체 선택 또는 전체 해제
     * @param checked
     */
    setCheckAll : function (checked) {
        if($.type(checked) == 'object'){
            if($(".check_all").css("display") == "block"){
                checked = true;

                $(".check_all").css('display','none');
                $(".uncheck_all").css('display','block');
            }else{
                checked = false;

                $(".uncheck_all").css('display','none');
                $(".check_all").css('display','block');
            }
        }
        $("input:checkbox[name='" + this.checkId + "']:enabled").prop("checked", checked);

        $('.list_chk_num').html($('input:checkbox[name="'+this.checkId+'"]:checked').length);

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
