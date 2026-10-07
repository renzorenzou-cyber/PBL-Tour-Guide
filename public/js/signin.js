$(document).ready(function(e){

}).on('click','#signin', function(e){
    e.preventDefault();
    let frm = $('#form_signin');
    let data = serializeFormJSON(frm);

    console.log(data);

    $.ajax({
        url: BASEURL + '/account/loginprocess/',
        type: 'POST',
        data: data,
        beforeSend: function(){
            $('#form_signin :input').prop("disabled", true);
        },
        success: function(r){
            let dt = JSON.parse(r);
            $('#form_signin :input').prop("disabled", false);
            console.log(dt);

            if (dt.status == 'success') {
                Swal.fire({
                    title: "Login successfully!",
                    text: "Welcome To Tropialis",
                    icon: "success"
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = BASEURL + '/account/orders/';
                    }
                });
            } else if (dt.status == 'danger') {
                Swal.fire({
                    title: "User not found",
                    text: dt.text,
                    icon: "error"
                });
            } else if(dt.status == 'warning'){
                Swal.fire({
                    title: "account has not been activated",
                    text: dt.text,
                    icon: "warning"
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
}).on('click', '#signup', function(e){
    e.preventDefault();
    let frm = $('#form_signup');
    let data = serializeFormJSON(frm);
    let password = $('input[name="signup_password"]').val();
    let confirmPassword = $('input[name="confirm_password"]').val();

    if (password !== confirmPassword) {
        Swal.fire({
            title: "Password doesn't match!",
            text: "Please check your password",
            icon: "error"
        });
        return false;
    }

    if(data.first_name == ''){ 
      Swal.fire({
        title: "First Name is empty",
        text: "Please fill the First name!",
        icon: "warning"
      }); return false;
    }

    if(data.second_name == ''){ 
      Swal.fire({
        title: "Second Name is empty",
        text: "Please fill the second name!",
        icon: "warning"
      }); return false;
    }

    if(data.email == ''){ 
      Swal.fire({
        title: "Email is empty",
        text: "Please fill the!",
        icon: "warning"
      }); return false;
    }

    console.log(data);

    $.ajax({
        url: BASEURL + '/account/signupprocess/',
        type: 'POST',
        data: data,
        beforeSend: function(){
            $('#form_signup :input').prop("disabled", true);
            HoldOn.open({
                theme: 'sk-dot',
                message: "<h4>Please wait...</h4>"
            });
        },
        success: function(r){
          HoldOn.close();
            $('#form_signup :input').prop("disabled", false);
          setTimeout(function() { // Tambah jeda 500ms sebelum Swal muncul
            let dt = JSON.parse(r);
            if (dt.status == 'danger') {
                Swal.fire({
                    title: "Failed to signup",
                    text: dt.text,
                    icon: "error"
                });
            } else if (dt.status == 'success'){
                Swal.fire({
                    title: "Account created successfully!",
                    text: dt.text,
                    icon: "success"
                }).then((result) => {
                    if (result.isConfirmed){
                        location.href = BASEURL + '/account/login/';
                    }
                });
            }
        }, 500);
        },
    });
}).on('change', '#terms', function () {
    if ($(this).is(':checked')) {
        Swal.fire({
          title: "Terms and Conditions",
          text: "Welcome to Tropialis! By signing up and using our services, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.",
          icon: "warning",
          confirmButtonText: "I Agree",
        }).then((result) => {
          if (result.isConfirmed) {
            $('#signup').prop('disabled', false);
          } else {
            $(this).prop('checked', false);
            $('#signup').prop('disabled', true);
          }
        });
      } else {
        $('#signup').prop('disabled', true);
      }

}).on('submit', '#resend-form', function(e){
    e.preventDefault();
    let email = $('input[name="email"]').val();

    $.ajax({
      url: BASEURL + '/account/resendactivation/',
      method: 'POST',
      data: { email },
      beforeSend: function() {
        $('#resend-btn').prop('disabled', true).text('Sending...');
      },
      success: function(res) {
        let r = JSON.parse(res);
        Swal.fire(r.title, r.text, r.icon);
        $('#resend-btn').prop('disabled', false).text('Resend Activation Link');
      }
    });
  });

