$(document).ready(function(){
let ids = [];
$('.extra_infos').each(function(){
  let id = $(this).data('id');
  let cartId = $(this).data('cartid');
  if(id && cartId) {
    ids.push({ id: id, cart_id: cartId });
  }
});


  function loadAddonAfterExtras() {
    let idextra = [];
    $('.addExtras').each(function () {
      const id = $(this).data('id');
      if (id) idextra.push(id);
    });

    if (idextra.length > 0) {
      $.ajax({
        url: BASEURL + "/cart/loadaddon/",
        type: 'POST',
        data: { addon_ids: JSON.stringify(idextra) },
        success: function (response) {
          let validExtras = [];

          try {
            validExtras = JSON.parse(response);
          } catch (e) {
            console.error("Gagal parse JSON:", response);
            return;
          }

          const grouped = {};
          validExtras.forEach(extra => {
            const rateIds = (extra.rates || '').split(',').map(id => parseInt(id));
            rateIds.forEach(rate => {
              if (!grouped[rate]) grouped[rate] = [];
              grouped[rate].push(extra);
            });
          });

          $('.addExtras').each(function () {
            const rateId = $(this).data('id');
            const extrasForRate = grouped[rateId] || [];
          
            if (extrasForRate.length > 0) {
              $(this).addClass('d-flex');
              $(this).removeClass('d-none');
              $(this).data('addextras', extrasForRate);
            } else {
              $(this).remove(); //remove button jika tidak ada id yg cocok
            }
          });

          $(document).on('click', '.addExtras', function () {
            const raw = $(this).data('addextras') || [];
            const parentItemId = $(this).data('cartid');

            // FILTER hanya yang cocok untuk item ini
            const filteredAddons = raw.filter(addon => {
              return addon.cart_id == parentItemId || addon.cart_id === null;
            });
            // console.log('filtered',filteredAddons);

    // Mapping qty sebelumnya berdasarkan nama
    const selectedAddonQty = {};
    filteredAddons.forEach(addon => {
        selectedAddonQty[addon.id] = addon.qty || 0;
    });

    console.log(selectedAddonQty);

            // console.log(raw)
        
            if (!raw.length) {
              Swal.fire({
                icon: 'info',
                title: 'No extras available',
                text: 'Tidak ada data extras untuk item ini.'
              });
              return;
            }
        
            let formHtml = `
              <form id="extrasForm" style="padding: 20px;">
                <div style="
                  display: grid; 
                  grid-template-columns: 2fr 3fr 1fr 2fr; 
                  gap: 16px; 
                  font-weight: 600;
                  text-align:start !important; 
                  font-size: 14px; 
                  border-bottom: 1px solid #eee; 
                  padding-bottom: 12px; 
                  margin-bottom: 20px; 
                  color: #222;">
                  <div style="padding-left:15px;"><h6 class="poppins-semibold">Name</h6></div>
                  <div><h6 class="poppins-semibold">Description</h6></div>
                  <div><h6 class="poppins-semibold">Price</h6></div>
                  <div><h6 class="poppins-semibold">Quantity</h6></div>
                </div>
                <div class="extras-scroll-container">
            `;
        
            filteredAddons.forEach(function (extra, index) {
              const prevQty = selectedAddonQty[extra.id] || 0;
              if(prevQty > 0){
              formHtml += `
                <div class="extra-row" style="
                  display: grid;
                  grid-template-columns: 2fr 3fr 1fr 2fr;
                  gap: 16px;
                  font-size: 13px;
                  padding: 14px 0 15px;
                  margin-bottom:5px;
                  background-color:#87CEEB;
                  color:white !important;
                  border-radius:8px;
                  border-bottom: 1px solid #f0f0f0;
                  color: #444;">
                  <div style="padding-left:15px;"><span class="poppins-medium">${extra.nama}</span></div>
                  <div style="font-size: 12px;"><span class="poppins-medium">${extra.keterangan || '-'}</span></div>
                  <div style="font-weight: 500;"><span class="poppins-medium">Rp${parseInt(extra.harga).toLocaleString('id-ID')}</span></div>
                  <div style="display: flex; gap: 8px;">
                      <button type="button" class="qty-btn minus" data-index="${index}">−</button>
                      <input type="number" class="extra-qty-input" value="${prevQty}" min="0" value="0" name="qty[${index}]"
                        data-extra='${JSON.stringify(extra)}' readonly />
                      <button type="button" class="qty-btn plus" data-index="${index}">+</button>
                    </div>
                  </div>
                `;
              } else {
                formHtml += `
                <div class="extra-row" style="
                  display: grid;
                  grid-template-columns: 2fr 3fr 1fr 2fr;
                  gap: 16px;
                  font-size: 13px;
                  padding: 14px 0 15px;
                  margin-bottom:5px;
                  border-radius:8px;
                  border-bottom: 1px solid #f0f0f0;
                  color: #444;">
                  <div style="padding-left:15px;"><span class="poppins-medium">${extra.nama}</span></div>
                  <div style="font-size: 12px;"><span class="poppins-medium">${extra.keterangan || '-'}</span></div>
                  <div style="font-weight: 500;"><span class="poppins-medium">Rp${parseInt(extra.harga).toLocaleString('id-ID')}</span></div>
                  <div style="display: flex; gap: 8px;">
                      <button type="button" class="qty-btn minus" data-index="${index}">−</button>
                      <input type="number" class="extra-qty-input" value="${prevQty}" min="0" name="qty[${index}]"
                        data-extra='${JSON.stringify(extra)}' readonly />
                      <button type="button" class="qty-btn plus" data-index="${index}">+</button>
                    </div>
                  </div>
                `;
              }
                  
            });
        
            formHtml += `</div></form>`;
        
            Swal.fire({
              title: '<span style="font-size:18px; font-weight:600; color:#111;">Choose Add-on</span>',
              html: formHtml,
              showCancelButton: true,
              confirmButtonText: 'Add Selected',
              cancelButtonText: 'Cancel',
              customClass: {
                popup: 'extras-popup',
                confirmButton: 'extras-confirm-btn',
                cancelButton: 'extras-cancel-btn',
              },
              buttonsStyling: false,
              width: '720px',
              background: '#fff',
            }).then((result) => {
              if (result.isConfirmed) {
                const selectedExtras = [];
                const parentItemId = $(this).data('itemid'); // ← ambil dari tombol

                $('#extrasForm input[type="number"]').each(function () {
                  const qty = parseInt($(this).val());
                  const extra = $(this).data('extra');

                    selectedExtras.push({
                      ...extra,
                      qty,
                      item_id: parentItemId
                    });
                  
                  
                });

                if (selectedExtras.length > 0) {
                  $.ajax({
                    url: BASEURL + "/cart/addaddon/",
                    type: "POST",
                    data: { addons: JSON.stringify(selectedExtras) },
                    success: function (response) {
                      Swal.fire("Success", "Add-ons have been added!", "success")
                        .then(() => location.reload());
                    }
                  });
                }
              }
            });
          });
        
          // Button handler
          $(document).on('click', '.qty-btn.plus', function () {
            const index = $(this).data('index');
            const input = $(`input[name='qty[${index}]']`);
            let current = parseInt(input.val()) || 0;
            input.val(current + 1);
            // Cek dan update background
            const newQty = parseInt(input.val());
            const parentRow = input.closest('.extra-row');

            if (newQty > 0) {
              parentRow.addClass('extra-selected');
            } else {
              parentRow.removeClass('extra-selected');
            }
          });
        
          $(document).on('click', '.qty-btn.minus', function () {
            const index = $(this).data('index');
            const input = $(`input[name='qty[${index}]']`);
            let current = parseInt(input.val()) || 0;
            if (current > 0) input.val(current - 1);
            // Cek dan update background
            const newQty = parseInt(input.val());
            const parentRow = input.closest('.extra-row');

            if (newQty > 0) {
              parentRow.addClass('extra-selected');
            } else {
              parentRow.removeClass('extra-selected');
            }
                    });
                  }
                });
              }
            }

  // Load extras dulu
  if(ids.length > 0) {
    $.ajax({
      url: BASEURL + "/cart/loadextra/",
      type: 'POST',
      data: { extra_ids: JSON.stringify(ids) },
      success: function(response){
        let dt = [];
        try {
          dt = JSON.parse(response);
        } catch (e) {
          console.error("Gagal parse JSON di loadextra:", response);
        }

        dt.forEach(w => {
          let targetElement = $('.extra_infos[data-id="'+w.rate_option_id+'"][data-cartid="'+w.cart_id+'"]');

          let html = '';

          if(w.extra_type == 'option'){
            html = `<div class="row mt-1 mb-1">
                      <label class="col-lg-4 col-md-4 col-sm-12">${w.extra_name}</label>
                      <div class="col-lg-8 col-md-8 col-sm-12">
                        <select name="extras_${w.extra_name_slug}_${w.id}_${w.cart_id}" class="form-control">`;
            let opt = JSON.parse(w.extra_value);
            opt.option.forEach(item => {
              html += `<option value="${item || ''}">${item || 'Please select'}</option>`;
            });
            html += '</select></div></div>';
          } else if(w.extra_type == 'text'){
            html = `<div class="row mt-1 mb-1">
                      <label class="col-lg-4 col-md-4 col-sm-12">${w.extra_name}</label>
                      <div class="col-lg-8 col-md-8 col-sm-12">
                        <textarea name="extras_${w.extra_name_slug}_${w.id}_${w.cart_id}" class="form-control"></textarea>
                      </div>
                    </div>`;
          } else if(w.extra_type == 'input'){
            html = `<div class="row mt-1 mb-1">
                      <label class="col-lg-4 col-md-4 col-sm-12">${w.extra_name}</label>
                      <div class="col-lg-8 col-md-8 col-sm-12">
                        <input name="extras_${w.extra_name_slug}_${w.id}_${w.cart_id}" class="form-control" />
                      </div>
                    </div>`;
          } else if (w.extra_type == 'date'){
            html = `<div class="row mt-1 mb-1">
                      <label class="col-lg-4 col-md-4 col-sm-12">${w.extra_name}</label>
                      <div class="col-lg-8 col-md-8 col-sm-12">
                        <input type="date" name="extras_${w.extra_name_slug}_${w.id}_${w.cart_id}" class="form-control" />
                      </div>
                    </div>`;
          }

          targetElement.append(html);
        });

        // Setelah sukses load extras, baru load addon
        loadAddonAfterExtras();
      }
    });
  } else {
    // Kalau tidak ada extras, langsung load addon
    loadAddonAfterExtras();
  }
}).on('click','.extraform',function(e){ 
  let tis = $(this);
  let id = tis.data('id');
  let group = tis.data('group');
  $.ajax({
    url: BASEURL+"/cart/loadextraform/",
    type:'POST',
    data: {},
    success : function(r){
      let html = 'ok';
        Swal.fire({
          title: "Extra Information",
          html: html
        }).then((result) => {
            if (result.isConfirmed){
                
            }
        });
    }
})
}).on('keyup','#email',function(e){
     var email = $(this).val();
     var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
 
     if (emailRegex.test(email)) {
       $('#emailMessage').text('Email is valid').css('color', 'green');
     } else {
       $('#emailMessage').text('Email is invalid').css('color', 'red');
     }
   
 }).on('input','#phone_number',function(e){
   let tis = $(this);
   let phoneNumber = tis.val();
     
     // Ensure the first character is a +
     if (phoneNumber.length === 1 && phoneNumber !== '+') {
       $(this).val('+');
     }
 
     // Remove invalid characters after the first character
     // var sanitized = phoneNumber[0] + phoneNumber.slice(1).replace(/[^0-9\-\.\s\(\)]/g, '');
     // $(this).val(sanitized);
 
 }).on('keyup', '#phone_number', function() {
     var phoneNumber = $(this).val();
     var regex = /^\+?(\d{1,3})[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}$/;
 
     if (regex.test(phoneNumber)) {
       $('#phone_text').text('Phone number is valid').css('color', 'green');
     } else {
       $('#phone_text').text('Phone number is invalid').css('color', 'red');
     }
 
 }).on('click','#checkout-button',function(e){
  // let html = 'By clicking confirm, you agree to the <a id="terms" style="text-decoration: underline; cursor: pointer">terms</a> and <a id="cancellation_policy" style="text-decoration: underline; cursor: pointer">cancellation policy</a>.';
  // Swal.fire({
  //   title: 'Please confirm your booking to proceed.',
  //   html: html,
  //   icon: "warning",
  //   showCancelButton: true,
  //   confirmButtonColor: "#334960",
  //   cancelButtonColor: "#d33",
  //   confirmButtonText: "Yes, Confirm!",
  //   cancelButtonText: 'No'
  // }).then((result) => {
  //   if (result.isConfirmed) {
      let frm = $('#form_cart');
      let data = serializeFormJSON(frm);
      console.log(data);
      // return false;
      if(data.first_name == ''){ 
        Swal.fire({
          title: "First Name is empty",
          text: "Please fill the First name!",
          icon: "warning"
        }); return false;
      }
      if(data.last_name == ''){ 
        Swal.fire({
          title: "Last Name is empty",
          text: "Please fill the Last name!",
          icon: "warning"
        }); return false;
      }
      if(data.passport == ''){ 
        Swal.fire({
          title: "ID / Passport number is empty",
          text: "Please fill the ID / Passport Number!",
          icon: "warning"
        }); return false;
      }
      if(data.country == ''){ 
        Swal.fire({
          title: "Country is empty",
          text: "Please select the Country!",
          icon: "warning"
        }); return false;
      }
      if(data.phone_number == ''){ 
        Swal.fire({
          title: "Phone Number is empty",
          text: "Please fill the Phone Number!",
          icon: "warning"
        }); return false;
      }
      if(data.email == ''){ 
        Swal.fire({
          title: "Email is empty",
          text: "Please fill the Email!",
          icon: "warning"
        }); return false;
      }

      let html = 'By clicking confirm, you agree to the <a id="terms" style="text-decoration: underline; cursor: pointer">terms</a> and <a id="cancellation_policy" style="text-decoration: underline; cursor: pointer">cancellation policy</a>.';
      Swal.fire({
        title: 'Please confirm your booking to proceed.',
        html: html,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#334960",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, Confirm!",
        cancelButtonText: 'No'
      }).then((result) => {
        if (result.isConfirmed) {
          //save booking and detail customer information
          $.ajax({
            url: BASEURL+"/cart/makepayment/",
            type: 'POST',
            data: {'data':data},
            beforeSend: function(){
              $('#form_cart :input').prop("disabled",true);
              HoldOn.open({
                theme:'sk-dot',
                message:"<h4>Proccessing Order..</h4>"
              });
            },
            success: function(r){
              HoldOn.close();
              // $('#form_cart :input').prop("disabled",true);
              //  console.log(r);
              let dt = JSON.parse(r);
              let url = dt.response.payment.url;
                console.log(url);
              // Extract only the unique identifier from the payment URL
              let urlParts = url.split('/');
              let paymentId = urlParts[urlParts.length - 1]; // Get the last segment of the URL
              // Redirect to the success page with the payment ID only
              location.href = BASEURL + "/order/success/" + paymentId;
            } 
          });
        }
      });
 }).on('click','#clearcart',function(e){
     // alert('o'); return false;
     Swal.fire({
       title: "Are you sure to clear your Cart?",
       text: "You will lost all item you already choose from the Shopping Cart!",
       icon: "warning",
       showCancelButton: true,
       confirmButtonColor: "#334960",
       cancelButtonColor: "#d33",
       confirmButtonText: "Yes, Clear it!"
     }).then((result) => {
       if (result.isConfirmed) {
         $.ajax({
             url: BASEURL+"/cart/clearcart/",
             type:'POST',
             success : function(r){
                 Swal.fire({
                   title: "Cart empty!",
                   text: "The booking has been removed from your cart.",
                   icon: "success"
                 }).then((result) => {
                     if (result.isConfirmed){
                         location.reload();
                     }
                 });
             }
         })
       }
     });
 }).on('click','#updatecart',function(e){
     e.preventDefault();
     let frm = $('#form_cart');
     let data = serializeFormJSON(frm);
     console.log(data); 
     $.ajax({
         url: BASEURL+"/cart/updatecart/",
         type:'POST',
         data: data,
         success : function(r){
          console.log(r);
             Swal.fire({
               title: "Update Cart!",
               text: "The items has been updated to your cart.",
               icon: "success"
             }).then((result) => {
                 if (result.isConfirmed){
                     location.reload();
                 }
             });
         }
     })
 }).on('click','.removeitem',function(e){
     e.preventDefault();
     let tis = $(this);
     let id = tis.data('id');
     Swal.fire({
       title: "Are you sure to remove this item from Cart?",
       text: "You will lost this item from the Shopping Cart!",
       icon: "warning",
       showCancelButton: true,
       confirmButtonColor: "#334960",
       cancelButtonColor: "#d33",
       confirmButtonText: "Yes, Remove it!"
     }).then((result) => {
       if (result.isConfirmed) {
         $.ajax({
             url: BASEURL+"/cart/removeitem/",
             data: {'id':id},
             type:'POST',
             success : function(r){
                 Swal.fire({
                   title: "Remove Item!",
                   text: "The item has been removed from your cart.",
                   icon: "success"
                 }).then((result) => {
                     if (result.isConfirmed){
                         location.reload();
                     }
                 });
             }
         })
       }
     });
    }).on('keyup change', '.qty', function(e) {
      e.preventDefault();
      
      let tis = $(this);
      let harga = parseFloat(tis.data('harga')) || 0;
      let qty = parseFloat(tis.val()) || 0;
      let selectedCurrency = sessionStorage.getItem("selectedCurrency") || "IDR";  
      let currencyRate = parseFloat(sessionStorage.getItem("currencyRate")) || 1;
  
      console.log("Harga:", harga, "Qty:", qty, "Currency:", selectedCurrency, "Rate:", currencyRate);
  
      // Konversi subtotal ke currency yang dipilih
      let sub_total = qty * harga * currencyRate;
      
      console.log(sub_total);
  
      // Update tampilan subtotal 
      tis.parent().parent().find('.sub_total').text(` ${sub_total}`);
  }).on('click', '#applyPromoButton', function(e) {
    e.preventDefault();

    let frm = $('#promotionForm');
    let data = serializeFormJSON(frm);

    console.log(data);

    $.ajax({
        url: BASEURL + "/cart/promotions/",
        data: data,
        type: 'POST',
        success: function(r) {
            let dt = JSON.parse(r);
            console.log('dt',dt);

            if (dt.status === 'danger') {
                Swal.fire({
                    title: "Failed!",
                    text: dt.text,
                    icon: "error"
                });
                return;
            }


            // Ambil currency yang dipilih dan rate dari sessionStorage
            let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
            let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;

            let base_total = dt.grand_total;
            let outputTarget = "#grandTotal";

            let base_discount = dt.discount;
            let base_newTotal = base_total - base_discount;
            // console.log(dt.discount)

            // Konversi nilai ke mata uang user
            let convertedTotal = base_total * currencyRate;
            let convertedDiscount = base_discount * currencyRate;
            let convertedNewTotal = base_newTotal * currencyRate;

            // Format angka
            let formattedTotal = formatCurrency(convertedTotal,selectedCurrency);
            let formattedDiscount = formatCurrency(convertedDiscount,selectedCurrency);
            let formattedNewTotal = formatCurrency(convertedNewTotal,selectedCurrency);

            // Update tampilan Discount
            let discountText = '<hr style="color: black; width:95%;"><div style="margin-bottom:2rem; margin-top:10px">';

dt.detailed_discounts.forEach(function(dd) {
    let convertedItemDiscount = dd.discount * currencyRate;
    let formattedItemDiscount = formatCurrency(convertedItemDiscount, selectedCurrency);

    console.log(convertedItemDiscount)

    discountText += `
      <li class="d-flex justify-content-between align-items-center pt-3">
        <div>
            <span class="poppins-semibold mb-0">${dd.product_name}<br>Discount${dt.promo_type === "percentage" ? ` (${dt.promo_value}%)` : ''}</span>
        </div>
        <span class="text-danger">
            - <span class="activecurrency">${selectedCurrency}</span>
            <span class="valuecurrency" data-baseprice="${dd.discount}">${formattedItemDiscount}</span>
        </span>
      </li>
    `;
});

discountText += '</div>';



            $("#discount").html(discountText).show();

            // Update tampilan Total (dengan strikethrough di subtotal)
            $(outputTarget).html(`
              <del class="text-danger poppins-semibold h6 ml-2">
                  <span class="activecurrency">${selectedCurrency}</span>
                  <span class="valuecurrency" data-baseprice="${base_total}">${formattedTotal}</span>
              </del>
              <br>
              <span class="activecurrency poppins-semibold">${selectedCurrency}</span>
              <span class="valuecurrency poppins-semibold" data-baseprice="${base_newTotal}">${formattedNewTotal}</span>
          `);

            // Update hidden input total
            $('#data_total').html(`
                <input type="hidden" name="new_total" value="${base_newTotal}" />
            `);
        }
    });
}).on('click', '#deleteaddon', function(e){
    const id = $(this).data('addon-id');

    Swal.fire({
      title: "Are you sure to remove this Add-on from Cart?",
      text: "You will lost this add-on from the Shopping Cart!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#334960",
      cancelButtonColor: "#d33",
      confirmButtonText: "Yes, Remove it!"
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
            url: BASEURL+"/cart/deleteaddon/",
            data: {'id':id},
            type:'POST',
            success : function(r){
                Swal.fire({
                  title: "Remove add-on!",
                  text: "The add-on has been removed from your cart.",
                  icon: "success"
                }).then((result) => {
                    if (result.isConfirmed){
                        location.reload();
                    }
                });
            }
        })
      }
    });
})
// .on('click', '#addExtras', function () {
//   const raw = $(this).data('addextras');

