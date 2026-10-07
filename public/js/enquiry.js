$(document).ready(function(){

}).on('click', '#submit_enquiry', function(){

    let frm = $('#enquiryForm');
    let data = serializeFormJSON(frm);

    // ambil response captcha
    let captchaResponse = grecaptcha.getResponse();
    if (!captchaResponse) {
        Swal.fire({
            title: "Oops!",
            text: "Please verify that you are not a robot.",
            icon: "error"
        });
        return; // stop kirim kalau captcha belum dicentang
    }

    // masukin captcha ke data
    data['g-recaptcha-response'] = captchaResponse;

    $.ajax({
        url: BASEURL + '/index/enquiry',
        type: 'POST',
        data: data,
        beforeSend: function(){
            $('#enquiryForm :input').prop("disabled", true);
            HoldOn.open({
              theme: 'sk-dot',
              message: "<h4>Processing..</h4>"
            });
        },
        success: function(r){
            HoldOn.close();
            Swal.fire({
                title: "success!",
                text: "Thanks for reaching out! We’ve received your enquiry and will get back to you soon.",
                icon: "success"
              }).then((result) => {
                  if (result.isConfirmed){
                    location.href = BASEURL;
                  }
              });
        },
    });
})
