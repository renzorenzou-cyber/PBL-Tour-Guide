$(document).ready(function () {
  // Ketika tombol simpan avatar diklik
  $('#simpan_avatar').on('click', function (e) {
    e.preventDefault();

    // Validasi file
    const fileInput = document.getElementById('new_avatar');
    const file = fileInput.files[0];
    if (!file) {
      Swal.fire({
        title: "Error",
        text: "Please select a file to upload.",
        icon: "error",
      });
      return;
    }

    // Validasi format dan ukuran file
    const allowedExtensions = ["image/jpeg", "image/png"];
    const maxSize = 5 * 1024 * 1024; // 5 MB
    if (!allowedExtensions.includes(file.type)) {
      Swal.fire({
        title: "Error",
        text: "Invalid file format. Please upload a JPG or PNG file.",
        icon: "error",
      });
      return;
    }
    if (file.size > maxSize) {
      Swal.fire({
        title: "Error",
        text: "File size exceeds 5MB. Please upload a smaller file.",
        icon: "error",
      });
      return;
    }

    // Persiapkan form data
    const frm = $('#form_update_avatar')[0];
    const formData = new FormData(frm);

    // Kirim data menggunakan AJAX
    $.ajax({
      url: BASEURL + '/account/editprofilepicture/',
      type: 'POST',
      data: formData,
      contentType: false,
      processData: false,
      success: function (response) {
        // Respons sudah dalam format JSON, jadi tidak perlu JSON.parse()
        if (response.status === 'success') {
          Swal.fire({
            title: "Success",
            text: response.message,
            icon: "success",
          }).then((result) => {
            if (result.isConfirmed) {
              location.reload();
            }
          });
        } else {
          Swal.fire({
            title: "Error",
            text: response.message,
            icon: "error",
          });
        }
      },
      error: function (xhr, status, error) {
        Swal.fire({
          title: "Error",
          text: "An error occurred: " + error,
          icon: "error",
        });
      }
    });
  });

  // Fungsi untuk menu content
  document.querySelectorAll('.button-menu').forEach(item => {
    item.addEventListener('click', function (event) {
      event.preventDefault(); // Mencegah navigasi default
      function hideAllContents() {
        document.querySelectorAll('.orders-content').forEach(content => {
          content.style.display = 'none';
        });
      }

      hideAllContents(); // Sembunyikan semua konten

      const targetId = item.getAttribute('data-target') || item.id.replace('-tab', '');
      const targetContent = document.getElementById(targetId);

      if (targetContent) {
        targetContent.style.display = 'block'; // Tampilkan konten yang sesuai
      }

      // Hapus class active dari semua menu
      document.querySelectorAll('.button-menu').forEach(menu => {
        menu.classList.remove('active', 'g-color-primary--parent-active', 'g-bg-gray-light-v5--active');
      });

      // Tambahkan class active ke menu yang diklik
      item.classList.add('active', 'g-color-primary--parent-active', 'g-bg-gray-light-v5--active');

      // Ubah URL di address bar tanpa me-refresh halaman
      const newUrl = item.getAttribute('href'); // Ambil URL dari href
      history.pushState({ id: targetId }, '', newUrl);
    });
  });

  // fungsi untuk menu content end


  //fungsi untuk edit detail profile
  document.querySelectorAll('.button-tab').forEach(item => {
    item.addEventListener('click', function (event) {
      event.preventDefault(); // Mencegah navigasi default
      function hideAllContents() {
        document.querySelectorAll('.profile-tab-content').forEach(content => {
          content.style.display = 'none';
        });
      }

      hideAllContents(); // Sembunyikan semua konten

      const targetId = item.getAttribute('data-target') || item.id.replace('-tab', '');
      const targetContent = document.getElementById(targetId);

      if (targetContent) {
        targetContent.style.display = 'block'; // Tampilkan konten
        setTimeout(() => {
          targetContent.classList.add('active'); // Tambahkan animasi masuk
        }, 10); // Delay kecil supaya animasi bisa jalan
      }

      // Hapus class active dari semua menu
      document.querySelectorAll('.button-tab').forEach(menu => {
        menu.classList.remove('active');
      });

      // Tambahkan class active ke menu yang diklik
      item.classList.add('active');
    });
  });
  //fungsi untuk edit detail profile end

  $('#save-new-profile').on('click', function (e) {
    e.preventDefault();

    let frm = $('#profile_form');
    let data = serializeFormJSON(frm);
    console.log(data);

    $.ajax({
      url: BASEURL + '/account/editprofile/',
      type: 'POST',
      data: data,
      success: function (response) {
        Swal.fire({
          title: "Success",
          text: 'Profile updated successfully.',
          icon: "success",
        }).then((result) => {
          if (result.isConfirmed) {
            location.reload();
          }
        });
      },
    });
  });

  $('#save-new-password').on('click', function (e) {
    e.preventDefault();

    let frm = $('#changepass_form');
    let data = serializeFormJSON(frm);
    console.log(data);
    let password = $('input[name="new_password"]').val();
    let confirmPassword = $('input[name="confirm_password"]').val();

    if (password !== confirmPassword) {
      Swal.fire({
        title: "Password doesn't match!",
        text: "Please check your password",
        icon: "error"
      });
      return;
    }

    $.ajax({
      url: BASEURL + '/account/changepassword/',
      type: 'POST',
      data: data,
      success: function (response) {
        Swal.fire({
          title: "Success",
          text: 'Password updated successfully.',
          icon: "success",
        }).then((result) => {
          if (result.isConfirmed) {
            location.reload();
          }
        });
      },
    });
  })

  $('.write-review-btn').on('click', function () {
    const productId = $(this).data('product-id');
    const orderDetail = $(this).data('orderdetail');
    $('#product_id_modal').val(productId);
    $('#order_detail_id').val(orderDetail);
  });

  $('.button-save-review').on('click', function (e) {
    e.preventDefault();

    const selectedRating = $('input[name="review_star"]:checked').val();
    if (!selectedRating) {
      Swal.fire({
        icon: 'warning',
        title: 'Peringatan',
        text: 'Silakan pilih bintang rating terlebih dahulu.'
      });
      return;
    }

    const form = $('#form_add_review')[0];
    const formData = new FormData(form);

    $.ajax({
      url: BASEURL + '/account/savereview',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function (res) {
        if (res.status === 'success') {
          Swal.fire({
            icon: 'success',
            title: 'Berhasil',
            text: res.message
          }).then(() => {
            $('#form_add_review')[0].reset();
            $('#exampleModal5').modal('hide');
            location.reload();
          });
        } else {
          Swal.fire('Error', res.message, 'error');
        }
      },
      error: function () {
        Swal.fire('Error', 'Terjadi kesalahan saat menyimpan review.', 'error');
      }
    });
  });

  $('.reset-save').on('click', function () {
    $('#form_add_review')[0].reset();
    $('#ratingText').text('');
    $('#starRating input[type=radio]').prop('checked', false);
  });

}).on('click', '#logout', function () {
  Swal.fire({
    title: 'Confirm logout?',
    text: 'Any unsaved changes will be lost.',
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#334960",
    cancelButtonColor: "#d33",
    confirmButtonText: "Yes, Confirm!",
    cancelButtonText: 'No'
  }).then((result) => {
    if (result.isConfirmed) {
      $.ajax({
        url: BASEURL + "/account/logout/",
        beforeSend: function () {
          HoldOn.open({
            theme: 'sk-dot',
            message: "<h4>Proccessing..</h4>"
          });
        },
        success: function (r) {
          HoldOn.close();
          location.href = BASEURL + "/account/login/";
        }
      });
    }
  });
}).on('click', '#cancel-order', function () {
  const code = $(this).data('code');
  const order_detail_id = $(this).data('orderdetail');
  const deadline = new Date($(this).data('deadline'));
  const now = new Date();
  if (now > deadline) {
    Swal.fire('Too Late', 'This order can no longer be canceled.', 'info');
    return;
  }
  let html = '';
  html += `<p>Are you sure you want to cancel this order? This action cannot be undone and your order will be marked as canceled.</p>`;
  html += `
      <div style="text-align:left">
        Reason <span style="color:red;">*</span><br>
        <textarea id="cancelReason" maxlength="500" cols="47" required></textarea>
        <div style="font-size: 12px; text-align: right;">
          <span id="charCount">0</span>/500 characters
        </div>
      </div>`;


  Swal.fire({
    title: 'Cancel Order?',
    html: html,
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#334960",
    cancelButtonColor: "#d33",
    confirmButtonText: "Yes, Confirm!",
    cancelButtonText: 'No',
    didOpen: () => {
      const confirmBtn = Swal.getConfirmButton();
      confirmBtn.disabled = true;

      const textarea = document.getElementById('cancelReason');
      const charCount = document.getElementById('charCount');

      textarea.addEventListener('input', function () {
        // Potong karakter jika melebihi
        if (textarea.value.length > 500) {
          textarea.value = textarea.value.substring(0, 500);
        }

        charCount.textContent = textarea.value.length;

        // Enable tombol kalau tidak kosong
        confirmBtn.disabled = textarea.value.trim() === '';
      });

    },
    preConfirm: () => {
      const reason = document.getElementById('cancelReason').value.trim();
      if (!reason) {
        Swal.showValidationMessage('Please provide a reason');
      }
      return { reason };
    }
  }).then((result) => {
    if (result.isConfirmed) {
      const reason = result.value.reason;

      $.ajax({
        url: BASEURL + "/account/orders/cancel-order/",
        type: 'POST',
        data: { 'code': code, 'reason': reason, 'order_detail_id': order_detail_id },
        beforeSend: function () {
          HoldOn.open({
            theme: 'sk-dot',
            message: "<h4>Please Wait..</h4>"
          });
        },
        success: function (r) {
          HoldOn.close();

          if (r.status === 'error') {
            Swal.fire({
              title: "Error",
              text: r.message,
              icon: "error"
            });
            return;
          }

          Swal.fire({
            title: "Order Canceled",
            text: 'Your order has been successfully canceled!',
            icon: "success",
          }).then((result) => {
            if (result.isConfirmed) {
              location.href = BASEURL + '/account/orders/';
            }
          });
        }
      });
    }
  });

})

