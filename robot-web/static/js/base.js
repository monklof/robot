var DELETE = "DELETE",
    STAR = "STAR",
    DONE = "DONE";

$(".item-heading").click(function(evt){
    $(evt.target).parent(".item").find(".item-content").toggle(500);
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
    var args = {
        itemId: itemId,
        command: command
    }
    console.log("command: ", command,  "item: ", itemId, "arg: ", args);
    itemObj.remove();
    // $.ajax({
    //     type:"POST",
    //     url:"/item/delete",
    //     data: $.param(args),
    //     success: function(res){
    //         if (res.success){
    //             console.log("delete success");
    //             itemObj.remove();
    //         }else{
    //             alert(res.msg);
    //         }
    //     },
    //     error: function(res){
    //         alert("请求失败，contact monklof@gmail.com");
    //     }
    // })
});
