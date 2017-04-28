/**
 * Created by sdh on 2017-01-31.
 */
FileUtil = function (params) {
    this.fileId          = ($.comm.isNull(params.id) ? "inputFile" : params.id);    // input type='file' 인 tag ID
    this.attachId        = params.attachId;         // ATCH_FILE_ID
    this.gridDiv         = params.gridDiv;          // 멀티파일첨부일때 그리드 DIV ID
    this.addBtnId        = params.addBtnId;         // 파일업로드 버튼 ID
    this.delBtnId        = params.delBtnId;         // 파일삭제 버튼 ID
    this.downBtnId       = params.downBtnId;        // 파일다운로드 버튼 ID (싱글 일때)
    this.downloadFn      = params.downloadFn;       // 파일다운로드 함수명(멀티 일때)
    this.headers         = ($.comm.isNull(params.headers)         ? null : params.headers);         // 멀티파일첨부 그리드의 헤더
    this.fileGridWrapper = ($.comm.isNull(params.fileGridWrapper) ? null : params.fileGridWrapper); // 멀티파일첨부 그리드 Object
    this.addUrl          = ($.comm.isNull(params.addUrl) ? "/common/uploadFiles.do" : params.addUrl);// 업로드 요청 URL
    this.delUrl          = ($.comm.isNull(params.delUrl) ? "/common/deleteFiles.do" : params.delUrl);// 삭제 요청 URL
    this.successCallback = params.successCallback;      // 성공시 콜백함수
    this.postService     = params.postService;          // 파일 업로드후 실행할 '서비스ID.메서드명'
    this.preAddScript    = params.preAddScript;
    this.preDelScript    = params.preDelScript;
    this.postDelScript   = params.postDelScript;
    this.params          = ($.comm.isNull(params.params)   ? {} : params.params);
    this.extNames        = ($.comm.isNull(params.extNames) ? [] : params.extNames);

    this.formObj;

    this.fileUploadScreenDiv = params.fileUploadScreenDiv; // as-is 화면구분 ('X' 들어오는 경우가 있음)

    // 멀티 첨부일때
    if(!$.comm.isNull(this.gridDiv)){
        // 첨부파일 그리드
        if(this.headers == null){
            this.headers = [
                {"HEAD_TEXT": "파일명"  , "WIDTH": "*"  , "FIELD_NAME": "ORIGNL_FILE_NM", "ALIGN":"left", "LINK":this.downloadFn},
                {"HEAD_TEXT": "파일크기", "WIDTH": "120", "FIELD_NAME": "FILE_MG"       , "ALIGN":"right"}
            ]
        }
        if(this.fileGridWrapper == null){
            var controllers = [];
            if(!$.comm.isNull(this.delBtnId)){
                var deletePram = {"btnName": this.delBtnId, "type": "D", "targetURI":this.delUrl};
                if(!$.comm.isNull(this.preDelScript)){
                    deletePram["preScript"] = this.preDelScript;
                }
                if(!$.comm.isNull(this.postDelScript)) {
                    deletePram["postScript"] = this.postDelScript;
                }

                controllers.push(deletePram);
            }

            var params = {
                "POST_SERVICE" : this.postService
            }

            this.fileGridWrapper = new GridWrapper({
                "actNm"        : "첨부파일 조회",
                "targetLayer"  : this.gridDiv,
                "qKey"         : "file.selectFileInfoPaging",
                "displayNone"  : ["countId"],
                "headers"      : this.headers,
                "firstLoad"    : false,
                "check"        : true,
                "paramsGetter" : params,
                "controllers"  : controllers
            });
        }
    }

    this.initializeLayer();

}