//   if (!raw || raw.length === 0) {
//     Swal.fire({
//       icon: 'info',
//       title: 'No extras available',
//       text: 'No extras available',
//       confirmButtonText: 'Close',
//       customClass: {
//         popup: 'rounded-xl shadow-md',
//         confirmButton: 'custom-confirm-button',
//       }
//     });
//     return;
//   }

//   let formHtml = `
//   <form id="extrasForm" style="padding: 20px; font-family: 'Inter', sans-serif;">
//     <div style="
//       display: grid; 
//       grid-template-columns: 2fr 3fr 1fr 2fr; 
//       gap: 16px; 
//       font-weight: 600; 
//       font-size: 14px; 
//       border-bottom: 1px solid #eee; 
//       padding-bottom: 12px; 
//       margin-bottom: 20px; 
//       color: #222;">
//       <div>Name</div>
//       <div>Description</div>
//       <div style="text-align:center;">Price</div>
//       <div style="text-align:center;">Quantity</div>
//     </div>

//     <div class="extras-scroll-container">
// `;

// raw.forEach(function (extra, index) {
//   formHtml += `
//     <div class="extra-row" style="
//       display: grid;
//       grid-template-columns: 2fr 3fr 1fr 2fr;
//       align-items: center;
//       gap: 16px;
//       font-size: 13px;
//       padding: 14px 0;
//       border-bottom: 1px solid #f0f0f0;
//       color: #444;
//       transition: all 0.2s ease;
//     ">
//       <div>${extra.nama}</div>
//       <div style="font-size: 12px; color: #777;">${extra.keterangan || '-'}</div>
//       <div style="text-align: center; font-weight: 500;">Rp${parseInt(extra.harga).toLocaleString('id-ID')}</div>
//       <div style="display: flex; justify-content: center; align-items: center; gap: 8px;">
//         <button type="button" class="qty-btn minus" data-index="${index}">−</button>
//         <input type="number" class="extra-qty-input" min="0" value="0" name="qty[${index}]"
//           data-extra='${JSON.stringify(extra)}' readonly />
//         <button type="button" class="qty-btn plus" data-index="${index}">+</button>
//       </div>
//     </div>
//   `;
// });
// formHtml += `</div></form>`;



