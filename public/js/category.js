let currentRatingFilter = [];
let currentPage = 1;
let currentViewMode = 'grid'; 

function loadFilteredProducts(selectedRatings = [], page = 1) {
  const caturl = $('.rating-filter').data('caturl');
  currentPage = page;

  $.ajax({
    url: BASEURL + '/category/' + caturl + '/rating/' + page,
    method: 'POST',
    data: { ratings: selectedRatings },
    beforeSend: function(){
        HoldOn.open({
        theme:'sk-dot',
        message:"<h4>Please Wait..</h4>"
      });
    },
    success: function(response) {
      HoldOn.close();
      let html = '';

if (currentViewMode === 'grid') {
  html = renderGridHTML(response.products, response.hotdeals, response.reviewStats, response.wishlistProductIds);
  $('.view-style-grid.product-container').html(html);
  $('.view-style-list.product-container').html('');
} else {
  html = renderListHTML(response.products, response.hotdeals, response.reviewStats, response.wishlistProductIds);
  $('.view-style-list.product-container').html(html);
  $('.view-style-grid.product-container').html('');
}


      if(response.totalPages > 1){
        $('#pagination-container').addClass('d-flex').removeClass('d-none');
      } else {
        $('#pagination-container').addClass('d-none').removeClass('d-flex');
      }

      


      initSwiper();
      // initLightbox();
      updateCurrency();

      renderPagination(response.totalPages, response.currentPage);
    }
  });
}