document.addEventListener('DOMContentLoaded', function () {

  $(function () {
    $('[data-bs-toggle="tooltip"]').tooltip();
  });

  const modal = document.getElementById('exampleModal5');
  const productInput = document.getElementById('product_id_modal');
  const orderInput = document.getElementById('order_id_modal');

  document.querySelectorAll('.btn-write-review').forEach(function (btn) {
    btn.addEventListener('click', function () {
      const pid = this.getAttribute('data-product-id');
      const oid = this.getAttribute('data-order-id');

      productInput.value = pid;
      orderInput.value = oid;
      console.log("Product ID set:", pid); // debug
    });
  });
});

document.addEventListener('DOMContentLoaded', function () {
  FilePond.registerPlugin(FilePondPluginImagePreview, FilePondPluginFileValidateType);

  FilePond.create(document.querySelector('#review_images'), {
    allowMultiple: true,
    acceptedFileTypes: ['image/*', 'video/*'],
    maxFiles: 5,
    storeAsFile: true,
    imagePreviewHeight: 120,
    labelIdle: 'Drag & Drop or Browse files'
  });
});

document.addEventListener('DOMContentLoaded', function () {
  // Register plugin
  FilePond.registerPlugin(
    FilePondPluginImagePreview,
    FilePondPluginFileValidateType
  );

  // Buat instance FilePond dan simpan referensinya
  const inputElement = document.querySelector('#new_avatar');
  const pond = FilePond.create(inputElement, {
    allowMultiple: false,
    acceptedFileTypes: ['image/jpeg', 'image/png'],
    maxFileSize: '5MB',
    imagePreviewHeight: 120,
    labelIdle: 'Drag & Drop your image or <span class="filepond--label-action">Browse</span>',
  });

  // Tombol simpan avatar
  $('#simpan_avatar').on('click', function (e) {
    e.preventDefault();

    const files = pond.getFiles(); // Ambil file dari FilePond

    if (files.length === 0) {
      Swal.fire({
        title: "Error",
        text: "Please select a file to upload.",
        icon: "error",
      });
      return;
    }

    const fileItem = files[0];
    const file = fileItem.file;

    // Validasi format dan ukuran
    const allowedExtensions = ["image/jpeg", "image/png"];
    const maxSize = 5 * 1024 * 1024;

    if (!allowedExtensions.includes(file.type)) {
      Swal.fire({
        title: "Error",
        text: "Invalid file format. Please upload a JPG or PNG file.",
        icon: "error",
      });
      return;
    }

    if (file.size > maxSize) {
      Swal.fire({
        title: "Error",
        text: "File size exceeds 5MB. Please upload a smaller file.",
        icon: "error",
      });
      return;
    }

    // Buat FormData dan tambahkan file
    const formData = new FormData();
    formData.append('avatar', file);

    $.ajax({
      url: BASEURL + '/account/editprofilepicture/',
      type: 'POST',
      data: formData,
      contentType: false,
      processData: false,
      success: function (response) {
        if (response.status === 'success') {
          Swal.fire({
            title: "Success",
            text: response.message,
            icon: "success",
          }).then((result) => {
            if (result.isConfirmed) {
              location.reload();
            }
          });
        } else {
          Swal.fire({
            title: "Error",
            text: response.message,
            icon: "error",
          });
        }
      },
      error: function (xhr, status, error) {
        Swal.fire({
          title: "Error",
          text: "An error occurred: " + error,
          icon: "error",
        });
      }
    });
  });
});