// Swal.fire({
//   title: '<span style="font-size:18px; font-weight:600; color:#111;">Choose Extras</span>',
//   html: formHtml,
//   showCancelButton: true,
//   confirmButtonText: 'Add Selected',
//   cancelButtonText: 'Cancel',
//   customClass: {
//     popup: 'extras-popup',
//     confirmButton: 'extras-confirm-btn',
//     cancelButton: 'extras-cancel-btn',
//   },
//   buttonsStyling: false,
//   width: '720px',
//   background: '#fff',
// }).then((result) => {
//     if (result.isConfirmed) {
//       const selectedExtras = [];

//       $('#extrasForm input[type="number"]').each(function () {
//         const qty = parseInt($(this).val());
//         const extra = $(this).data('extra');

//         if (qty > 0) {
//           selectedExtras.push({ ...extra, qty });
//         }
//       });

//       console.log('Selected extras:', selectedExtras);
//       // lanjut kirim ke server
//     }
//   });
// });

// // + dan - handler
// $(document).on('click', '.qty-btn.plus', function () {
//   const index = $(this).data('index');
//   const input = $(`input[name='qty[${index}]']`);
//   let current = parseInt(input.val()) || 0;
//   input.val(current + 1);
// });

// $(document).on('click', '.qty-btn.minus', function () {
//   const index = $(this).data('index');
//   const input = $(`input[name='qty[${index}]']`);
//   let current = parseInt(input.val()) || 0;
//   if (current > 0) input.val(current - 1);
// });

