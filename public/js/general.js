$(document).on('ready', function () {

let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
    $('.wishlist').each(function () {
        const productId = $(this).data('product-id');
        if (wishlist.includes(productId)) {
            $(this).removeClass('bi-heart').addClass('bi-heart-fill active');
        }
    });

  // initialization of HSDropdown component
  $.HSCore.components.HSDropdown.init($('[data-dropdown-target]'), {
    afterOpen: function(){
      $(this).find('input[type="search"]').focus();
    }
  });
  
  // initialization of carousel
  $.HSCore.components.HSCarousel.init('.js-carousel');

  // initialization of tabs
  $.HSCore.components.HSTabs.init('[role="tablist"]');

  // initialization of rating
  $.HSCore.components.HSRating.init($('.js-rating'), {
    spacing: 4
  });

  // initialization of counters
  var counters = $.HSCore.components.HSCounter.init('[class*="js-counter"]');

  // initialization of go to
  $.HSCore.components.HSGoTo.init('.js-go-to');
}).on('click', '#read-cookies', function(){
  $.ajax({
             url: BASEURL+"/cookies-policy/",
             type:'POST',
             success : function(r){
                 location.href = BASEURL+"/cookies-policy/";
             }
         })
}).on('click', '.wishlist', function () {
    const icon = $(this);
    const productId = icon.data('product-id');


    let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];

    if (wishlist.includes(productId)) {
      wishlist = wishlist.filter(id => id !== productId);
      icon.removeClass('bi-heart-fill active').addClass('bi-heart');
    } else {
      wishlist.push(productId);
      icon.removeClass('bi-heart').addClass('bi-heart-fill active');
    }

    $.get(BASEURL + '/account/ceksession', function (res) {
        if (res.loggedIn) {
            $.ajax({
                url: BASEURL + '/wishlist/savewishlist',
                type: 'POST',
                data: { 'wishlist': wishlist },
                error: function() {
                    Swal.fire({
                        title: "Oops!",
                        text: "Something went wrong while saving your wishlist.",
                        icon: "error"
                    });
                }
            });

            localStorage.removeItem('wishlist');

        } else {
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
        }

    });

});

document.addEventListener("DOMContentLoaded", function () {
    // Cek localStorage
    if (!localStorage.getItem("cookieAccepted")) {
      var notice = document.getElementById("cookieNotice");
      if (notice) notice.style.display = "block";
    }

    // Event listener tombol
    var btn = document.getElementById("acceptCookies");
    if (btn) {
      btn.addEventListener("click", function () {
        localStorage.setItem("cookieAccepted", "yes");
        var notice = document.getElementById("cookieNotice");
        if (notice) notice.style.display = "none";
      });
    }
  });

// Ambil mata uang yang disimpan dari sessionStorage
if (!sessionStorage.getItem('selectedCurrency')) {
  sessionStorage.setItem('selectedCurrency', 'IDR');
  sessionStorage.setItem('selectedCurrencyText', 'Indonesian Rupiah');
  sessionStorage.setItem('selectedCurrencyFlag', 'https://flagcdn.com/w40/id.png');
  sessionStorage.setItem('currencyRate', '1'); // Default rate IDR ke IDR = 1
}
let selectedCurrency = sessionStorage.getItem('selectedCurrency');
let selectedCurrencyText = sessionStorage.getItem('selectedCurrencyText');
let selectedCurrencyFlag = sessionStorage.getItem('selectedCurrencyFlag');
let currencyRate = parseFloat(sessionStorage.getItem('currencyRate'));

if (selectedCurrency && selectedCurrencyText && currencyRate && selectedCurrencyFlag) {
    // Update tampilan mata uang
    $(".activecurrency").text(selectedCurrency); 
    $(".activecurrencytext").text(selectedCurrencyText); 
    $(".activeflag").attr("src", selectedCurrencyFlag); // Perbaiki agar flag berubah

    $(".valuecurrency").each(function() {
        let baseValue = parseFloat($(this).data("baseprice")) || 0;
        let convertedValue = baseValue * currencyRate; // Hitung nilai konversi

        // Format angka 
        let formattedValue = formatCurrency(convertedValue);

        $(this).text(' ' + formattedValue); // Update nilai di elemen
    });

    updatePrices(currencyRate, selectedCurrency);
}