function renderGridHTML(products, hotdeals, reviewStats, wishlistProductIds) {
  let html = '';
  if (!products || products.length === 0) {
    html += `
      <div class="d-flex justify-content-center my-5">
          <img src="${BASEURL}/img/no-data2.png" style="width: 40%;">
      </div>
    `;
    return html;
  }

  products.forEach(p => {
    const hotdeal = hotdeals[p.id] || {};
    const stats = reviewStats[p.id] || {};
    const rating = Math.round(stats.average_rating || 0);
    const total = stats.total_review || 0;

    html += `
      <div class="col-sm-12 col-md-6 col-lg-4 d-flex justify-content-center">
        <div class="card card-fixed shadow rounded-4 position-relative">
          <figure>
            <div class="swiper-container" data-product-id="${p.id}">
              <div class="swiper-wrapper">
                ${(p.pictures || []).map(pic => `
                  <div class="swiper-slide">
                    <a href="${PIXURL}/uploads/products/${p.id}/${pic}" data-fancybox="gallery">
                      <img src="${PIXURL}/uploads/products/${p.id}/${pic}" alt="${p.name}">
                    </a>
                  </div>
                `).join('')}
              </div>
              <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
              <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
            </div>
            <div class="d-flex justify-content-between">
              <figcaption class="label-top poppins-medium" style="transform: translateY(-590%); z-index: 1;">${p.group}</figcaption>
              <div class="heart-icon">`;
                  if (wishlistProductIds.includes(p.id)) {
                    html += `<i class="bi bi-heart-fill wishlist active" data-product-id="${p.id}" style="cursor:pointer;"></i>`;
                  } else {
                    html += `<i class="bi bi-heart wishlist" data-product-id="${p.id}" style="cursor:pointer;"></i>`;
                  }
                html += `</div>
            </div>
          </figure>
          <div class="card-body d-flex flex-column justify-content-between" style="height: 150px;">
            <div class="card-top">
              <a class="h4 poppins-semibold card-title truncate-text" href="${BASEURL}/${p.id}/${p.slug}/">${p.name}</a>
              <div class="text-muted pt-1" style="font-size: 14px;">
              ${stats.is_provider ? `
                <div class="provider-rating g-color-black mb-2">
                  <i class="bi bi-shop"></i>
                  <span>Provider Rating</span>
                </div>
              ` : ''}
              ${typeof stats.average_rating !== 'undefined' ? `
                <div class="d-flex align-items-center" style="gap: 3px;">
                  <div class="d-flex align-items-center" style="gap: 8px;">
                    <i class="bi bi-star-fill text-warning"></i>
                    ${stats.average_rating} / 5 (${stats.total_review})
                  </div>
                  ${(p.ordered > 0) ? `
                    <span>・</span>
                    <span>${formatShortNumber(p.ordered)} booked</span>
                  ` : ''}
                </div>
              ` : `
                <div class="new-product g-color-black mb-2">
                  <i class="bi bi-tag"></i>
                  <span>New Product</span>
                </div>
              `}
              </div>
            </div>
            <div>
            ${ hotdeal.min_publish_price > 0 ? `
              <span class="start-from poopins-medium">Start from</span><br>
              ${hotdeal.discounted_price > 0 ? `
                <span class="g-font-weight-600 original-price" style="color: red;font-size: 11pt;">
                  <s><span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.rate_option_price}"></span></s>
                </span><br>
                <span class="g-color-gold g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                  <span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.discounted_price}"></span>
                </span>
              ` : `
                <span class="g-color-gold g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                  <span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.min_publish_price ?? 0}"></span>
                </span>
              `}
              ` : `
              <h6 style="color: red;">Not Available</h6>
              <p>Currently it is not possible to book this product due to its limited availability.</p>
              `}
              <div class="see-details">
                <a href="${BASEURL}/${p.id}/${p.slug}/" style="color: #555; text-decoration-line: none;">
                  <div class="d-flex justify-content-end align-items-center hover-move py-1">
                    <span>See details</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                      <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                    </svg>
                  </div>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  });
  return html;
}

function renderListHTML(products, hotdeals, reviewStats, wishlistProductIds) {
  let html = '';
  if (!products || products.length === 0) {
    html += `
      <div class="d-flex justify-content-center my-5">
          <img src="${BASEURL}/img/no-data2.png" style="width: 40%;">
      </div>
    `;
    return html;
  }
  products.forEach(p => {
    const hotdeal = hotdeals[p.id] || {};
    const stats = reviewStats[p.id] || {};
    const rating = Math.round(stats.average_rating || 0);
    const total = stats.total_review || 0;

    html += `
      <div class="row card d-flex flex-row shadow mobile-card" style="margin-bottom: 1rem;">
        <figure class="col-4">
          <div class="swiper-container" data-product-id="${p.id}">
            <div class="swiper-wrapper">
              ${(p.pictures || []).map(pic => `
                <div class="swiper-slide">
                  <a href="${PIXURL}/uploads/products/${p.id}/${pic}" data-fancybox="gallery-${p.id}">
                    <img src="${PIXURL}/uploads/products/${p.id}/${pic}" alt="${p.name}">
                  </a>
                </div>
              `).join('')}
            </div>
            <div class="swiper-button-next" style="color:white; width: 50px; height: 0px;"></div>
            <div class="swiper-button-prev" style="color:white; width: 50px; height: 0px;"></div>
          </div>
        </figure>
        <div class="col-5" style="border-right: 2px dashed #ccc;">
          <div class="card-top">
            <figcaption class="category poppins-medium mb-3">${p.group}</figcaption>
            <div class="heart-icon">`;
            if (wishlistProductIds.includes(p.id)) {
              html += `<i class="bi bi-heart-fill wishlist active" data-product-id="${p.id}" style="cursor:pointer;"></i>`;
            } else {
              html += `<i class="bi bi-heart wishlist" data-product-id="${p.id}" style="cursor:pointer;"></i>`;
            }

            html+=`</div><a class="h5 poppins-semibold g-color-black card-title truncate-text" href="${BASEURL}/${p.id}/${p.slug}/">${p.name}</a>
            <div class="text-muted d-flex flex-column pt-1" style="font-size: 14px; gap: 3px;">
              ${stats.is_provider ? `
                <div class="provider-rating g-color-black mb-2">
                  <i class="bi bi-shop"></i>
                  <span>Provider Rating</span>
                </div>
              ` : ''}
              ${typeof stats.average_rating !== 'undefined' ? `
              <div class="d-flex align-items-center" style="gap: 3px;">
                <div class="d-flex align-items-center" style="gap: 8px;">
                  <i class="bi bi-star-fill text-warning"></i>
                  ${stats.average_rating} / 5
                </div>
                ${(p.ordered > 0) ? `
                    <span>・</span>
                    <span>${formatShortNumber(p.ordered)} booked</span>
                  ` : ''}
              </div>
              ` : `<div class="new-product g-color-black mb-2">
                    <i class="bi bi-tag"></i>
                    <span>New Product</span>
                  </div>`}
              <div class="mt-3"><p>${p.title}..</p></div>
            </div>

          </div>
        </div>
        <div class="col-3" style="margin-top: auto;">
        ${hotdeal.min_publish_price > 0 ? `
          <div class="price" style="margin-right: auto;">
            <span class="start-from poopins-medium">Start from</span><br>
            ${hotdeal.discounted_price > 0 ? `
              <span class="g-font-weight-600 original-price" style="color: red;font-size: 11pt;">
                <s><span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.rate_option_price}"></span></s>
              </span><br>
              <span class="g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                <span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.discounted_price}"></span>
              </span>
            ` : `
              <span class="g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                <span class="activecurrency"></span><span class="valuecurrency" data-baseprice="${hotdeal.min_publish_price ?? 0}"></span>
              </span>
            `}
          </div>
          ` : `
              <h6 style="color: red;">Not Available</h6>
              <p>Currently it is not possible to book this product due to its limited availability.</p>
          `}
          
          <div class="see-details mt-3">
            <a href="${BASEURL}/${p.id}/${p.slug}/" style="text-decoration-line: none;">
              <div class="d-flex justify-content-center align-items-center hover-move py-1" style="cursor: pointer; padding-bottom: .5rem;">
                <span>See details</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                  <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                </svg>
              </div>
            </a>
          </div>
        </div>
      </div>
    `;
  });
  return html;
}

function renderPagination(totalPages, currentPage) {
  if (!currentPage || isNaN(currentPage)) currentPage = 1;
  let paginationHtml = '';

  // Tombol Prev (selalu ada)
  paginationHtml += `
    <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto ${currentPage === 1 ? 'disabled' : ''}">
      <a href="#" class="pagination-link" data-page="${Math.max(1, currentPage - 1)}"
        style="text-decoration: none; color: inherit; pointer-events: ${currentPage === 1 ? 'none' : 'auto'};">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor"
          stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
          <path fill-rule="evenodd"
            d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0" />
        </svg>
        <span>Prev</span>
      </a>
    </li>`;

  // Nomor halaman (dengan ... jika perlu)
  for (let i = 1; i <= totalPages; i++) {
    if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
      paginationHtml += `
        <li class="numb">
          <a href="#" class="pagination-link" data-page="${i}" style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;"><span>${i}</span></a>
        </li>
      `;
    } else if (i === currentPage - 2 || i === currentPage + 2) {
      paginationHtml += `<li class="dots"><span>...</span></li>`;
    }
  }

  // Tombol Next (selalu ada)
  paginationHtml += `
    <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto ${currentPage === totalPages ? 'disabled' : ''}">
      <a href="#" class="pagination-link" data-page="${Math.min(totalPages, currentPage + 1)}"
        style="text-decoration: none; color: inherit; pointer-events: ${currentPage === totalPages ? 'none' : 'auto'};">
        <span>Next</span>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor"
          stroke-width="1.5" class="bi bi-chevron-right" viewBox="0 0 16 16">
          <path fill-rule="evenodd"
            d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708" />
        </svg>
      </a>
    </li>`;

  $('#pagination-container').html(`<ul>${paginationHtml}</ul>`);
}

function formatShortNumber(num) {
  if (num >= 1000) {
    return (num % 1000 === 0)
      ? (num / 1000) + 'k'
      : (num / 1000).toFixed(1).replace('.0', '') + 'k';
  }
  return num;
}




// function initLightbox() {
//   const productElements = document.querySelectorAll('.swiper-container');
//   productElements.forEach(element => {
//     const productId = element.getAttribute('data-product-id');
//     GLightbox({
//       selector: `[data-glightbox="gallery-${productId}"]`,
//       loop: false,
//       closeOnOutsideClick: true,
//       touchNavigation: true,
//       autoplayVideos: true
//     });
//   });
// }

function initSwiper(){
    new Swiper('.swiper-container', {
    loop: false,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
  });
}

function updateCurrency() {
  if (!sessionStorage.getItem('selectedCurrency')) {
    sessionStorage.setItem('selectedCurrency', 'IDR');
    sessionStorage.setItem('selectedCurrencyText', 'Indonesian Rupiah');
    sessionStorage.setItem('selectedCurrencyFlag', 'https://flagcdn.com/w40/id.png');
    sessionStorage.setItem('currencyRate', '1');
  }

  let selectedCurrency = sessionStorage.getItem('selectedCurrency');
  let selectedCurrencyText = sessionStorage.getItem('selectedCurrencyText');
  let selectedCurrencyFlag = sessionStorage.getItem('selectedCurrencyFlag');
  let currencyRate = parseFloat(sessionStorage.getItem('currencyRate'));

  if (selectedCurrency && selectedCurrencyText && currencyRate && selectedCurrencyFlag) {
    $(".activecurrency").text(selectedCurrency); 
    $(".activecurrencytext").text(selectedCurrencyText); 
    $(".activeflag").attr("src", selectedCurrencyFlag);
    $(".valuecurrency").each(function() {
      let baseValue = parseFloat($(this).data("baseprice")) || 0;
      let convertedValue = baseValue * currencyRate;
      let formattedValue = formatCurrency(convertedValue);
      $(this).text(' ' + formattedValue);
    });
    updatePrices(currencyRate, selectedCurrency);
  }
}

$(document).on('ready', function () {

  // optionally load page 1 on load
}).on('change', '.rating-filter', function () {
  let selectedRatings = [];
  $('.rating-filter:checked').each(function () {
    selectedRatings.push($(this).val());
  });

  currentRatingFilter = selectedRatings;
  syncMobileCheckbox(currentRatingFilter);
  loadFilteredProducts(currentRatingFilter, 1);
}).on('click', '.pagination-link', function(e){
  e.preventDefault();
  const page = $(this).data('page');
  loadFilteredProducts(currentRatingFilter, page);
}).on('click', '#btn-search-category', function(e) {
    e.preventDefault();
  
    let frm = $('#search_form');
    let data = serializeFormJSON(frm);
    console.log(data)
    if(data.areas == ''){ 
            Swal.fire({
            title: "Oops!",
            text: "Please fill place & activities!",
            icon: "warning"
            }); return false;
        }
    let originalValue = $('input[type="text"]#search').val();
    let caturl = $('input[type="hidden"]#category_url').val();
    const sluggedUrl = slug(originalValue);
    const encodedUrl = encodeURI(sluggedUrl);  
    location.href = BASEURL + '/category/'+caturl+'/search/'+encodedUrl+'/';

}).on('click', '#gridView', function () {
  $('#gridView').addClass('active');
  $('#listView').removeClass('active');
  $('.view-style-grid').removeClass('d-none');
  $('.view-style-list').addClass('d-none');
  currentViewMode = 'grid';
  loadFilteredProducts(currentRatingFilter, currentPage); // reload ulang sesuai view
}).on('click', '#listView', function () {
  $('#listView').addClass('active');
  $('#gridView').removeClass('active');
  $('.view-style-list').removeClass('d-none');
  $('.view-style-grid').addClass('d-none');
  currentViewMode = 'list';
  loadFilteredProducts(currentRatingFilter, currentPage);
}).on('click', '.button-save', function () {
  let selectedMobileRatings = [];
  $('#exampleModal2 input[name="accommodation[]"]:checked').each(function () {
    selectedMobileRatings.push($(this).val());
  });

  currentRatingFilter = selectedMobileRatings;

  // Sync ke desktop
  syncDesktopCheckbox(currentRatingFilter);

  // Tutup modal
  $('#exampleModal2').modal('hide');

  // Panggil fungsi asli
  loadFilteredProducts(currentRatingFilter, 1);
}).on('click', '.reset-save', function () {

  $('#exampleModal2 input[name="accommodation[]"]').prop('checked', false);
  $('.rating-filter').prop('checked', false);

  currentRatingFilter = [];

  loadFilteredProducts([], 1);
});

function syncMobileCheckbox(selectedRatings = []) {
  $('#exampleModal2 input[name="accommodation[]"]').each(function () {
    $(this).prop('checked', selectedRatings.includes($(this).val()));
  });
}

function syncDesktopCheckbox(selectedRatings = []) {
  $('.rating-filter').each(function () {
    $(this).prop('checked', selectedRatings.includes($(this).val()));
  });
}

$('#exampleModal2').on('show.bs.modal', function () {
  syncMobileCheckbox(currentRatingFilter);
});

Fancybox.bind("[data-fancybox]", {
  type: "image",
  animated: true,
  dragToClose: true,
});

Fancybox.bind("[data-fancybox='images']", {
  type: "image",
  animated: true,
  dragToClose: true,
});