// .on('click', '#priceBreakdown', function () {
//   const raw = $(this).data('breakdown');
//   const subtotal = $(this).data('total');

//   if (!raw || raw.length === 0) {
//     Swal.fire({
//       icon: 'info',
//       title: 'Tidak ada data harga',
//       text: 'Tanggal dan harga tidak tersedia.',
//       confirmButtonText: 'Tutup',
//       customClass: {
//         popup: 'rounded-4 shadow-sm',
//       }
//     });
//     return;
//   }

//   const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//   const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

//   let html = `
//     <div style="font-family: 'Poppins', sans-serif; font-size: 16px; color: #333; text-align:left;">
//       <div style="margin-bottom: 14px; font-weight: 600; font-size: 18px;">Detail</div>
//       <div style="max-height: 380px; overflow-y: auto; display: flex; flex-direction: column; gap: 12px;">
//   `;

//   raw.forEach(item => {
//     const dateObj = new Date(item.date);
//     const dayName = dayNames[dateObj.getDay()];
//     const dateStr = `${dayName}, ${dateObj.getDate()} ${monthNames[dateObj.getMonth()]} ${dateObj.getFullYear()}`;

//     const price = item.price ?? 0;
//     const discount = item.discounted_price ?? price;
//     const isDiscount = discount < price;

