$(document).ready(function(){

}).on('click', '#signup', function(e){
    e.preventDefault();
    let frm = $('#form_signup');
    let data = serializeFormJSON(frm);
    let password = $('input[name="password"]').val();
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
        },
        success: function(r){
          let dt = JSON.parse(r);
          if (dt.status == 'danger') {
            Swal.fire({
              title: "Failed to signup",
              text: dt.text,
              icon: "error"
            });
        }else{
            Swal.fire({
                title: "Account created successfully!",
                text: "Please Signin through the login page.",
                icon: "success"
              }).then((result) => {
                  if (result.isConfirmed){
                    location.href = BASEURL + '/account/login/';
                  }
              });
            }
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

});
