let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];

function setPendingWishlist(value) {
    if (value) {
        localStorage.setItem('pendingWishlistSave', 'true');
    } else {
        localStorage.removeItem('pendingWishlistSave');
    }
}

function checkAndSavePendingWishlist() {
    if (localStorage.getItem('pendingWishlistSave') === 'true') {
        setPendingWishlist(false); 
        confirmAndSaveWishlist();
    }
}

$(document).ready(function(){
    checkAndSavePendingWishlist();
}).on('click', '#save-wishlist', function(){
    wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
    
    $.get(BASEURL + '/account/ceksession', function (res) {
        if (!res.loggedIn) {
            pendingWishlistSave = true; 
            Swal.fire({
            title: '',
            html: '', 
            showCloseButton: false,
            width: '700px',
            showConfirmButton: false,
            didOpen: () => {
                const popup = Swal.getHtmlContainer();
                popup.appendChild(document.querySelector('#popup-content form'));
                popup.querySelector('form').style.display = 'block';
            },
            willClose: () => {
                document.querySelector('#popup-content').appendChild(document.querySelector('#form_signin'));
                document.querySelector('#form_signin').style.display = 'none';
            }
        });
            return;
        }

        confirmAndSaveWishlist();
    });

}).on('click','#signin', function(e){
    e.preventDefault();
    let frm = $('#form_signin');
    let data = serializeFormJSON(frm);

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

            if (dt.status == 'success') {
                Swal.fire({
                    title: "Login successfully!",
                    text: "Welcome To Tropialis",
                    icon: "success"
                }).then(() => {
                    if (pendingWishlistSave) {
                        pendingWishlistSave = false;
                        confirmAndSaveWishlist();
                    }
                });
            } else if (dt.status == 'danger') {
                Swal.showValidationMessage(dt.text || "User not found");
            } else if(dt.status == 'warning'){
                Swal.showValidationMessage(dt.text || "Account has not been activated");
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
}).on('change', '#terms-popup', function () {
    if ($(this).is(':checked')) {
        // Simpan isi popup pertama
        let firstPopupContent = document.querySelector('.swal2-html-container').innerHTML;

        Swal.fire({
            title: "Terms and Conditions",
            text: "Welcome to Tropialis! By signing up and using our services, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.",
            icon: "warning",
            confirmButtonText: "I Agree"
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    html: firstPopupContent,
                    showConfirmButton: false,
                    width: '700px'
                });
                $('#signup').prop('disabled', false);
            } else {
                $(this).prop('checked', false);
                $('#signup').prop('disabled', true);
                // Balikin popup pertama lagi
                Swal.fire({
                    html: firstPopupContent,
                    showConfirmButton: false,
                    width: '700px'
                });
            }
        });
    } else {
        $('#signup').prop('disabled', true);
    }
}).on('click', '#login-google', function() {
    localStorage.setItem('pendingWishlistSave', 'true');
});

