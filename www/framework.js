/*  client-side functions */

$(document).ready(function() {
    // let setCWHeight = function(){
    //     $(".content-wrapper").height($(window).height() - 200);
    // };
    // setCWHeight();
    // $(window).resize(setCWHeight);
    $(".option-input").on('click', function(){

        console.log("XXXXXXXXX");

        $(".option-help").hide();
        let id = $(this).data('help');
        $("#" + id).show();

        console.log(id)
        // Shiny.setInputValue('resetPage', true, {priority: "event"}); 
    });
});
