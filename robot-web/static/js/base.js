var DELETE = "DELETE",
    STAR = "STAR",
    DONE = "DONE";

/** reset the frame's size to it's content */
function autoResize(id){
    var newheight;
    var newwidth;

    if(document.getElementById){
        newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
        newwidth = document.getElementById(id).contentWindow.document.body.scrollWidth;
    }

    document.getElementById(id).height = (newheight) + "px";
    document.getElementById(id).width = (newwidth) + "px";
}

$(".item-list").delegate(".item-heading", "click", function(evt){
    var t = evt.currentTarget;
    var iframeObj = $(t).parent(".item").find(".item-content iframe");
    $(t).parent(".item").find(".item-content").toggle(300);
    var loadFrame = function(){
        if (iframeObj.attr("src") == undefined){
            iframeObj.attr("src", iframeObj.data("src"));
        }
    };
    setTimeout(loadFrame, 310);
});

$(".item-list").delegate(".command", "click", function(evt){
    var targetObj = $(evt.currentTarget),
        itemObj = $(evt.currentTarget).parents(".item"),
        itemId = itemObj.data("itemId"), command=undefined;
    if (targetObj.hasClass("cmd-delete"))
        command = DELETE;
    if (targetObj.hasClass("cmd-star"))
        command = STAR;
    if (targetObj.hasClass("cmd-done"))
        command = DONE;
    else{
        console.log("unrecogniced command");
        return;
    }
    evt.preventDefault();
        

    
    var args = {
        "item-id": itemId,
        command: command
    }
    console.log("command: ", command,  "item: ", itemId, "arg: ", args);
    $.ajax({
        type:"POST",
        url:"/item/markas",
        data: $.param(args),
        success: function(res){
            if (res.success){
                console.log(command + " success");
                itemObj.remove();
            }else{
                alert(res.msg);
            }
        },
        error: function(res){
            alert("请求失败，contact monklof@gmail.com");
        }
    })
});