// load wishlist item
document.addEventListener('DOMContentLoaded', function () {
    let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
    let currentPage = 1;

    function loadWishlist(page = 1) {
        if (wishlist.length === 0) {
            $('#wishlist-container').html(`
                <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
                    <h5 class="text-danger">💔 You haven’t added anything to your wishlist yet.</h5>
                </div>
                <div class="text-center mb-5" style="padding-left:270px;">
                    <a href="${BASEURL}" class="btn btn-success btn-lg">
                        <i class="bi bi-search"></i> Browse products and tap the heart icon to save your favorites.
                    </a>
                </div>
            `);
            $('#wishlist-pagination').html('');
            return;
        }

        $.ajax({
            url: `${BASEURL}/wishlist/${page}`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ wishlist_ids: wishlist }),
            success: function (res) {
                if (!res.wishlist || res.wishlist.length === 0) {
                    $('#wishlist-container').html(`
                        <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
                            <h5 class="text-danger">💔 You haven’t added anything to your wishlist yet.</h5>
                        </div>
                        <div class="text-center mb-5">
                            <a href="${BASEURL}" class="btn btn-success btn-lg">
                                <i class="bi bi-search"></i> Browse products and tap the heart icon to save your favorites.
                            </a>
                        </div>
                    `);
                    $('#wishlist-pagination').html('');
                    return;
                }

                $('#save-wishlist-btn').html(`
                    <div class="row">
                        <div class="col-12" style="padding-left:1020px;">
                            <a id="save-wishlist"
                            class="btn w-100 d-flex align-items-center justify-content-center"
                            style="
                            margin-left: auto;
                            margin-right: auto;
                            background-color: white;
                            border: 1px solid #ddd;
                            border-radius: 8px;
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                            padding: 10px 15px;
                            transition: box-shadow 0.3s ease;
                            ">
                                <span class="poppins-medium" style="color: #333;">Save Wishlist</span>
                            </a>
                        </div>
                    </div>
                `);

                let html = '';
                res.wishlist.forEach(function (wishlist) {
                    let stats = wishlist.review || {};
                    let hotdeal = wishlist.rate || {};
                    let isProvider = stats.is_provider || false;

                    function formatPrice(value) {
                        return new Intl.NumberFormat('id-ID').format(value || 0);
                    }

                    // Rating HTML
                    let ratingHtml = '';
                    if (stats.average_rating > 0) {
                        if (isProvider) {
                            ratingHtml = `
                                <div class="provider-rating g-color-black mb-2">
                                    <i class="bi bi-shop"></i>
                                    <span>Provider Rating</span>
                                </div>
                                <div class="d-flex align-items-center" style="gap: 3px;">
                                    <div class="d-flex align-items-center" style="gap: 8px;">
                                        <i class="bi bi-star-fill text-warning"></i> ${stats.average_rating}
                                    </div>
                                    ${wishlist.ordered > 0 ? `
                                        <span>・</span>
                                        <span>${wishlist.ordered >= 1000 ? (wishlist.ordered / 1000).toFixed(1) + 'k' : wishlist.ordered} booked</span>
                                    ` : ''}
                                </div>
                            `;
                        } else {
                            ratingHtml = `
                                <div class="d-flex align-items-center" style="gap: 3px;">
                                    <div class="d-flex" style="gap: 8px;">
                                        <i class="bi bi-star-fill text-warning"></i> ${stats.average_rating}/5 (${stats.total_review})
                                    </div>
                                    ${wishlist.ordered > 0 ? `
                                        <span>・</span>
                                        <span>${wishlist.ordered >= 1000 ? (wishlist.ordered / 1000).toFixed(1) + 'k' : wishlist.ordered} booked</span>
                                    ` : ''}
                                </div>
                            `;
                        }
                    } else {
                        ratingHtml = `
                            <div class="new-product g-color-black mb-2">
                                <i class="bi bi-tag"></i>
                                <span>New Product</span>
                            </div>
                        `;
                    }

                    // Harga HTML
                    let priceHtml = '';
                    if (hotdeal.discounted_price > 0) {
                        priceHtml = `
                            <span class="g-color-gold g-font-weight-600 original-price" style="color: red; font-size: 11pt;">
                                <s style="text-decoration: line-through; color: red;">
                                    <span class="activecurrency">IDR</span>
                                    <span class="valuecurrency" data-baseprice="${hotdeal.rate_option_price}">
                                        ${formatPrice(hotdeal.rate_option_price)}
                                    </span>
                                </s>
                            </span><br>
                            <span class="g-color-gold g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                                <span class="activecurrency">IDR</span>
                                <span class="valuecurrency" data-baseprice="${hotdeal.discounted_price}">
                                    ${formatPrice(hotdeal.discounted_price)}
                                </span>
                            </span>
                        `;
                    } else {
                        priceHtml = `
                            <br><span class="g-color-gold g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                                <span class="activecurrency">IDR</span>
                                <span class="valuecurrency" data-baseprice="${hotdeal.min_publish_price || 0}">
                                    ${formatPrice(hotdeal.min_publish_price || 0)}
                                </span>
                            </span>
                        `;
                    }

                    html += `
                    <div class="col-sm-12 col-md-6 col-lg-3 d-flex justify-content-center mb-4">
                        <div class="card card-fixed shadow position-relative">
                            <figure>
                                <div class="swiper-container" data-product-id="${wishlist.product_id}">
                                    <div class="swiper-wrapper">
                                        <div class="swiper-slide">
                                            <a href="${PIXURL}/uploads/products/${wishlist.product_id}/${wishlist.product_image}" data-fancybox="gallery-${wishlist.product_id}" data-caption="${wishlist.product_name}">
                                                <img src="${PIXURL}/uploads/products/${wishlist.product_id}/${wishlist.product_image}" alt="${wishlist.product_name}">
                                            </a>
                                        </div>
                                    </div>
                                    <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
                                    <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <figcaption class="label-top poppins-medium" style="transform: translateY(-590%); z-index: 1;">${wishlist.product_group}</figcaption>
                                    <div class="heart-icon">
                                        <i class="bi bi-heart-fill wishlist active" data-product-id="${wishlist.product_id}"></i>
                                    </div>
                                </div>
                            </figure>

                            <div class="card-body d-flex flex-column justify-content-between" style="height: 150px;">
                                <div class="card-top">
                                    <a class="h4 poppins-semibold card-title truncate-text" href="${BASEURL}/${wishlist.product_id}/${wishlist.product_url}/" target="_blank">${wishlist.product_name}</a>
                                    <div class="text-muted pt-1" style="font-size: 14px;">${ratingHtml}</div>
                                </div>

                                ${hotdeal.min_publish_price > 0 ? `
                                <div>
                                    <span class="start-from poopins-medium">Start from</span> 
                                    ${priceHtml}
                                    <div class="see-details">
                                        <a href="${BASEURL}/${wishlist.product_id}/${wishlist.product_url}/" style="color: #555; text-decoration-line: none;">
                                            <div class="d-flex justify-content-end align-items-center hover-move py-1" style="cursor: pointer; padding-bottom: .5rem;">
                                                <span>See details</span>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                                                    <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                                                </svg>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                                ` : `
                                <h6 style="color: red;">Not Available</h6>
                                <p>Currently it is not possible to book this product due to its limited availability.</p>
                                `}
                            </div>
                        </div>
                    </div>
                    `;
                });

                $('#wishlist-container').html(html);

                // Pagination HTML
                let paginationHtml = '';
                if (res.total_pages > 1) {
                    paginationHtml += `<nav class="g-mt-100" aria-label="Page Navigation">
                      <ul class="list-inline mb-0">`;

                    // Tombol Previous
                    if (page > 1) {
                        paginationHtml += `
                        <li class="list-inline-item">
                          <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-mr-15 page-link"
                            href="#" data-page="${page - 1}" aria-label="Previous">
                            <span aria-hidden="true"><i class="fa fa-angle-left"></i></span>
                            <span class="sr-only">Previous</span>
                          </a>
                        </li>`;
                    }

                    // Halaman pertama
                    if (page > 2) {
                        paginationHtml += `
                        <li class="list-inline-item hidden-down">
                          <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 page-link ${page === 1 ? 'active' : ''}"
                            href="#" data-page="1">1</a>
                        </li>`;
                        if (page > 3) {
                            paginationHtml += `
                            <li class="list-inline-item hidden-down">
                              <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
                            </li>`;
                        }
                    }

                    // Current -1
                    if (page > 1) {
                        paginationHtml += `
                        <li class="list-inline-item hidden-down">
                          <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 page-link"
                            href="#" data-page="${page - 1}">${page - 1}</a>
                        </li>`;
                    }

                    // Current
                    paginationHtml += `
                    <li class="list-inline-item hidden-down">
                      <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 active"
                        href="#" data-page="${page}">${page}</a>
                    </li>`;

                    // Current +1
                    if (page < res.total_pages) {
                        paginationHtml += `
                        <li class="list-inline-item hidden-down">
                          <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 page-link"
                            href="#" data-page="${page + 1}">${page + 1}</a>
                        </li>`;
                    }

                    // Halaman terakhir
                    if (page < res.total_pages - 1) {
                        if (page < res.total_pages - 2) {
                            paginationHtml += `
                            <li class="list-inline-item hidden-down">
                              <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
                            </li>`;
                        }
                        paginationHtml += `
                        <li class="list-inline-item hidden-down">
                          <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 page-link ${page === res.total_pages ? 'active' : ''}"
                            href="#" data-page="${res.total_pages}">${res.total_pages}</a>
                        </li>`;
                    }

                    // Tombol Next
                    if (page < res.total_pages) {
                        paginationHtml += `
                        <li class="list-inline-item">
                          <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-ml-15 page-link"
                            href="#" data-page="${page + 1}" aria-label="Next">
                            <span aria-hidden="true"><i class="fa fa-angle-right"></i></span>
                            <span class="sr-only">Next</span>
                          </a>
                        </li>`;
                    }

                    // Info halaman
                    paginationHtml += `
                    <li class="list-inline-item float-right">
                      <span class="u-pagination-v1__item-info g-color-gray-dark-v4 g-font-size-12 g-pa-5">
                        Page ${page} of ${res.total_pages}
                      </span>
                    </li>`;

                    paginationHtml += `</ul></nav>`;
                }
                $('#wishlist-pagination').html(paginationHtml);

            }
        });
    }

    // Load awal
    loadWishlist(currentPage);

    // Event click pagination
    $(document).on('click', '#wishlist-pagination .page-link', function (e) {
        e.preventDefault();
        let page = parseInt($(this).data('page'));
        if (page && page !== currentPage) {
            currentPage = page;
            loadWishlist(page);
        }
    });
});

function confirmAndSaveWishlist() {
    Swal.fire({
        title: "Save wishlist?",
        text: "Please confirm if you want to add this item to your wishlist.",
        icon: "warning",
        confirmButtonText: "Confirm"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: BASEURL + '/wishlist/savewishlist',
                type: 'POST',
                data: { 'wishlist': wishlist },
                success: function(response) {
                    // let data = JSON.parse(response);

                    Swal.fire({
                        title: "Success!",
                        text: "Your wishlist has been saved successfully.",
                        icon: "success",
                        confirmButtonText: "OK"
                    }).then(() => {
                        // Hapus wishlist di localStorage
                        localStorage.removeItem('wishlist');

                        // Redirect ke orders page
                        window.location.href = BASEURL + '/account/wishlist/';
                    });
                },
                error: function() {
                    Swal.fire({
                        title: "Oops!",
                        text: "Something went wrong while saving your wishlist.",
                        icon: "error"
                    });
                }
            });
        }
    });
}

function onGoogleLoginSuccess() {
    checkAndSavePendingWishlist();
}