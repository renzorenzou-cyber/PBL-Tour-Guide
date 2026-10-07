$(document).ready(function() {

  // change areas
$('.changeareas').click(function(){
  let tis = $(this);
  let area = tis.data('areas');
  let decoded_area = area.replace(/-/g, ' ');
  // console.log(area)

  $.ajax({
        url: BASEURL + '/index/changeareas/',
        type: 'POST',
        data: { 'area': area },
        beforeSend() {
            HoldOn.open({
                theme: 'sk-dot',
                message: "<h4>areas is changing to " + decoded_area + "...</h4>"
            });
        },
        success: function(response) {
          let data = JSON.parse(response);
          console.log(data)
          sessionStorage.setItem('selectedAreas', data.area);

          $("#selectedAreas").text(data.display_area);
          HoldOn.close();
          location.href = BASEURL+"/area/"+data.area+"/";
        }
    });
})
    
    // Event listener untuk 'keypress' pada elemen dengan id 'search'
    // initialization of carousel
    $.HSCore.components.HSCarousel.init('[class*="js-carousel"]');

    $('#carouselCus1').slick('setOption', 'responsive', [{
      breakpoint: 1200,
      settings: {
        slidesToShow: 4
      }
    }, {
      breakpoint: 992,
      settings: {
        slidesToShow: 3
      }
    }, {
      breakpoint: 768,
      settings: {
        slidesToShow: 2
      }
    }], true);

    $('#carouselCus2').slick('setOption', 'responsive', [{
      breakpoint: 1200,
      settings: {
        slidesToShow: 3
      }
    }, {
      breakpoint: 992,
      settings: {
        slidesToShow: 2
      }
    }, {
      breakpoint: 768,
      settings: {
        slidesToShow: 1
      }
    }, {
      breakpoint: 480,
      settings: {
        slidesToShow: 1
      }
    }], true);
});$('button[type="button"]#btn-search-top').on('click', function(e) {
  e.preventDefault();

  let originalValue = $('input[type="text"]#search-top').val();

  const sluggedUrl = slug(originalValue);
  const encodedUrl = encodeURI(sluggedUrl);

  location.href = BASEURL + '/search/' + encodedUrl + '/';
});$('input[type="text"]#search-top').on('keypress', function(e) {
  if (e.which === 13) { // Jika tombol Enter ditekan
    e.preventDefault(); // Mencegah aksi default (misalnya, pengiriman formulir)

    let tis = $(this);
    const originalValue = tis.val(); // Mengambil nilai input asli
    
    // Menghasilkan slug dari input untuk URL
    const sluggedUrl = slug(originalValue);
    
    // Encode slug untuk URL
    const encodedUrl = encodeURI(sluggedUrl);
    console.log(sluggedUrl);
    console.log(encodedUrl);
    // Mengarahkan ke URL yang telah dibersihkan
    location.href = BASEURL + '/search/' + encodedUrl + '/';
}
}).on('keypress', '#btn-search', function(){
    if (e.which === 13) { // Jika tombol Enter ditekan
        e.preventDefault();
  
        let frm = $('#search_form');
        let data = serializeFormJSON(frm);

        if(data.search == ''){ 
                Swal.fire({
                title: "Oops!",
                text: "Please fill place & activities!",
                icon: "warning"
                }); return false;
            }
        let originalValue = $('input[type="text"]#search').val();
        const sluggedUrl = slug(originalValue);
        const encodedUrl = encodeURI(sluggedUrl);  
        location.href = BASEURL + '/search/' + encodedUrl + '/';
    }
})


// initialization of header
      $.HSCore.components.HSHeader.init($('#js-header'));
      $.HSCore.helpers.HSHamburgers.init('.hamburger');

      // initialization of HSMegaMenu component
      $('.js-mega-menu').HSMegaMenu({
        event: 'hover',
        pageContainer: $('.container'),
        breakpoint: 991
      });

      // initialization of HSDropdown component
      $.HSCore.components.HSDropdown.init($('[data-dropdown-target]'), {
        afterOpen: function () {
          $(this).find('input[type="search"]').focus();
        }
      });

      // initialization of go to
      $.HSCore.components.HSGoTo.init('.js-go-to');

      // initialization of quantity counter
      // $.HSCore.components.HSCountQty.init('.js-quantity');

      // initialization of countdowns
      // var countdowns = $.HSCore.components.HSCountdown.init('.js-countdown', {
      //   yearsElSelector: '.js-cd-years',
      //   monthElSelector: '.js-cd-month',
      //   daysElSelector: '.js-cd-days',
      //   hoursElSelector: '.js-cd-hours',
      //   minutesElSelector: '.js-cd-minutes',
      //   secondsElSelector: '.js-cd-seconds'
      // });

      $(window).on('load', function() {
        // initialization of HSScrollBar component
        $.HSCore.components.HSScrollBar.init($('.js-scrollbar'));
      });

      document.addEventListener("DOMContentLoaded", function() {
        const productElements = document.querySelectorAll('.swiper-container');

            Fancybox.bind("[data-fancybox]", {
              type: "image",
              animated: true,
              dragToClose: true,
            });
    
        // productElements.forEach(element => {
        //   const productId = element.getAttribute('data-product-id');
    
        //   const lightbox = GLightbox({
        //     selector: `[data-glightbox="gallery-${productId}"]`, 
        //     videoAutoplay: true, 
        //     loop: false,  
        //     closeOnOutsideClick: true,  // Menutup ketika klik di luar modal
        //   });
    
        // });
      });

    
     
        

      document.addEventListener("DOMContentLoaded", function() {
        var swiper = new Swiper('.swiper-container', {
          loop: false, // Agar slider bisa berputar tanpa henti
          navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
          },
          pagination: {
            el: '.swiper-pagination',
            clickable: true,
          },

        });
      });

      
      
        