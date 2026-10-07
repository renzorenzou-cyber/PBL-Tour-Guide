
$(document).on('ready', function (e) {
	
}).on('click','#loginaffiliate',function(e){
	e.preventDefault();
    let frm = $('#form_affiliate_login');
    let data = serializeFormJSON(frm);
	$.ajax({
        url: BASEURL+'/page/login/',
		type:'POST',
		data: data,
		beforeSend: function(){
			$('#form_affiliate_login :input').prop("disabled",true);
		},
		success : function(r){
			let dt = JSON.parse(r);
			console.log(dt)
			$('#form_affiliate_login :input').prop("disabled",false);
		}
	});
})