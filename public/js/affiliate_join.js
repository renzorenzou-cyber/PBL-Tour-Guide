// import Swal from 'sweetalert2'

// or via CommonJS
// const Swal = require('sweetalert2')
// alert('oi')
// Swal.fire({
//   title: 'Error!',
//   text: 'Do you want to continue',
//   icon: 'error',
//   confirmButtonText: 'Cool'
// })

// const { value: text } = await Swal.fire({
//   input: "textarea",
//   inputLabel: "Message",
//   inputPlaceholder: "Type your message here...",
//   inputAttributes: {
//     "aria-label": "Type your message here"
//   },
//   showCancelButton: true
// });
// if (text) {
//   Swal.fire(text);
// }

$(document).on('ready', function (e) {
	
}).on('click','#joinaffiliate',function(e){
	e.preventDefault();
    let frm = $('#form_affiliate_signup');
    let data = serializeFormJSON(frm);
	$.ajax({
        url: BASEURL+'/page/join/',
		type:'POST',
		data: data,
		beforeSend: function(){
			$('#form_affiliate_signup :input').prop("disabled",true);
		},
		success : function(r){
			$('#form_affiliate_signup :input').prop("disabled",false);
		}
	});
})