//     const formattedPrice = new Intl.NumberFormat('id-ID').format(price);
//     const formattedDiscount = new Intl.NumberFormat('id-ID').format(discount);

//     const bgColor = isDiscount ? '#fff5f5' : '#f9f9f9';
//     const badge = isDiscount
//       ? `<span style="background:#e53935; color:#fff; font-size:12px; padding:4px 10px; border-radius:16px; display:inline-flex; align-items:center; gap:6px;">
//             🔥 <span>Diskon</span>
//          </span>`
//       : '';

//     html += `
//       <div style="
//         display:flex;
//         justify-content:space-between;
//         align-items:center;
//         background:${bgColor};
//         padding:14px 20px;
//         border-radius: 12px;
//         box-shadow: inset 0 0 0 1px #e4e4e4;
//       ">
//         <div>
//           <div style="font-weight: 500;">${dateStr}</div>
//           ${isDiscount ? `
//             <div style="font-size:13px; color:#999;">
//               <span style="text-decoration:line-through; margin-right:6px;">IDR ${formattedPrice}</span>
//               <span style="color:#e53935; font-weight:600;">IDR ${formattedDiscount}</span>
//             </div>
//           ` : `
//             <div style="font-size:13px; color:#333;">IDR ${formattedPrice}</div>
//           `}
//         </div>
//         ${badge}
//       </div>
//     `;
//   });