FileUtil.prototype = {
    initializeLayer: function() {
        if($.comm.isNull(this.gridDiv)){
            if(!$.comm.isNull(this.downBtnId)){
                $('#' + this.downBtnId).on("click", $.comm.bindAsListener(this.downLoad, this));
            }
            if(!$.comm.isNull(this.delBtnId)){
                $('#' + this.delBtnId).on("click", $.comm.bindAsListener(this.deleteFile, this));
            }
        }

        $('#' + this.addBtnId).on("click", $.comm.bindAsListener(this.addDialog, this));
    },
    addDialog: function () {
        if(!$.comm.isNull(this.preAddScript)){
            var retVal = $.isFunction(this.preAddScript) ? this.preAddScript($(this)) : eval(this.preAddScript+"(this)");
            if(!retVal) return;
        }

        var body = $("body");
        if(!$.comm.isNull(this.formObj) && this.formObj.length > 0 ){
            this.formObj.remove();
        }

        this.formObj = $("<form>");
        var fileObj = $("<input>");
        fileObj.attr({
            "type"    : "file",
            "style"   : "display:none",
            "id"      : this.fileId
        });

        if(!$.comm.isNull(this.gridDiv)){
            fileObj.attr("name"    , this.fileId+"[]");
            fileObj.attr("multiple", "");
        }else{
            fileObj.attr("name", this.fileId);
        }

        this.formObj.append(fileObj);
        body.append(this.formObj);

        $('#' + this.fileId).on("change", $.comm.bindAsListener(this.addCallback, this));
        $('#' + this.fileId).click();
    },
    addCallback: function () {
        if(!$.comm.isNull(this.extNames)){
            var fileArr = [];
            if(!$.comm.isNull(this.gridDiv)){
                fileArr = $('input[name="'+this.fileId+"[]"+ '"]');
            }else{
                fileArr = $('input[name="'+this.fileId+ '"]');
            }

            for(var i=0; i < fileArr.length; i++){
                var ext = fileArr[i].value.split(".");
                ext = ext[ext.length-1];
                if ($.inArray(ext, this.extNames) == -1) {
                    alert(this.extNames.toString() + ' 파일만 업로드 할수 있습니다.');
                    return;
                }
            }
        }

        var tempVal = ($.comm.isNull(this.attachId) ? '' : this.attachId);

        if(this.formObj.find("input[name=ATCH_FILE_ID]").length == 0){
            this.formObj.append("<input type='hidden' name='ATCH_FILE_ID' value='" + tempVal + "'>");
        }else{
            this.formObj.find("input[name=ATCH_FILE_ID]").val(tempVal);
        }

        tempVal = ($.comm.isNull(this.fileUploadScreenDiv) ? '' : this.fileUploadScreenDiv);

        if(this.formObj.find("input[name=FILE_UPLOAD_SCREEN_DIV]").length == 0){
            this.formObj.append("<input type='hidden' name='FILE_UPLOAD_SCREEN_DIV' value='" + tempVal + "'>");
        }else{
            this.formObj.find("input[name=FILE_UPLOAD_SCREEN_DIV]").val(tempVal);
        }

        tempVal = ($.comm.isNull(this.postService) ? '' : this.postService);

        if(this.formObj.find("input[name=POST_SERVICE]").length == 0){
            this.formObj.append("<input type='hidden' name='POST_SERVICE' value='" + tempVal + "'>");
        }else{
            this.formObj.find("input[name=POST_SERVICE]").val(tempVal);
        }

        for(var key in this.params) {
            var val = this.params[key];
            val = ($.comm.isNull(val) ? '' : val);
            if(this.formObj.find("input[name=" + key + "]").length == 0){
                this.formObj.append("<input type='hidden' name='" + key + "' value='" + val + "'>");
            }else{
                this.formObj.find("input[name=" + key + "]").val(val);
            }
        }

        $.comm.wait(true);
        $(this.formObj).ajaxForm({
            url: this.addUrl,
            type: "POST",
            enctype: "multipart/form-data",
            beforeSubmit: null,
            headers :{
                "sessionDiv": $.comm.getGlobalVar("sessionDiv"),
                "GLOBAL_LOGIN_USER_ID": $.comm.getGlobalVar("GLOBAL_LOGIN_USER_ID")
            },
            successCallback: this.successCallback,
            fileGridWrapper: this.fileGridWrapper,
            attachId: this.attachId,
            success: function(data, status){
                $.comm.wait(false);
                if(!$.comm.isNull(data.code)){

                    if(data.code == "E00000002"){ // 세션이 만료되었습니다.
                        alert($.comm.getMessage(data.code));


                        var div = $.comm.getGlobalVar("sessionDiv");
                        var url = "/login.do";
                        if(div == 'M'){
                            url = "/adminLogin.do"
                        }

                        if(!$.comm.isNull(window.parent)){
                            window.parent.location.href = url;
                        }else{
                            window.location.href = url;
                        }

                        return;

                    }else if(data.code == "E00000003"){ // 시스템에러가 발생하였습니다.
                        alert($.comm.getMessage(data.code));
                        console.log(data.msg);

                        return;
                    }
                }

                if(!$.comm.isNull(data.code)){
                    alert($.comm.getMessage(data.code));
                }else{
                    if(!$.comm.isNull(data.msg)){
                        alert(data.msg);
                    }
                }

                var retData = data.data;
                this.attachId = retData["ATCH_FILE_ID"];

                if(!$.comm.isNull(this.gridDiv)) {
                    this.fileGridWrapper.requestToServer();
                }

                if(!$.comm.isNull(this.successCallback)) {
                    this.successCallback(data, status, this.ownerObj);
                }
            },
            //ajax error
            error: function(){
                $.comm.wait(false);
                alert("파일업로드 실패!!");
            }
        });

        $(this.formObj).submit();
    },
    /**
     * 파일리스트 조회
     * @param param
     */
    selectFileList: function (param) {
        for(var key in param){
            this.fileGridWrapper.addParam(key, param[key]);
        }
        this.fileGridWrapper.requestToServer();
    },
    deleteFile: function () {
        if(!$.comm.isNull(this.preDelScript)){
            var retVal = $.isFunction(this.preDelScript) ? this.preDelScript($(this)) : eval(this.preDelScript+"(this)");
            if(!retVal) return;
        }

        var fileSn = ($('#FILE_SN').length == 0 ? "0" : $('#FILE_SN').val());
        var data = {
            "ATCH_FILE_ID" : $('#ATCH_FILE_ID').val(),
            "FILE_SN"      : ($.comm.isNull(fileSn) ? "0" : fileSn)
        }

        if(!$.comm.isNull(this.postService)) {
            data["POST_SERVICE"] = this.postService;
        }

        $.comm.send(this.delUrl, data, this.successCallback, "첨부파일 삭제");
    },
    downLoad: function () {
        var fileSn = ($('#FILE_SN').length == 0 ? "0" : $('#FILE_SN').val());
        var data = {
            "ATCH_FILE_ID" : $('#ATCH_FILE_ID').val(),
            "FILE_SN"      : ($.comm.isNull(fileSn) ? "0" : fileSn)
        }

        $.comm.fileDownload(data, "첨부파일 다운로드");
    },
    fileDownload: function (index) {
        var data = this.fileGridWrapper.getRowData(index);
        $.comm.fileDownload(data, "첨부파일 다운로드");
    },
    setAtchFileId: function (atchFileId) {
        this.attachId = $.comm.isNull(atchFileId) ? "" : atchFileId;
    },
    initGrid: function () {
        this.fileGridWrapper.initializeLayer();
    },
    addParam:function (key, val) {
        if(this.fileGridWrapper != null){
            this.fileGridWrapper.addParam(key, val);
        }
        this.params[key] = val;
    },
    setParams: function (params) {
        if(this.fileGridWrapper != null){
            this.fileGridWrapper.setParams(params);
        }
        this.params = params;
    },
    clear: function () {
        this.params = {};
        this.attachId = null;
        this.initGrid();
    }
}