$('.changecurrency').click(function() {
    let tis = $(this);
    let curr = tis.data('curr');
    let curr_text = tis.data('currtext');
    let flag = tis.data('flag'); // Pastikan flag ada di atribut data

    $.ajax({
        url: BASEURL + '/index/changecurrency/',
        type: 'POST',
        data: { 'curr': curr, 'curr_text': curr_text },
        beforeSend() {
            HoldOn.open({
                theme: 'sk-dot',
                message: "<h4>Currency is changing to " + curr_text + "...</h4>"
            });
        },
        success: function(response) {
            HoldOn.close();
            let data = JSON.parse(response);
            if (data.rate) {
                // Simpan currency yang dipilih di sessionStorage
                sessionStorage.clear(); // Hapus cache session
                sessionStorage.setItem('selectedCurrency', curr);
                sessionStorage.setItem('selectedCurrencyText', curr_text);
                sessionStorage.setItem('selectedCurrencyFlag', flag); // Simpan flag dengan key yang benar
                sessionStorage.setItem('currencyRate', data.rate);

                // Update tampilan currency di semua elemen yang perlu diubah
                $(".activecurrency").text(curr);
                $(".activecurrencytext").text(curr_text);
                $(".activeflag").attr("src", flag); // Ubah gambar bendera sesuai currency

                $(".valuecurrency").each(function() {
                    let baseValue = parseFloat($(this).data("baseprice")) || 0;
                    let convertedValue = baseValue * data.rate;

                    let formattedValue = formatCurrency(convertedValue, curr);
                    $(this).text(' ' + formattedValue);
                });

                // Re-inisialisasi dropdown setelah perubahan currency
                setTimeout(function () {
                    reinitializeDropdown();
                }, 500);

                // Update total harga agar currency di accordion juga berubah
                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                updateTotalHarga(currencyRate, selectedCurrency);
                updateRatePrices();
                recalculateTotal();
            }
        }
    });
});



function reinitializeDropdown() {
    console.log("Reinitializing dropdown...");
    $.HSCore.components.HSDropdown.init($('[data-dropdown-target]'));
}

function formatCurrency(amount, currency) {
  let formats = {
      'AUD': { decimals: 2, locale: 'en-AU' },
      'CNY': { decimals: 2, locale: 'zh-CN' },
      'EUR': { decimals: 2, locale: 'de-DE' }, 
      'GBP': { decimals: 2, locale: 'en-GB' },
      'IDR': { decimals: 0, locale: 'id-ID' }, 
      'INR': { decimals: 2, locale: 'en-IN' }, 
      'JPY': { decimals: 0, locale: 'ja-JP' }, 
      'KRW': { decimals: 0, locale: 'ko-KR' }, 
      'NZD': { decimals: 2, locale: 'en-NZ' },
      'RUB': { decimals: 2, locale: 'ru-RU', useSpace: true }, 
      'SGD': { decimals: 2, locale: 'en-SG' },
      'USD': { decimals: 2, locale: 'en-US' }
  };

  let format = formats[currency] || { decimals: 2, locale: 'en-US' };

  let formattedAmount = new Intl.NumberFormat(format.locale, {
      minimumFractionDigits: format.decimals,
      maximumFractionDigits: format.decimals
  }).format(amount);

  // Khusus untuk Russian Ruble (₽), ganti pemisah ribuan dengan spasi
  if (format.useSpace) {
      formattedAmount = formattedAmount.replace(/\./g, ' ');
  }

  return formattedAmount;
}


function updatePrices(rate, currency) {
  $(".valuecurrency").each(function () {
      let baseValue = parseFloat($(this).data("baseprice")) || 0;
      let convertedAmount = baseValue * rate;

      let formatted = formatCurrency(convertedAmount, currency);
      $(this).text(' ' + formatted);
  });

  updateTotalHarga(rate, currency);
}

function updateTotalHarga(rate, currencySymbol) {
  let selectedCurrency = sessionStorage.getItem('selectedCurrency');
  let totalHargaElement = $(".total_harga");
  let baseTotal = parseFloat(totalHargaElement.attr("data-baseprice")) || 0; 
  let convertedTotal = baseTotal * rate;

  let formattedTotal = formatCurrency(convertedTotal,selectedCurrency);
console.log(formattedTotal);
  totalHargaElement.text(formattedTotal);
  totalHargaElement.closest("h3").html(currencySymbol + " <span class='total_harga' data-baseprice='"+baseTotal+"' style='font-weight:bold;'>" + formattedTotal + "</span>");
}

