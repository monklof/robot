/*
当注册/登录成功时，会产生一个"signuibox-success"的事件，同时会把用户信息通过第一个参数传个回调函数。
*/

function refreshCap(capid, capsrc){
    /* Refresh Recapcha (a placeholder for the current)*/
}

$("#btn-signin").click(function(evt){
    evt.preventDefault();
    var username = $("#signin-username-input").val().trim();
    var password = $("#signin-password-input").val().trim();
    $("#signin-tips").hide2();

    if (!username || !password) {
        $("#signin-tips").text("请输入用户名和密码").show2();
        return ;
    }
    password = CryptoJS.SHA256(password).toString(CryptoJS.enc.Hex);
    var args = {
        username:username,
        password:password,
    }
    $.ajax({
        type:"POST",
        url:"/signin",
        data:$.param(args),
        success:function(res){
            if (res.success){
                console.log("signin succeed! data: ", res.data);
                window.location = "/home";
            }else{
                $("#signin-tips").text(res.msg);
                $("#signin-tips").show2();
            }
        },
        error:function(res){
            $("#signin-tips").text("网络错误，请检查你的网络状况");
            $("#signin-tips").show2();
        }
    });
});

$("#btn-signup")[0].onclick = function(evt){
    evt.preventDefault();
    var $tip = $("#signup-tips");
    var regUsername=/^[a-zA-Z_\d]{4,21}$/;
    var regEmail=/^([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\.][a-z]{2,3}([\.][a-z]{2})?$/;
    // var regPhone=/(\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$/;
    $tip.hide2();
    var username = $("#signup-username-input").val().trim();
    var password = $("#signup-password-input").val().trim();
    var email = $("#signup-email-input").val().trim();
    var invitetoken = $("#signup-invitetoken-input").val().trim();
    
    if (!username || !password || !email || !invitetoken ) {return $tip.text("请填写所有信息").show2();}
    if(!username || username.length < 4){return $tip.text("用户名至少要4个字符").show2();}
    if(username.length > 20){return $tip.text("用户名不能超过20个字符").show2();}
    if(!regUsername.test(username)){return $tip.text("用户名不要包括奇怪的字符").show2();}
    if (password.length < 6){return $tip.text("密码太短").show2();}
    if(!regEmail.test(email)){return $tip.text("邮箱不存在").show2();}

    password = CryptoJS.SHA256(password).toString(CryptoJS.enc.Hex);
   
    var args = {
        username:username,
        password:password,
        email:email,
        invitetoken:invitetoken
    };
    
    $.ajax({
        type:"POST",
        url:"/signup",
        data:$.param(args),
        success:function(res){
            if (res.success){
                console.log("success signup!", res.data);
                window.location = "/home";
            }else{
                $tip.text(res.msg).show2();
            }
        },
        error:function(res){
            $tip.text("网络错误").show2();
        }
    });
}


/* sign in / sign up event*/
$("#switch-nav-bar").delegate("a.tab", "click", function(evt){
    evt.preventDefault();
    $("#switch-nav-bar a.tab").removeClass("active");
    $(this).addClass("active");
    $(".sign-groups").prop("hidden", true);
    console.log($(this).data("target"));
    $("#"+$(this).data("target")).prop("hidden", false);
})

$("#signup").keypress(function(evt){
  if(evt.keyCode==13){$("#btn-signup").click();}
});
$("#signin").keypress(function(evt){
  if(evt.keyCode==13){$("#btn-signin").click();}
});
