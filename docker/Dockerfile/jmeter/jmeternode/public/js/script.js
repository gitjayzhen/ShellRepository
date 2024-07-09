$(document).ready(function () {
    // Activate tooltip
    $('[data-toggle="tooltip"]').tooltip();

    // Select/Deselect checkboxes
    var checkbox = $('table tbody input[type="checkbox"]');
    $("#selectAll").click(function () {
        var ids = [];
        if (this.checked) {
            checkbox.each(function () {
                this.checked = true;
                ids.push(this.value);
            });
            $("#deletefiles").attr("action", "/delete/" + ids);
        } else {
            checkbox.each(function () {
                this.checked = false;
            });
            $("#deletefiles").attr("action", "/delete/");
        }
    });
    checkbox.click(function () {
        var ids = [];
        if (!this.checked) {
            $("#selectAll").prop("checked", false);
        }
        checkbox.each(function () {
            if (this.checked) {
                ids.push(this.value);
            }
        });
        if (ids.length == checkbox.length) {
            $("#selectAll").prop("checked", true);
        }

        $("#deletefiles").attr("action", "/delete/" + ids);
    });
});
function rightpw(form) {
    console.log("rightpw")
    console.log(form.ip.value)
    $.ajax({
        url: '/rightpw',
        dataType: "json",
        data: 'ip=' + form.ip.value + '&user=' + form.user.value + '&pw=' + form.pw.value,
        type: 'POST',
        success: function (data) {
            console.log(data);
            form.rightpw.value = form.pw.value
        },
        error: function (error, status, message) {
            alert("Authentication failed!");
            form.rightpw.value = ""
        }
    });
}
function rightpro(form) {
    console.log("rightpro")
    console.log(form.ip.value)
    $.ajax({
        url: '/rightpro',
        dataType: "json",
        data: 'ip=' + form.ip.value + '&user=' + form.user.value + '&pw=' + form.pw.value + '&process=' + form.process.value,
        type: 'POST',
        success: function (data) {
            console.log(data);
            form.rightpro.value = form.process.value
        },
        error: function (error, status, message) {
            alert("can't find this process!");
            form.rightpro.value = ""
        }
    });
}
function CheckChart(form) {
    if (form.status.value == "wrong") {
        alert("jmx file is wrong")
        return false
    } else {
        if (form.ip.value != "" && form.user.value != "" && form.pw.value != "" && form.process.value != "") {
            if (form.rightpw.value != "") {
                if (form.rightpro.value != "") {
                    return true
                } else {
                    alert("can't find this process!")
                    return false
                }
            } else {
                alert("Authentication failed!")
                return false
            }
        } else {
            alert("can't be empty!")
            return false
        }
    }
}
function CheckJmx(form) {
    if (form.name.value != "" && form.files.value != "") {
        if (form.rightname.value != "") {
            return true
        } else {
            alert("name must be uniq!")
            return false
        }
    } else {
        alert("can't be empty!")
        return false
    }
}
/**
*根据指定长度截取字符串，string表示待截取字符串，
*maxLen表示截取后字符串长度
*/
function strLenCut(string, maxLen) {
    var strCut = "",len = 0 ;
    for (var i = 0; i < string.length; i = i + 1) {
        charA = string.charAt(i);
        if (escape(charA).length > 4) {
            /*汉字编码后长度大于4*/
            len = len + 2;
        } else {
            len = len + 1;
        }
        if (len <= maxLen) {
            /*未超出指定长度，拼接到返回的字符串中*/
            strCut = strCut.concat(charA);
        } else {
            /*超出指定长度，显示...*/
            strCut = strCut.concat("...");
            break;
        }
    }
    return strCut;
}