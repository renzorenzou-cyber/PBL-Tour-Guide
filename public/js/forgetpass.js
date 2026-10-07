$(document).ready(function(e){

}).on('click', '#forget', function(e){
    e.preventDefault();

    let frm = $('#form_forget');
    let data = serializeFormJSON(frm);

    console.log(data);

    $.ajax({
        url: BASEURL + '/account/forgetpasswordprocess/',
        type: 'POST',
        data: data,
        beforeSend: function(){
            $('#form_signin :input').prop("disabled", true);
            HoldOn.open({
                theme: 'sk-dot',
                message: "<h4>Please wait...</h4>"
            });
        },
        success: function(r){
          HoldOn.close();
            let dt = JSON.parse(r);
            $('#form_signin :input').prop("disabled", false);
            console.log(dt);

            if (dt.status == 'success') {
                Swal.fire({
                    title: "Email has been send!",
                    text: dt.text,
                    icon: "success"
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = BASEURL + '/account/login/';
                    }
                });
            } else if (dt.status == 'danger') {
                Swal.fire({
                    title: "Your email is not registered",
                    text: dt.text,
                    icon: "error"
                });
            }
        },
        error: function(){
            Swal.fire({
                title: "Oops!",
                text: "Something went wrong, please try again.",
                icon: "error"
            });
            $('#form_signin :input').prop("disabled", false);
        }
    });
}).on('click','#newpassword', function(e) {
    e.preventDefault();

    let frm = $('#form_newpassword');
    let data = serializeFormJSON(frm);
    console.log(data);
    let password = $('input[name="password"]').val();
    let confirmPassword = $('input[name="confirm_password"]').val();
    const fullUrl = window.location.href;
    const hashId = fullUrl.split('/').pop(); // Ambil hash ID dari URL
    // console.log('Hash ID:', hashId); // Debug hash ID


    if (password !== confirmPassword) {
        Swal.fire({
            title: "Password doesn't match!",
            text: "Please check your password",
            icon: "error"
        });
        return;
    } 

        data.password = password;
        data.hash_id = hashId;
        
        $.ajax({
            url: BASEURL + '/account/requestnewpasswordprocess/',
            type: 'POST',
            data: data,
            beforeSend: function(){
                $('#form_newpassword :input').prop("disabled", true);
            },
            success: function(r){
                let dt = JSON.parse(r);
                $('#form_newpassword :input').prop("disabled", false);
                // console.log(dt);
    
                if (dt.status == 'success') {
                    Swal.fire({
                        title: "Password Changed Successfully!",
                        text: dt.text,
                        icon: "success"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.href = BASEURL + '/account/login/';
                        }
                    });
                }
            },
            error: function(){
                Swal.fire({
                    title: "Oops!",
                    text: "Something went wrong, please try again.",
                    icon: "error"
                });
                $('#form_newpassword :input').prop("disabled", false);
            }
        });
        
});