// function updateRatePrices() {
//   let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
//   let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;

//   $(".rate-price").each(function () {
//       let basePrice = parseFloat($(this).data("baseprice")) || 0;
//       let convertedPrice = basePrice * currencyRate;

//       let formattedPrice = formatCurrency(convertedPrice,selectedCurrency);

//       $(this).find(".activecurrency").text(selectedCurrency);
//       $(this).find(".converted-price").text(formattedPrice);
//   });
// }

function recalculateTotal() {
  let grand_total = 0;
  $('.qty').each(function() {
      let qty = parseInt($(this).val()) || 0;
      let harga = parseFloat($(this).data('harga')) || 0;
      let total_harga = qty * harga;
      $(this).parent().find('.sub_total').val(total_harga);
      grand_total += total_harga;
  });
  $(".total_harga").attr("data-baseprice", grand_total);
  let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
  let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
  updateTotalHarga(currencyRate, selectedCurrency);
}



$(window).on('load', function () {
  // initialization of header
  $.HSCore.components.HSHeader.init($('#js-header'));
  $.HSCore.helpers.HSHamburgers.init('.hamburger');

  // initialization of HSMegaMenu component
  $('.js-mega-menu').HSMegaMenu({
    event: 'hover',
    pageContainer: $('.container'),
    breakpoint: 991
  });

  // initialization of horizontal progress bars
  setTimeout(function () { // important in this case
    var horizontalProgressBars = $.HSCore.components.HSProgressBar.init('.js-hr-progress-bar', {
      direction: 'horizontal',
      indicatorSelector: '.js-hr-progress-bar-indicator'
    });
  }, 1);
});

$(window).on('resize', function () {
  setTimeout(function () {
    $.HSCore.components.HSTabs.init('[role="tablist"]');
  }, 200);
});

function filePreview(input,show_layer,width,height,status=null) {
    var l = input.files.length;
    for(i=0; i<l; i++){
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            console.log(e);
            if(status == 3){
                $(show_layer).prepend('<img src="'+e.target.result+'" width="'+width+'" height="'+height+'" style="margin : 0 1px" />');
            }else{
                $(show_layer).html('<img src="'+e.target.result+'" width="'+width+'" height="'+height+'" style="margin : 0 1px" />');
            }
        }
        reader.readAsDataURL(input.files[0]);
    }}
}

function serializeFormJSON(frm){
    var o = {};
    var a = frm.serializeArray();
    $.each(a, function () {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

function triggerSound(m){
    if(m=="alert"){
        document.getElementById("myNotifAlert").play();
    }else if(m=="success"){
        document.getElementById("myNotifSuccess").play();
    }
}

// Fungsi untuk menghasilkan slug yang bersih
var slug = function(str) {
  str = str.replace(/^\s+|\s+$/g, ''); // Trim leading and trailing whitespace
  str = str.toLowerCase();              // Convert to lowercase

  // Remove accents and special characters
  var from = "ãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;";
  var to   = "aaaaaeeeeeiiiiooooouuuunc------";
  for (var i = 0, l = from.length; i < l; i++) {
    str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
  }

  // Remove invalid characters and replace whitespaces and multiple dashes
  str = str
    .replace(/[^a-z0-9\s-]/g, '') // Remove invalid characters but keep spaces and dashes
    .replace(/\s+/g, '-')         // Replace spaces with dashes
    .replace(/-+/g, '-')          // Collapse multiple dashes into a single dash
    .replace(/^-+|-+$/g, '');     // Remove leading and trailing dashes

  return str;
};




number_format = function (number, decimals, dec_point, thousands_sep) {
    number = number.toFixed(decimals);

    var nstr = number.toString();
    nstr += '';
    x = nstr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? dec_point + x[1] : '';
    var rgx = /(\d+)(\d{3})/;

    while (rgx.test(x1))
        x1 = x1.replace(rgx, '$1' + thousands_sep + '$2');

    return x1 + x2;
}