//   const formattedTotal = new Intl.NumberFormat('id-ID').format(subtotal);

//   html += `
//       </div>
//       <hr style="margin: 20px 0;">
//       <div style="
//         font-weight: 700;
//         font-size: 18px;
//         color: #222;
//         text-align: right;
//       ">🧾 Total: <span style="color:#000;">IDR ${formattedTotal}</span></div>
//     </div>
//   `;

//   Swal.fire({
//     title: '<span style="font-size: 22px; font-weight: 700; color:#222;">Price Breakdown</span>',
//     html: html,
//     showCloseButton: true,
//     showConfirmButton: false,
//     background: '#ffffff',
//     width: 580,
//     borderRadius : '15px',
//     padding: '2em',
//     customClass: {
//       popup: 'rounded-4 shadow-lg border-0',
//     }
//   });
// });

 
 
 $('.number').text(function () { 
     var str = $(this).html() + ''; 
     x = str.split('.'); 
     x1 = x[0]; x2 = x.length > 1 ? '.' + x[1] : ''; 
     var rgx = /(\d+)(\d{3})/; 
     while (rgx.test(x1)) { 
         x1 = x1.replace(rgx, '$1' + ',' + '$2'); 
     } 
     $(this).html(x1 + x2); 
 });

 var format = function(num){
    var str = num.toString().replace("", ""), parts = false, output = [], i = 1, formatted = null;
    if(str.indexOf(",") > 0) {
      parts = str.split(",");
      str = parts[0];
    }
    str = str.split("").reverse();
    for(var j = 0, len = str.length; j < len; j++) {
      if(str[j] != ".") {
        output.push(str[j]);
        if(i%3 == 0 && j < (len - 1)) {
          output.push(".");
        }
        i++;
      }
    }
    formatted = output.reverse().join("");
    return("" + formatted + ((parts) ? "." + parts[1].substr(0, 2) : ""));
  };

  document.getElementById('applyPromoLink').addEventListener('click', function () {
    const promoForm = document.getElementById('promoCodeForm');
    if (promoForm.classList.contains('show')) {
        promoForm.classList.remove('show');
        setTimeout(() => {
            promoForm.style.display = 'none';
        }, 300); 
    } else {
        promoForm.style.display = 'block';
        setTimeout(() => {
            promoForm.classList.add('show');
        }, 10); 
    }
});