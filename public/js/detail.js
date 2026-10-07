$(document).ready(function () {
  const previewDiv = document.getElementById('mapPreview');
  if (previewDiv) {
  const openMapBtn = document.getElementById('openMap');
  const mapModal = document.getElementById('mapModal');
  const closeMapBtn = document.getElementById('closeMap');

  const latitude = parseFloat(previewDiv.getAttribute('data-latitude'));
  const longitude = parseFloat(previewDiv.getAttribute('data-longitude'));
  const provider = previewDiv.getAttribute('data-provider') || 'Provider';

  let mapPreview, mapPopup;

  mapPreview = L.map('mapPreview').setView([latitude, longitude], 15);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
  }).addTo(mapPreview);

  L.marker([latitude, longitude])
        .addTo(mapPreview)
        .bindPopup(`<b>${provider}</b>`)
        .openPopup();

  setTimeout(() => {
    mapPreview.invalidateSize();
  }, 200);

  // Buka modal
  openMapBtn.addEventListener('click', function () {
    mapModal.classList.add('show');
    mapModal.classList.remove('d-none');

    if (!mapPopup) {
        const mapPopup = L.map('mapPopup').setView([latitude, longitude], 15);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        }).addTo(mapPopup);

        // Marker tujuan
        L.marker([latitude, longitude])
        .addTo(mapPopup)
        .bindPopup(`<b>${provider}</b>`)
        .openPopup();

        let routingControl;
        let userMarker;
        let watchId;
        let pathLine;
        let pathCoords = [];

        const startBtn = document.getElementById('startBtn');
        const exitBtn = document.getElementById('exitBtn');

        startBtn.addEventListener('click', () => {
        if (!navigator.geolocation) {
            alert("Geolocation is not available.");
            return;
        }

        // Loading UI
        document.getElementById('mapLoadingOverlay').style.display = 'flex';


        navigator.geolocation.getCurrentPosition((position) => {
            document.getElementById('mapLoadingOverlay').style.display = 'none';
            const userLat = position.coords.latitude;
            const userLng = position.coords.longitude;
            const userLatLng = L.latLng(userLat, userLng);
            const redIcon = L.icon({
            iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
            shadowUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png',
            iconSize: [25, 41],
            iconAnchor: [12, 41],
            popupAnchor: [1, -34],
            shadowSize: [41, 41]
            });


            // Bersihkan routing lama kalau ada
            if (routingControl) {
            mapPopup.removeControl(routingControl);
            routingControl = null;
            }

            routingControl = L.Routing.control({
            waypoints: [userLatLng, L.latLng(latitude, longitude)],
            position: 'bottomright',
            routeWhileDragging: false,
            draggableWaypoints: false,
            addWaypoints: false,
            lineOptions: {
                styles: [{ color: '#007bff', opacity: 0.8, weight: 5 }]
            },
            createMarker: () => null
            }).addTo(mapPopup);

            mapPopup.setView(userLatLng, 12);

            // Marker user
            userMarker = L.marker(userLatLng, { icon: redIcon })
            .addTo(mapPopup)
            .bindPopup("<b>You are here</b>")
            .openPopup();

            // Garis jejak
            pathCoords = [userLatLng];
            pathLine = L.polyline(pathCoords, {
            color: '#28a745',
            weight: 3,
            opacity: 0.8
            }).addTo(mapPopup);

            // Real-time tracking
            watchId = navigator.geolocation.watchPosition((pos) => {
            const newLat = pos.coords.latitude;
            const newLng = pos.coords.longitude;
            const newLatLng = L.latLng(newLat, newLng);

            // Tambah ke jejak
            pathCoords.push(newLatLng);
            pathLine.setLatLngs(pathCoords);

            // Smooth animation
            const currentPos = userMarker.getLatLng();
            const duration = 500;
            let start = null;

            function animateMarker(timestamp) {
                if (!start) start = timestamp;
                const progress = timestamp - start;
                const percent = Math.min(progress / duration, 1);

                const lat = currentPos.lat + (newLat - currentPos.lat) * percent;
                const lng = currentPos.lng + (newLng - currentPos.lng) * percent;

                const interpolated = [lat, lng];
                userMarker.setLatLng(interpolated);
                mapPopup.setView(interpolated, 17);
                

                if (percent < 1) {
                requestAnimationFrame(animateMarker);
                }
            }

            requestAnimationFrame(animateMarker);
            }, (err) => {
            console.error("Failed to update Position:", err);
            }, {
            enableHighAccuracy: true,
            maximumAge: 1000
            });

            // Update UI
startBtn.classList.remove('loading');
startBtn.style.display = 'none';
exitBtn.style.display = 'block';
startBtn.textContent = 'Navigation Active';

// SEMBUNYIKAN OVERLAY DI SINI SAAT SEMUA SUDAH SIAP
document.getElementById('mapLoadingOverlay').style.display = 'none';

        }, () => {
            alert("Failed to get location");
            startBtn.classList.remove('loading');
            startBtn.textContent = 'Start Navigation';
        });
        });

        exitBtn.addEventListener('click', () => {
            document.getElementById('mapLoadingOverlay').style.display = 'none';

        if (watchId) navigator.geolocation.clearWatch(watchId);

        if (routingControl) {
            mapPopup.removeControl(routingControl);
            routingControl = null;
        }

        if (userMarker) {
            mapPopup.removeLayer(userMarker);
            userMarker = null;
        }

        if (pathLine) {
            mapPopup.removeLayer(pathLine);
            pathLine = null;
            pathCoords = [];
        }

        // Reset UI
        exitBtn.style.display = 'none';
        startBtn.style.display = 'block';
        startBtn.disabled = false;
        startBtn.textContent = 'Start Navigation';
        document.getElementById('routeInfo').style.display = 'none';

        });
    } else {
      mapPopup.invalidateSize();
      mapPopup.setView([latitude, longitude], 15);
    }
  });

  // Tutup modal
  function closeModal() {
    mapModal.classList.remove('show');
    mapModal.classList.add('d-none');
  }

  closeMapBtn.addEventListener('click', closeModal);

  // Klik luar konten close modal
  window.addEventListener('click', function (event) {
    if (event.target === mapModal) {
      closeModal();
    }
  });
}
    // Event listener untuk tombol search availability
    $(document).on('click', '#searchavailability', function (e) {
        e.preventDefault();
        var id = $(this).data('idp');
        var tanggal = $('#tanggal').val();
        // const form_date2 = $('#tanggal2');
        let module = $(this).data('module');
        var tanggal2 = $('#tanggal2').val();
        var html = '';
        let calendar = null;

        // Validasi input kosong menggunakan SweetAlert
        // if (!person) {
        //     swal({
        //         title: "Missing Input",
        //         text: "Please fill in the number of persons.",
        //         icon: "warning",
        //         button: "OK",
        //     }).then(() => {
        //         $('#person').focus(); // Fokus ke input person
        //     });
        //     return;
        // }
        if(module == 10 || module == 11){

            if (!tanggal) {
                swal({
                    title: "Missing Input",
                    text: "Please select a date.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('#tanggal').focus(); // Fokus ke input tanggal
                });
                return;
            }
        } else if(module == 9 || module == 1 || module || 2) {
            if (!tanggal) {
                swal({
                    title: "Missing Input",
                    text: "Please select a date.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('#tanggal').focus(); // Fokus ke input tanggal
                });
                return;
            }

            if (!tanggal2) {
                swal({
                    title: "Missing Input",
                    text: "Please select a date.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('#tanggal2').focus(); // Fokus ke input tanggal
                });
                return;
            }
        }


        // Jika validasi lolos, lanjutkan dengan permintaan AJAX
        $.ajax({
            url: BASEURL + '/product/availability/',
            data: { 'id': id, 'tanggal': tanggal, 'tanggal2': tanggal2 },
            method: 'POST',
            beforeSend: function () {
                $('#show_result').html('<i class="fa fa-spinner fa-spin"></i> Loading..<br /><br />');
            },
            success: function (r) {
                let dt = JSON.parse(r);
                let harga = '';
                console.log('data', dt);

                // Hanya satu accordion tab yang ditampilkan
                let y = dt[0]; // Mengambil data hanya dari item pertama (tab pertama)

                let formattedDate = formatDate(tanggal); // Format tanggal dari input
                let formattedDate2 = formatDate2(tanggal);

                html += '<div class="accordion mb-5" id="accordionExample">' +
                    '<div class="card">' +
                    '<div id="heading0">' +
                    '<h2 class="mb-0">' +
                    '<button class="btn btn-block text-left" style="padding:15px 10px 10px 15px; border-radius: 16px; background-color: white;" type="button" data-toggle="collapse" data-target="#collapse0" aria-expanded="true" aria-controls="collapse0" data-parent="#accordionExample">' +
                    '<h4 class="option-name" style="font-weight:bold;">' + y.name + ' Options</h4>' +
                    '</button>' +
                    '</h2>' +
                    '</div>' +
                    '<div id="collapse0" class="collapse show" aria-labelledby="heading0" data-parent="#accordionExample">' +
                    '<div class="col-lg-6 col-md-6 col-sm-12" role="group" aria-label="Rate Options">';
                html += '<select class="form-control select_rate" data-idproduct="' + id + '" data-tanggal="' + tanggal + '" data-tanggal2="'+tanggal2+'">';
                $.each(dt, function (index, rate) {
                    html += '<option value="' + rate.id + '">' + rate.title + '</option>';
                });
                html += '</select>';

                html += '</div>' +
                    '<div class="card-body">' +
                    '<hr style=" margin-top:10px; width:100%; margin-bottom:-10px;">' +
                    '</div>';

                html += `<form id="rate_form" class="">`;
                html += `
                                <h6 class="ml-4 mt-4 g-color-black" style="font-weight:bold;">Session Time</h6>
                                <h6 class="ml-4 g-color-black" id="tanggalDisplay">${formattedDate}</h6>`;
                html += `
                            <div class="ml-4 rate_option">
                                <div id="rate_list" class="form-group row" style="width: 100%;">`;

                //block module
                $.each(dt[0].rates, function (x, yy) {
                    const startDate = yy.start_date ? new Date(yy.start_date).toISOString().split('T')[0] : null;
                    const endDate = yy.end_date ? new Date(yy.end_date).toISOString().split('T')[0] : null;

                    console.log(startDate);
                    console.log(endDate);

                    // Cek start date & end date
                    if ((startDate && tanggal && tanggal2 < startDate) || (endDate && tanggal && tanggal2 > endDate)) {
                        html += `
                        <div style="padding-left:30px">
                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                </svg>
                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                            </a>
                        </div>`;
                        return false;
                    }

                    if (yy.availability_data && yy.availability_data.length > 0) {
                        let moduleData = {};

                        // Kelompokkan data berdasarkan module_id
                        $.each(yy.availability_data, function (oo, pp) {
                            if (!moduleData[pp.module_id]) {
                                moduleData[pp.module_id] = [];
                            }
                            moduleData[pp.module_id].push(pp);
                        });

                        let selectedDate = new Date(tanggal);
                        let selectedDayNumber = selectedDate.getDay(); // 0 = Minggu, ..., 6 = Sabtu

                        $.each(moduleData, function (moduleId, data) {
                            if (moduleId == '10') { // Session Time

                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        const bookingWindowEnd = parseInt(yy.booking_window_end || 0);
                                        const now = new Date();
                                        const selectedDate = new Date(tanggal); 
                                        const todayDate = new Date(now.toISOString().split('T')[0]);

                                        const sessionDateTime = new Date(`${tanggal}T${pp.time_available}`);

                                        if (selectedDate.getTime() === todayDate.getTime()) {
                                            const minBookingTime = new Date(now.getTime() + bookingWindowEnd * 60000);

                                            if (sessionDateTime > minBookingTime) {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: pp.time_available.substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability: pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                            }
                                        } else {
                                            hasValidSession = true;
                                            timeList.push({
                                            time: pp.time_available.substring(0, 5),
                                            price: pp.publish_price,
                                            discounted_price: pp.discounted_price,
                                            availability: pp.id,
                                            breakdown: pp.breakdown || []
                                            });
                                        }
                                    }
                                });

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-rate_opt-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;

                                    if (!yy.discounted_price) {
                                        html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                    <span class="activecurrency">IDR</span> 
                                                    <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    ${
                                                        yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                            ? `
                                                            <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                            </div>`
                                                            : ''
                                                    }
                                                </div>`;
                                    } else {
                                        html += `
                                                <div style="color:red;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                    <s style="text-decoration: line-through;color: red;">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    </s>
                                                    <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.availability_data[0].discounted_price)}</span>/${yy.rate_option_unit}
                                                        ${
                                                            yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                ? `
                                                                <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                    <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                    <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                </div>`
                                                                : ''
                                                        }
                                                    </div>
                                                </div>`;
                                    }

                                    html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3 py-3">
                                                    <select class="form-control rounded-5 timeselection session-select" name="timeselection" data-session-id="${yy.id}" data-defaultPrice="${harga}">
                                                        <option value="0" data-harga="0">Sessions</option>`;

                                    $.each(timeList, function (m, item) {
                                        html += `<option class="timeSelection" value="${item.time}" data-harga="${parseFloat(item.price)}" data-hargadiskon="${parseFloat(item.discounted_price)}" data-availability="${item.availability}" data-breakdown='${JSON.stringify(item.breakdown || [])}'>${item.time}</option>`;
                                    });

                                    html += `</select></div>`;

                                    html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <input min="${yy.min_qty}" max="${yy.max_qty}" name="qty" 
                                                        class="form-control rounded-5 qty" type="number" 
                                                        placeholder="Qty" value="0" 
                                                        data-hotdeals="${yy.discounted_price}" 
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"
                                                        data-harga="${harga}"/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                }

                            } else if (moduleId == '9') { // Rental
                                // Cek start date & end date
                            if ((startDate && tanggal < startDate) || (endDate && tanggal > endDate)) {
                                html += `
                                <div style="padding-left:30px">
                                    <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                        class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                            class="bi bi-whatsapp" viewBox="0 0 16 16">
                                            <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                        </svg>
                                        <span style="margin-left: 8px;">Book via WhatsApp</span>
                                    </a>
                                </div>`;
                                return false;
                            }
                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        hasValidSession = true; // Set flag bahwa ada sesi valid
                                        timeList.push({
                                            time: pp.time_available ? pp.time_available.substring(0, 5) : '',
                                            price: pp.publish_price,
                                            discounted_price: pp.discounted_price,
                                            availability: pp.id,
                                            breakdown: pp.breakdown
                                        });
                                    }
                                });

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                // Hitung selisih tanggal
                                let daysDiff = 0;
                                if (tanggal && tanggal2) {
                                    const start = new Date(tanggal);
                                    const end = new Date(tanggal2);
                                    daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
                                }

                                // Ganti nilai default 0 dengan hasil hitungan
                                // html = html.replace(/(<input[^>]*name="days"[^>]*value=")(0)"/, `$1${daysDiff}"`);
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;



                                    if (!yy.discounted_price) {
                                        html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                    <span class="activecurrency">IDR</span> 
                                                    <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    ${
                                                        yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                            ? `
                                                            <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                            </div>`
                                                            : ''
                                                    }
                                                </div>`;
                                    } else {
                                        html += `
                                                <div style="color:red;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                    <s style="text-decoration: line-through;color: red;">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    </s>
                                                    <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.discounted_price)}</span>/${yy.rate_option_unit}
                                                        ${
                                                            yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                ? `
                                                                <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                    <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                    <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                </div>`
                                                                : ''
                                                        }
                                                    </div>
                                                </div>`;
                                    }

                                    html += `
                                                <div style="display: flex; align-items: center; gap: 1rem;" class="col-lg-2 col-md-2 col-sm-12 g-mt-3"> Qty
                                                    <input name="qty" class="form-control rounded-5 qty" type="number" placeholder="Qty" value="0" 
                                                    data-hotdeals="${yy.discounted_price}" 
                                                    data-module="${moduleId}"
                                                    data-stock="${yy.stock}"
                                                    data-harga="${harga}"
                                                    data-availability="${timeList[0].availability}"
                                                    data-breakdown='${JSON.stringify(timeList[0].breakdown)}'/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                    html += `
                                                <div style="display: flex; align-items: center; gap: 1rem;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3"> Day(s)
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <input name="days" min="${yy.min_qty}" max="${yy.max_qty}"
                                                        class="form-control rounded-5 days" type="number" 
                                                        placeholder="day(s)" value="${daysDiff}"  
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"/>
                                                </div>`;

                                }

                            } else if (moduleId == '11') { // Sim Card

                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        const bookingWindowEnd = parseInt(yy.booking_window_end || 0);
                                        const now = new Date();
                                        const selectedDate = new Date(tanggal); 
                                        const todayDate = new Date(now.toISOString().split('T')[0]);

                                        const sessionDateTime = new Date(`${tanggal}T${pp.time_available}`);

                                        if (selectedDate.getTime() === todayDate.getTime()) {
                                            const minBookingTime = new Date(now.getTime() + bookingWindowEnd * 60000);

                                            if (sessionDateTime > minBookingTime) {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: (pp.time_available || '').substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability: pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                            }
                                        } else {
                                            hasValidSession = true;
                                            timeList.push({
                                            time: (pp.time_available || '').substring(0, 5),
                                            price: pp.publish_price,
                                            discounted_price: pp.discounted_price,
                                            availability: pp.id,
                                            breakdown: pp.breakdown || []
                                            });
                                        }
                                    }
                                });

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-rate_opt-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;

                                    if (!yy.discounted_price) {
                                        html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-4 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                    <span class="activecurrency">IDR</span> 
                                                    <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    ${
                                                        yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                            ? `
                                                            <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                            </div>`
                                                            : ''
                                                    }
                                                </div>`;
                                    } else {
                                        html += `
                                                <div style="color:red;" 
                                                    class="col-lg-4 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                    <s style="text-decoration: line-through;color: red;">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    </s>
                                                    <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.availability_data[0].discounted_price)}</span>/${yy.rate_option_unit}
                                                        ${
                                                            yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                ? `
                                                                <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                    <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                    <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                </div>`
                                                                : ''
                                                        }
                                                    </div>
                                                </div>`;
                                    }

                                    html += `
                                                <div style="display: flex; align-items: center; gap: 0.5rem;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <label style="margin: 0; white-space: nowrap;">Qty</label>
                                                    <input min="${yy.min_qty}" max="${yy.max_qty}" name="qty" 
                                                        class="form-control rounded-5 qty" type="number" 
                                                        placeholder="Qty" value="0" 
                                                        data-hotdeals="${yy.discounted_price}" 
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"
                                                        data-harga="${harga}"
                                                        data-stock="${yy.stock}"
                                                        data-availability="${timeList[0].availability}"
                                                        data-breakdown='${JSON.stringify(timeList[0].breakdown)}'/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                }

                            } else if (moduleId == '1' || moduleId == '2') {
                                html += `<div class="rate_option" style="max-width: 600px; margin: 0 1.5rem 3rem;">
                                            <div id="rate_list" class="form-group row" style="width: 100%; height: auto;">  
                                                <div class="calendar-wrapper" style="padding: 20px; border-radius: 20px; border: none; width: 100%;">
                                                    
                                                    <div class="calendar-header" style="margin-bottom: 20px;">
                                                        <span id="night-info">
                                                            <h2 class="g-color-black" style="margin: 0 0 5px;">Select dates</h2>
                                                            <p class="g-color-black poppins-medium" style="margin: 0 0 20px 0; color: #666;">Add your travel dates for exact pricing</p>

                                                            <input id="night" name="night" type="hidden">
                                                            <input name="tanggal" type="hidden" value="${tanggal}">
                                                            <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                            <input type="hidden" name="id_product" value="${y.id_product}" />
                                                            <input type="hidden" name="module" value="${moduleId}"/>
                                                            <input type="hidden" name="subtotal" id="subtotal"/>
                                                        </span>

                                                        <div class="calendar-inputs g-color-black">
                                                            <div class="checkin" style="flex: 1;">
                                                                <label class="g-color-black">CHECK-IN</label>
                                                                <input id="checkin" name="checkin" class="date-input" placeholder="Add date" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                            </div>
                                                            <div class="checkout g-color-black" style="flex: 1;">
                                                                <label class="g-color-black">CHECKOUT</label>
                                                                <input id="checkout" name="checkout" class="date-input" placeholder="Add date" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                            </div>
                                                            <div class="checkout g-color-black" style="flex: 1;">
                                                                <label class="g-color-black">Room(s)</label>
                                                                <input type="number" class="qty" name="qty" 
                                                                value="1"
                                                                min="${yy.min_qty}" 
                                                                max="${yy.max_qty}"  
                                                                data-minqty="${yy.min_qty}" 
                                                                data-maxqty="${yy.max_qty}"
                                                                data-module="${moduleId}"
                                                                style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                            </div>
                                                            <button id="clear-dates" type="button" class="btn btn-danger" style="padding: 8px 12px; border-radius: 5px; cursor: pointer;">
                                                                <div class="d-flex align-items-center" style="gap: 5px;">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                                                        <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                                                                    </svg>
                                                                    Clear dates
                                                                </div>
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="select-dates-card">
                                                        <div id="calendar" style="margin-top: 2rem;"></div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        `;
                                html += `</div>`;


                                let minDate = null;
                                if (dt.length > 0 && dt[0].rates.length > 0) {
                                    const bookingWindowEnd = parseInt(dt[0].rates[0].booking_window_end);
                                    const daysNeeded = Math.ceil(bookingWindowEnd / 1440);
                                    const currentDate = new Date();

                                    if (daysNeeded > 1) {
                                        currentDate.setDate(currentDate.getDate() + (daysNeeded - 1));
                                    }

                                    minDate = currentDate.toISOString().split('T')[0];

                                    const blockedDates = dt[0].rates[0].blocked_dates;

                                    // 🔁 Ambil priceData dari availability_data
                                    let priceData = {};
                                    let dayNumberMap = {};
                                    data.forEach(a => {
                                        if (a.date_available == null && a.day_number) {
                                            let dayNum = parseInt(a.day_number);
                                            const publish = parseFloat(a.publish_price);
                                            const discount = parseFloat(a.discounted_price);
                                            const isHotdeal = discount > 0 && discount < publish;
                                            const finalPrice = isHotdeal ? discount : publish;

                                            // Simpan berdasarkan day_number
                                            dayNumberMap[dayNum] = {
                                                price: finalPrice,
                                                isHotdeal: isHotdeal,
                                                original: publish
                                            };
                                        } else if (a.rate_status != 1) {
                                            const publish = parseFloat(a.publish_price);
                                            const discount = parseFloat(a.discounted_price);

                                            const isHotdeal = discount > 0 && discount < publish; // diskon harus > 0 dan lebih kecil dari harga publish
                                            const finalPrice = isHotdeal ? discount : publish;

                                            priceData[a.date_available] = {
                                                price: finalPrice,
                                                isHotdeal: isHotdeal,
                                                original: publish
                                            };
                                        }
                                    });


                                    let calendarInstance = null;

                                    function toKFormat(number) {
                                        if (number >= 1000) {
                                            let result = number / 1000;
                                            return result % 1 === 0 ? result + 'k' : result.toFixed(1) + 'k';
                                        }
                                        return number;
                                    }

                                    function initFlatpickrCalendar() {
                                        if ($('#calendar').length) {
                                            if (calendarInstance) calendarInstance.destroy();

                                            calendarInstance = flatpickr("#calendar", {
                                                inline: true,
                                                mode: "range",
                                                minDate: minDate,
                                                disable: blockedDates,
                                                disableMobile: true,
                                                position: "auto center",
                                                showMonths: window.innerWidth >= 790 ? 2 : 1, // responsive setting
                                                dateFormat: "Y-m-d",

                                                onDayCreate: function (dObj, dStr, fp, dayElem) {
                                                    const date = flatpickr.formatDate(dayElem.dateObj, "Y-m-d");
                                                    let dayNum = dayElem.dateObj.getDay();
                                                    dayNum = dayNum === 0 ? 7 : dayNum;

                                                    const today = new Date();
                                                    today.setHours(0, 0, 0, 0);
                                                    const dateObj = dayElem.dateObj;
                                                    dateObj.setHours(0, 0, 0, 0);

                                                    if (dateObj < today) return;

                                                    let priceInfo = priceData[date];
                                                    if (!priceInfo && dayNumberMap.hasOwnProperty(dayNum)) {
                                                        priceInfo = dayNumberMap[dayNum];
                                                    }

                                                    if (priceInfo) {
                                                        const price = priceInfo.price;
                                                        const formattedPrice = toKFormat(price);
                                                        const isHotdeal = priceInfo.isHotdeal;
                                                        const priceWrapper = document.createElement("span");
                                                        priceWrapper.className = "flatpickr-price";

                                                        if (isHotdeal) {
                                                            priceWrapper.style.color = "red";
                                                            priceWrapper.innerText = `% IDR ${formattedPrice}`;
                                                        } else {
                                                            priceWrapper.innerText = `IDR ${formattedPrice}`;
                                                        }

                                                        dayElem.appendChild(priceWrapper);
                                                    }
                                                },

                                                onChange: function (selectedDates) {
                                                    const [checkin, checkout] = selectedDates;
                                                    let totalPrice = 0;
                                                    const qty = parseInt($("input[name='qty']").val()) || 1;

                                                    if (checkin) {
                                                        document.getElementById("checkin").value = flatpickr.formatDate(checkin, "d M Y");
                                                    }
                                                    if (checkout) {
                                                        document.getElementById("checkout").value = flatpickr.formatDate(checkout, "d M Y");
                                                        $('#tanggal2').val(flatpickr.formatDate(checkout, "Y-m-d"));
                                                    }

                                                    if (selectedDates.length === 2) {
                                                        const start = flatpickr.formatDate(selectedDates[0], "d M Y");
                                                        const end = flatpickr.formatDate(selectedDates[1], "d M Y");
                                                        const diff = Math.ceil((selectedDates[1] - selectedDates[0]) / 86400000);

                                                        document.getElementById("night-info").innerHTML = `
                                                            <h2>${diff} night${diff > 1 ? 's' : ''}</h2>
                                                            <p>${start} - ${end}</p>
                                                            <input id="night" name="night" type="hidden" value="${diff}">
                                                            <input name="tanggal" type="hidden" value="${tanggal}">
                                                            <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                            <input type="hidden" name="id_product" value="${y.id_product}" />
                                                            <input type="hidden" name="module" value="${moduleId}"/>
                                                            <input type="hidden" name="subtotal" id="subtotal"/>
                                                        `;

                                                        const current = new Date(selectedDates[0]);
                                                        while (current < selectedDates[1]) {
                                                            const key = flatpickr.formatDate(current, "Y-m-d");
                                                            const day = current.getDay() === 0 ? 7 : current.getDay();

                                                            let priceItem = priceData[key];
                                                            if (!priceItem && dayNumberMap.hasOwnProperty(day)) {
                                                                priceItem = dayNumberMap[day];
                                                            }

                                                            if (priceItem && !isNaN(priceItem.price)) {
                                                                totalPrice += priceItem.price;
                                                            }

                                                            current.setDate(current.getDate() + 1);
                                                        }

                                                        $(".qty").attr("data-baseprice", totalPrice);
                                                        totalPrice *= qty;

                                                        let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                                        let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                                        let converted = totalPrice * currencyRate;
                                                        let formatted = formatCurrency(converted, selectedCurrency);

                                                        $(".total_harga").text(formatted);
                                                        $(".total_harga").attr("data-baseprice", totalPrice);
                                                        document.getElementById("subtotal").value = totalPrice;
                                                    }
                                                }
                                            });

                                            // Set default range (check-in/check-out) from 'tanggal'
                                            const tanggalAwal = new Date(tanggal);
                                            let tanggalAkhir;

                                            if (tanggal2) {
                                                tanggalAkhir = new Date(tanggal2);
                                            } else {
                                                tanggalAkhir = new Date(tanggalAwal);
                                                tanggalAkhir.setDate(tanggalAkhir.getDate() + 1);
                                            }

                                            const options = { day: '2-digit', month: 'short', year: 'numeric' };
                                            const checkinStr = tanggalAwal.toLocaleDateString('en-GB', options).replace(/ /g, ' ');
                                            const checkoutStr = tanggalAkhir.toLocaleDateString('en-GB', options).replace(/ /g, ' ');

                                            $('#checkin').val(checkinStr);
                                            $('#checkout').val(checkoutStr);

                                            if (typeof calendarInstance.setDate === 'function') {
                                                calendarInstance.setDate([tanggalAwal, tanggalAkhir]);

                                                let totalPrice = 0;
                                                const current = new Date(tanggalAwal);
                                                while (current < tanggalAkhir) {
                                                    const key = flatpickr.formatDate(current, "Y-m-d");
                                                    const day = current.getDay() === 0 ? 7 : current.getDay();

                                                    let priceItem = priceData[key];
                                                    if (!priceItem && dayNumberMap.hasOwnProperty(day)) {
                                                        priceItem = dayNumberMap[day];
                                                    }

                                                    if (priceItem && !isNaN(priceItem.price)) {
                                                        totalPrice += priceItem.price;
                                                    }

                                                    current.setDate(current.getDate() + 1);
                                                }

                                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                                let converted = totalPrice * currencyRate;
                                                let formatted = formatCurrency(converted, selectedCurrency);

                                                $(".total_harga").text(formatted);
                                                $(".total_harga").attr("data-baseprice", totalPrice);
                                                $(".qty").attr("data-baseprice", totalPrice);
                                                $("#subtotal").val(totalPrice);
                                            }

                                            // Update night-info
                                            const diffInTime = tanggalAkhir.getTime() - tanggalAwal.getTime();
                                            const diffInDays = Math.ceil(diffInTime / (1000 * 3600 * 24));

                                            $('#night-info').html(`
                                                <h2>${diffInDays} night${diffInDays > 1 ? 's' : ''}</h2>
                                                <p>${checkinStr} - ${checkoutStr}</p>
                                                <input id="night" name="night" type="hidden" value="${diffInDays}">
                                                <input name="tanggal" type="hidden" value="${tanggal}">
                                                <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                <input type="hidden" name="id_product" value="${y.id_product}" />
                                                <input type="hidden" name="module" value="${moduleId}"/>
                                                <input type="hidden" name="subtotal" id="subtotal"/>
                                            `);
                                        }
                                    }

                                    // Inisialisasi awal
                                    setTimeout(() => {
                                        initFlatpickrCalendar();
                                    }, 50);

                                    // Optional: Reinitialize calendar saat window resize (debounced)
                                    let resizeTimer;
                                    window.addEventListener('resize', () => {
                                        clearTimeout(resizeTimer);
                                        resizeTimer = setTimeout(() => {
                                            initFlatpickrCalendar();
                                        }, 200);
                                    });



                                    $(document).on("click", "#clear-dates", function () {
                                        if (calendar && typeof calendar.clear === "function") {
                                            calendar.clear();
                                        }
                                        $("#checkin").val("");
                                        $("#checkout").val("");


                                        $("#night-info").html(`
                                            <h2>Select dates</h2>
                                            <p>Add your travel dates for exact pricing</p>
                                            <input id="night" name="night" type="hidden">
                                            <input name="tanggal" type="hidden" value="${tanggal}">
                                            <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                            <input type="hidden" name="id_product" value="${y.id_product}" />
                                            <input type="hidden" name="module" value="${moduleId}"/>
                                            <input type="hidden" name="subtotal" id="subtotal"/>`);

                                        $(".total_harga").text("0");
                                        $(".total_harga").attr("data-baseprice", 0);
                                    });

                                } else {
                                    swal({
                                        title: "Error",
                                        text: "Unable to determine booking restrictions.",
                                        icon: "error",
                                        button: "OK",
                                    });
                                }
                            } else { // Kalau ada module lain
                                html += '<div style="padding-left:30px">' +
                                    '<a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">' +
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-whatsapp" viewBox="0 0 16 16">' +
                                    '<path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217-.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008-.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415 2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482 1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>' +
                                    '</svg>' +
                                    '<span style="margin-left: 8px;">Book via WhatsApp</span>' +
                                    '</a>' +
                                    '</div>';
                            }
                        });
                    }
                });

                //end block module
                html += `</div></div>`;

                html += '</form><div class="card-body mt-1">' +
                    '</div>' +
                    '<div class="row align-items-center justify-content-between px-4">' +
                    '<div class="col">' +
                    '<div class="d-flex align-items-center" style="gap: 5px;">' +
                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-calendar-check" viewBox="0 0 16 16">' +
                    '<path d="M10.854 7.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 9.793l2.646-2.647a.5.5 0 0 1 .708 0"/>' +
                    '<path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"/>' +
                    '</svg>' +
                    '<span class="poppins-bold cancel-before">Cancel before <span id="tanggalDisplay2">' + formattedDate2 +
                    '</span>, <span id="selectedTime"></span> for a full refund</span></span>' +
                    '</div>' +
                    '</div>' +
                    // '<div class="col">' +
                    // '<div class="d-flex align-items-center justify-content-end" style="gap: 5px;">' +
                    //     '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="rgba(0,0,0,0.5)" class="bi bi-cash-coin" viewBox="0 0 16 16">' +
                    //     '<path fill-rule="evenodd" d="M11 15a4 4 0 1 0 0-8 4 4 0 0 0 0 8m5-4a5 5 0 1 1-10 0 5 5 0 0 1 10 0"/>' +
                    //     '<path d="M9.438 11.944c.047.596.518 1.06 1.363 1.116v.44h.375v-.443c.875-.061 1.386-.529 1.386-1.207 0-.618-.39-.936-1.09-1.1l-.296-.07v-1.2c.376.043.614.248.671.532h.658c-.047-.575-.54-1.024-1.329-1.073V8.5h-.375v.45c-.747.073-1.255.522-1.255 1.158 0 .562.378.92 1.007 1.066l.248.061v1.272c-.384-.058-.639-.27-.696-.563h-.668zm1.36-1.354c-.369-.085-.569-.26-.569-.522 0-.294.216-.514.572-.578v1.1zm.432.746c.449.104.655.272.655.569 0 .339-.257.571-.709.614v-1.195z"/>' +
                    //     '<path d="M1 0a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h4.083q.088-.517.258-1H3a2 2 0 0 0-2-2V3a2 2 0 0 0 2-2h10a2 2 0 0 0 2 2v3.528c.38.34.717.728 1 1.154V1a1 1 0 0 0-1-1z"/>' +
                    //     '<path d="M9.998 5.083 10 5a2 2 0 1 0-3.132 1.65 6 6 0 0 1 3.13-1.567"/>' +
                    //     '</svg>' +
                    //     '<div>' +
                    //         '<h6 class="text-dark mb-0">Price Breakdown</h6>' +
                    //         '<p class="text-secondary mb-0">2 Persons x IDR 300.000</p>' +
                    //     '</div>' +
                    // '</div>' +
                    // '</div>' +
                    '</div>' +
                    '<div class="card-body">' +
                    '</div>' +
                    '<div class="container pt-3 justify-content-center" style="background-color: #F5F5F5; border-radius: 0px 0px 16px 16px;">' +
                    '<div class="row">' +
                    '<div class="col-lg-6 col-md-6 col-sm-12"><h3>Total</h3>' +
                    '<div class="">' +
                    '<h3 style="font-weight: bold;"><span class="activecurrency">IDR </span> <span class="total_harga" style="font-weight:bold;">0</span></h3>' +
                    '</div>' +
                    '<p style="font-size: 10px;">All taxes and fees included</p></div>' +
                    '<div class="col-lg-6 col-md-6 col-sm-6 mt-3">' +
                    '<div class="d-flex justify-content-end align-items-center"><button class="book mr-4 mb-2 btn-book" id="booknow">Book Now</button>' +
                    '<button class="book mr-4 mb-2 btn-cart" id="addtocart">Add to Cart</button></div></div>' +
                    '</div>' +
                    '</div>' +
                    '</div>'; // Closing accordion

                $(document).on('change', '.timeselection', function () {
                    let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                    let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                    var selectedTime = $(this).val();
                    let qtyInput = $(this).closest('.col-lg-2').next().find('.qty');
                    let selectedOption = $(this).find(':selected');
                    let harga = parseFloat(selectedOption.data('harga')) || 0; // Ambil harga dari option yang dipilih
                    let diskon = parseFloat(selectedOption.data('hargadiskon'));
                    let availability = parseFloat(selectedOption.data('availability'));
                    let breakdown = selectedOption.data('breakdown') || [];

                    console.log('Harga diperbarui:', harga);

                    // Update tampilan waktu yang dipilih
                    $('#selectedTime').text(selectedTime !== '0' ? selectedTime : '');

                    // Ambil qty saat ini (tidak di-reset)
                    let qty = parseInt(qtyInput.val()) || 0;

                    // Update harga di input qty
                    qtyInput.data('harga', harga);
                    qtyInput.attr('data-harga', harga);
                    qtyInput.data('availability', availability);
                    qtyInput.attr('data-availability', availability);
                    qtyInput.data('breakdown', breakdown);
                    qtyInput.attr('data-breakdown', JSON.stringify(breakdown));

                    if (diskon > 0) {
                        qtyInput.data('hotdeals', diskon);
                        qtyInput.attr('data-hotdeals', diskon);
                    } else {
                        qtyInput.data('hotdeals', 0);
                        qtyInput.attr('data-hotdeals', 0);
                    }
                    // Hitung total harga baru berdasarkan qty
                    let totalHarga = 0;
                    if (diskon > 0) {
                        totalHarga = diskon * qty;

                    } else {
                        totalHarga = harga * qty;
                    }
                    let final_total = totalHarga * currencyRate;

                    let formattedTotal = formatCurrency(final_total, selectedCurrency);

                    // Update total harga di UI
                    $(".total_harga").text(formattedTotal);
                    $(".total_harga").attr('data-baseprice', totalHarga);

                }).on('change', '.session-select', function () {
                    let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                    let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                    let selectedOption = $(this).find(':selected');
                    let id = $(this).data('session-id');
                    let price = parseFloat(selectedOption.data('harga'));
                    let final_price = price * currencyRate;
                    let formattedPrice = formatCurrency(final_price, selectedCurrency);
                    let defaultPrice = $(this).data('defaultprice');
                    let final_defaultprice = defaultPrice * currencyRate;
                    let formatteddefaultPrice = formatCurrency(final_defaultprice, selectedCurrency);
                    let hargaDiskon = parseFloat(selectedOption.data('hargadiskon'));
                    let final_diskon = hargaDiskon * currencyRate;
                    let formattedDiskon = formatCurrency(final_diskon, selectedCurrency);
                    let qtyInput = $(this).closest('.col-lg-2').next().find('.qty');

                    if (price == 0) {
                        $(this).closest('.rate_option').find('.priceDisplay-' + id).text(formatteddefaultPrice);
                        return false;
                    }

                    if (hargaDiskon > 0) {
                        $(this).closest('.rate_option').find('.priceDisplay-discounted-' + id).text(formattedDiskon);
                        qtyInput.attr('data-hotdeals', hargaDiskon);
                    }

                    // Temukan priceDisplay yang sesuai dalam rate_option yang sama
                    $(this).closest('.rate_option').find('.priceDisplay-' + id).text(formattedPrice);
                });



                $('#show_result').html(html);



                // updateTotalPrice();
                // updateRatePrices();
                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                updateTotalHarga(currencyRate, selectedCurrency);

            }
        });

    }).on('change', '.select_rate', function (e) {
        let id = $(this).val();
        let idp = $(this).data('idproduct');
        let tanggal = $(this).data('tanggal');
        let tanggal2 = $(this).data('tanggal2');
        let html = '';
        let calendar = null;

        $(".total_harga").text("0");
        $(".total_harga").attr("data-baseprice", 0);
        $.ajax({
            url: BASEURL + '/product/loadratelist/',
            data: { 'id': id, 'idp': idp },
            method: 'POST',
            beforeSend: function () {
                $('#rate_list').html('<i class="fa fa-spin fa-spinner"></i> Loading..');
            },
            success: function (r) {
                let dt = JSON.parse(r);
                let y = dt[0];
                console.log(dt);
                $.each(dt, function (x, yy) {
                    const startDate = yy.start_date ? new Date(yy.start_date).toISOString().split('T')[0] : null;
                    const endDate = yy.end_date ? new Date(yy.end_date).toISOString().split('T')[0] : null;

                    console.log('tanggal : ', tanggal);
                    console.log('start_date : ', startDate);
                    console.log('end_date : ', endDate);

                    // Cek start date & end date
                    if ((startDate && tanggal < startDate) || (endDate && tanggal > endDate)) {
                        html += `
                        <div style="padding-left:30px">
                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                </svg>
                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                            </a>
                        </div>`;
                        $('#rate_list').html(html);
                        return false;
                    }

                    if (yy.availability_data && yy.availability_data.length > 0) {
                        let moduleData = {};

                        // Kelompokkan data berdasarkan module_id
                        $.each(yy.availability_data, function (oo, pp) {
                            if (pp.rate_status == 1) {
                                return true; // Skip data dengan rate_status = 1
                            }

                            if (!moduleData[pp.module_id]) {
                                moduleData[pp.module_id] = [];
                            }
                            moduleData[pp.module_id].push(pp);
                        });


                        let selectedDate = new Date(tanggal);
                        let selectedDayNumber = selectedDate.getDay(); // 0 = Minggu, ..., 6 = Sabtu

                        $.each(moduleData, function (moduleId, data) {
                            if (moduleId == '10') { // Session Time
                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        const bookingWindowEnd = parseInt(yy.booking_window_end || 0);
                                        const now = new Date();
                                        const selectedDate = new Date(tanggal); 
                                        const todayDate = new Date(now.toISOString().split('T')[0]);

                                        const sessionDateTime = new Date(`${tanggal}T${pp.time_available}`);

                                        if (selectedDate.getTime() === todayDate.getTime()) {
                                            const minBookingTime = new Date(now.getTime() + bookingWindowEnd * 60000);

                                            if (sessionDateTime > minBookingTime) {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: pp.time_available.substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability:pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                            }
                                        } else {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: pp.time_available.substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability:pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                        }
                                    }
                                });

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-rate_opt-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;

                                    if (!yy.discounted_price) {
                                        html += `
                                                        <div style="display: flex; align-items: center;" 
                                                            class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                            <span class="activecurrency">IDR</span> 
                                                            <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                            ${
                                                                yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                    ? `
                                                                    <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                        <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                        <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                    </div>`
                                                                    : ''
                                                            }
                                                        </div>`;
                                    } else {
                                        html += `
                                                        <div style="color:red;" 
                                                            class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                            <s style="text-decoration: line-through;color: red;">
                                                                <span class="activecurrency">IDR</span> 
                                                                <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                            </s>
                                                            <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                                <span class="activecurrency">IDR</span> 
                                                                <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.availability_data[0].discounted_price)}</span>/${yy.rate_option_unit}
                                                                ${
                                                                    yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                        ? `
                                                                        <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                            <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                            <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                        </div>`
                                                                        : ''
                                                                }
                                                            </div>
                                                        </div>`;
                                    }

                                    html += `
                                                <div style="isplay: flex; align-items: center;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3 py-3">
                                                    <select class="form-control rounded-5 timeselection session-select" name="timeselection" data-session-id="${yy.id}" data-defaultPrice="${harga}">
                                                        <option value="0" data-harga="0">Sessions</option>`;

                                    $.each(timeList, function (m, item) {
                                        html += `<option class="timeSelection" value="${item.time}" data-harga="${parseFloat(item.price)}" data-hargadiskon="${parseFloat(item.discounted_price)}" data-availability="${item.availability}" data-breakdown='${JSON.stringify(item.breakdown || [])}'>${item.time}</option>`;
                                    });

                                    html += `</select></div>`;

                                    html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <input min="${yy.min_qty}" max="${yy.max_qty}" name="qty" 
                                                        class="form-control rounded-5 qty" type="number" 
                                                        placeholder="Qty" value="0" 
                                                        data-hotdeals="${yy.discounted_price}" 
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"
                                                        data-harga="${harga}"/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                    html += `</div></div>`;
                                }
                            } else if (moduleId == '9') { // Rental
                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        hasValidSession = true; // Set flag bahwa ada sesi valid
                                        timeList.push({
                                            time: pp.time_available ? pp.time_available.substring(0, 5) : '',
                                            price: pp.publish_price,
                                            discounted_price: pp.discounted_price,
                                            availability: pp.id,
                                            breakdown: pp.breakdown
                                        });
                                    }
                                });
                                // console.log(timeList);

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                let daysDiff = 0;
                                if (tanggal && tanggal2) {
                                    const start = new Date(tanggal);
                                    const end = new Date(tanggal2);
                                    daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
                                }
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;

                                    if (!yy.discounted_price) {
                                        html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                    <span class="activecurrency">IDR</span> 
                                                    <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    ${
                                                        yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                            ? `
                                                            <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                            </div>`
                                                            : ''
                                                    }
                                                </div>`;
                                    } else {
                                        html += `
                                                <div style="color:red;" 
                                                    class="col-lg-3 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                    <s style="text-decoration: line-through;color: red;">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                    </s>
                                                    <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                        <span class="activecurrency">IDR</span> 
                                                        <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.discounted_price)}</span>/${yy.rate_option_unit}
                                                        ${
                                                        yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                            ? `
                                                            <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                            </div>`
                                                            : ''
                                                    }
                                                    </div>
                                                </div>`;
                                    }

                                    html += `
                                                <div style="display: flex; align-items: center;" class="col-lg-2 col-md-2 col-sm-12 g-mt-3"> Qty
                                                    <input name="qty" class="form-control rounded-5 qty" type="number" placeholder="Qty" value="0" 
                                                    data-hotdeals="${yy.discounted_price}" 
                                                    data-module="${moduleId}"
                                                    data-harga="${harga}"
                                                    data-stock="${yy.stock}"
                                                    data-availability="${yy.availability_data[0].id}"
                                                    data-breakdown='${JSON.stringify(yy.availability_data[0]?.breakdown || [])}'/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                    html += `
                                                <div style="display: flex; align-items: center;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3"> Day(s)
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <input name="days" min="${yy.min_qty}" max="${yy.max_qty}"
                                                        class="form-control rounded-5 days" type="number" 
                                                        placeholder="day(s)" value="${daysDiff}"  
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"/>
                                                </div>`;

                                }

                            } else if (moduleId == '11') { // Sim Card
                                let timeList = [];
                                let isClosed = false;
                                let hasValidSession = false; // Cek apakah ada sesi yang valid

                                $.each(data, function (i, pp) {
                                    if (pp.date_available == tanggal && pp.rate_status == 1) {
                                        isClosed = true;
                                        return false; //Stop loop
                                    }
                                    //cek day number
                                    let isMatchingDay = pp.day_number == null || parseInt(pp.day_number) === selectedDayNumber;
                                    let isMatchingDate = pp.date_available == null || pp.date_available === tanggal;

                                    if (isMatchingDay && isMatchingDate && pp.rate_status != 1) {
                                        const bookingWindowEnd = parseInt(yy.booking_window_end || 0);
                                        const now = new Date();
                                        const selectedDate = new Date(tanggal); 
                                        const todayDate = new Date(now.toISOString().split('T')[0]);

                                        const sessionDateTime = new Date(`${tanggal}T${pp.time_available}`);

                                        if (selectedDate.getTime() === todayDate.getTime()) {
                                            const minBookingTime = new Date(now.getTime() + bookingWindowEnd * 60000);

                                            if (sessionDateTime > minBookingTime) {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: (pp.time_available || '').substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability:pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                            }
                                        } else {
                                            hasValidSession = true;
                                            timeList.push({
                                                time: (pp.time_available || '').substring(0, 5),
                                                price: pp.publish_price,
                                                discounted_price: pp.discounted_price,
                                                availability:pp.id,
                                                breakdown: pp.breakdown || []
                                            });
                                        }
                                    }
                                });

                                // Jika ada date_available & rate_status = 1 (contohnya nyepi)
                                if (isClosed) {
                                    html += `
                                    <div style="padding-left:30px">
                                        <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                            class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                    l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                    l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                    m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                    c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                    c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                    -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                    -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                    2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                    1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                            </svg>
                                            <span style="margin-left: 8px;">Book via WhatsApp</span>
                                        </a>
                                    </div>`;
                                    return false; // Stop looping lebih lanjut
                                }

                                // Jika day number tidak sesuai
                                if (!hasValidSession) {
                                    html += `
                                        <div style="padding-left:30px">
                                            <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" 
                                                class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                                    class="bi bi-whatsapp" viewBox="0 0 16 16">
                                                    <path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16
                                                        l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872
                                                        l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5
                                                        m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785
                                                        c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192
                                                        c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217
                                                        -.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008
                                                        -.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415
                                                        2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482
                                                        1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>
                                                </svg>
                                                <span style="margin-left: 8px;">Book via WhatsApp</span>
                                            </a>
                                        </div>`;
                                    return false;
                                }

                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                let harga = parseFloat(yy.availability_data[0].publish_price);
                                let final_harga = harga * currencyRate;
                                let formattedHarga = formatCurrency(final_harga, selectedCurrency);
                                if (timeList.length > 0) {
                                    let imageHTML = '';
                                    if (yy.image && yy.image.length > 0) {
                                        const galleryId = `gallery-rate_opt-${yy.id}`;
                                        const thumbnail = yy.image[0];
                                        imageHTML += `
                                            <a href="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                            class="fancybox" 
                                            data-fancybox="${galleryId}" 
                                            style="margin-right: 10px;">
                                                <img src="${PIXURL}/uploads/products/${y.id_product}/rate_opt/${yy.id}/${thumbnail}" 
                                                    alt="Thumbnail" 
                                                    style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                            </a>`;

                                        for (let i = 1; i < yy.image.length; i++) {
                                            imageHTML += `
                                                <a href="${PIXURL}/uploads/products/${y.id_product}/${yy.image[i]}" 
                                                class="fancybox" 
                                                data-fancybox="${galleryId}" 
                                                style="display: none;"></a>`;
                                        }
                                    }

                                    html += `
                                        <label style="display: flex; align-items: center;" 
                                            class="col-lg-5 col-md-5 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3">
                                            ${imageHTML}
                                            ${yy.rate_option_name}
                                        </label>`;

                                    if (!yy.discounted_price) {
                                        html += `
                                                        <div style="display: flex; align-items: center;" 
                                                            class="col-lg-4 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 py-3 rate-price" data-baseprice="${harga}">
                                                            <span class="activecurrency">IDR</span> 
                                                            <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                            ${
                                                                yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                    ? `
                                                                    <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                        <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                        <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                    </div>`
                                                                    : ''
                                                            }
                                                        </div>`;
                                    } else {
                                        html += `
                                                        <div style="color:red;" 
                                                            class="col-lg-4 col-md-3 col-sm-12 col-form-label g-mb-0 g-mt-3 rate-price data-baseprice="${harga}" py-3">
                                                            <s style="text-decoration: line-through;color: red;">
                                                                <span class="activecurrency">IDR</span> 
                                                                <span class="converted-price priceDisplay-${yy.id}">${formattedHarga}</span>/${yy.rate_option_unit}
                                                            </s>
                                                            <div style="color:gray;" class="col-form-label g-mb-0 g-mt-3 rate-price" data-baseprice="${yy.discounted_price}">
                                                                <span class="activecurrency">IDR</span> 
                                                                <span id="priceDisplay" class="converted-price priceDisplay-discounted-${yy.id}">${format(yy.availability_data[0].discounted_price)}</span>/${yy.rate_option_unit}
                                                                ${
                                                                    yy.rate_option_text && yy.rate_option_text.trim() !== ''
                                                                        ? `
                                                                        <div class="rateopt-tooltip-wrapper" style="margin-left: 6px;">
                                                                            <i class="bi bi-info-circle-fill rateopt-icon"></i>
                                                                            <div class="rateopt-tooltip">${yy.rate_option_text}</div>
                                                                        </div>`
                                                                        : ''
                                                                }
                                                            </div>
                                                        </div>`;
                                    }

                                    html += `
                                                <div style="display: flex; align-items: center; gap: 0.5rem;" 
                                                    class="col-lg-2 col-md-2 col-sm-12 g-mt-3">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="module" value="${moduleId}" />
                                                    <label style="margin: 0; white-space: nowrap;">Qty</label>
                                                    <input min="${yy.min_qty}" max="${yy.max_qty}" name="qty" 
                                                        class="form-control rounded-5 qty" type="number" 
                                                        placeholder="Qty" value="0" 
                                                        data-hotdeals="${yy.discounted_price}" 
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-stock="${yy.stock}"
                                                        data-module="${moduleId}"
                                                        data-harga="${harga}"
                                                        data-availability="${timeList[0].availability}"
                                                        data-breakdown='${JSON.stringify(timeList[0].breakdown)}'/>
                                                    <input type="hidden" class="sub_total" name="sub_total" value="0" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                </div>`;
                                    html += `</div></div>`;
                                }
                            } else if (moduleId == '1' || moduleId == '2') {
                                html += `<div class="rate_option" style="max-width: 600px; margin-left: 1.5rem; margin-bottom: 3rem;">
                                    <div id="rate_list" class="form-group row" style="width: 100%; height : auto">  
                                        <div class="calendar-wrapper" style="padding: 20px; border-radius: 20px; border: none; width: 100%;">
                                            <div class="calendar-header" style="margin-bottom: 20px;">
                                                <span id="night-info">
                                                    <h2 style="margin: 0 0 5px;">Select dates</h2>
                                                    <p style="margin: 0 0 20px 0; color: #666;">Add your travel dates for exact pricing</p>
                                                    <input id="night" name="night" type="hidden">
                                                    <input name="tanggal" type="hidden" value="${tanggal}">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                    <input type="hidden" name="module" value="${moduleId}"/>
                                                    <input type="hidden" name="subtotal" id="subtotal"/>
                                                </span>
                                                <div class="calendar-inputs" style="display: flex; flex-wrap: wrap; align-items: flex-end; gap: 15px; margin-bottom: 20px;">
                                                    <div class="checkin" style="flex: 1;">
                                                        <label>CHECK-IN</label>
                                                        <input id="checkin" name="checkin" class="date-input" placeholder="Add date" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                    </div>
                                                    <div class="checkout" style="flex: 1;">
                                                        <label>CHECKOUT</label>
                                                        <input id="checkout" name="checkout" class="date-input" placeholder="Add date" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                    </div>
                                                    <div class="checkout" style="flex: 1;">
                                                        <label>Room(s)</label>
                                                        <input type="number" class="qty" name="qty" 
                                                        value="1"
                                                        min="${yy.min_qty}" 
                                                        max="${yy.max_qty}"  
                                                        data-minqty="${yy.min_qty}" 
                                                        data-maxqty="${yy.max_qty}"
                                                        data-module="${moduleId}"
                                                        style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                                                    </div>
                                                    <button id="clear-dates" type="button" class="btn btn-danger" style="padding: 8px 12px; border-radius: 5px; cursor: pointer;">
                                                        <div class="d-flex align-items-center" style="gap: 5px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                                                <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                                                            </svg>
                                                            Clear dates
                                                        </div>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="select-dates-card">
                                                <div id="calendar" style="margin-top: 2rem;"></div>
                                            </div>

                                        </div>
                                    </div> `;
                                html += `</div></div>`;


                                let minDate = null;
                                if (dt.length > 0) {
                                    const bookingWindowEnd = parseInt(dt[0].booking_window_end);
                                    const daysNeeded = Math.ceil(bookingWindowEnd / 1440);
                                    const currentDate = new Date();

                                    if (daysNeeded > 1) {
                                        currentDate.setDate(currentDate.getDate() + (daysNeeded - 1));
                                    }

                                    minDate = currentDate.toISOString().split('T')[0];

                                    const blockedDates = dt[0].blocked_dates;

                                    // 🔁 Ambil priceData dari availability_data
                                    let priceData = {};
                                    let dayNumberMap = {};
                                    data.forEach(a => {
                                        if (a.date_available == null && a.day_number) {
                                            let dayNum = parseInt(a.day_number);
                                            const publish = parseFloat(a.publish_price);
                                            const discount = parseFloat(a.discounted_price);
                                            const isHotdeal = discount > 0 && discount < publish;
                                            const finalPrice = isHotdeal ? discount : publish;

                                            // Simpan berdasarkan day_number
                                            dayNumberMap[dayNum] = {
                                                price: finalPrice,
                                                isHotdeal: isHotdeal,
                                                original: publish
                                            };
                                        } else if (a.rate_status != 1) {
                                            const publish = parseFloat(a.publish_price);
                                            const discount = parseFloat(a.discounted_price);

                                            const isHotdeal = discount > 0 && discount < publish; // diskon harus > 0 dan lebih kecil dari harga publish
                                            const finalPrice = isHotdeal ? discount : publish;

                                            priceData[a.date_available] = {
                                                price: finalPrice,
                                                isHotdeal: isHotdeal,
                                                original: publish
                                            };
                                        }
                                    });

                                    function toKFormat(number) {
                                        if (number >= 1000) {
                                            let result = number / 1000;
                                            return result % 1 === 0 ? result + 'k' : result.toFixed(1) + 'k';
                                        }
                                        return number;
                                    }
                                    setTimeout(function () {
                                        if ($('#calendar').length) {
                                            calendar = flatpickr("#calendar", {
                                                inline: true,
                                                mode: "range",
                                                minDate: minDate,
                                                disable: blockedDates,
                                                disableMobile: true,
                                                position: "auto center",
                                                showMonths: 2,
                                                dateFormat: "Y-m-d",
                                                onDayCreate: function (dObj, dStr, fp, dayElem) {
                                                    const date = flatpickr.formatDate(dayElem.dateObj, "Y-m-d");
                                                    let dayNum = dayElem.dateObj.getDay();
                                                    dayNum = dayNum === 0 ? 7 : dayNum;

                                                    const today = new Date();
                                                    today.setHours(0, 0, 0, 0);
                                                    const dateObj = dayElem.dateObj;
                                                    dateObj.setHours(0, 0, 0, 0);

                                                    if (dateObj < today) {
                                                        return; // tidak menampilkan harga di hari yang sudah lewat
                                                    }

                                                    let priceInfo = priceData[date];

                                                    // Jika tidak ada data spesifik untuk tanggal itu, cek berdasarkan day_number
                                                    if (!priceInfo && dayNumberMap.hasOwnProperty(dayNum)) {
                                                        priceInfo = dayNumberMap[dayNum];
                                                    }

                                                    if (priceInfo) {
                                                        const price = priceInfo.price;
                                                        const formattedPrice = toKFormat(price);
                                                        const isHotdeal = priceInfo.isHotdeal;
                                                        let selectedCurrency = sessionStorage.getItem('selectedCurrency');
                                                        const priceWrapper = document.createElement("span");
                                                        priceWrapper.className = "flatpickr-price";

                                                        if (isHotdeal) {
                                                            priceWrapper.style.color = "red";
                                                            priceWrapper.innerText = `% IDR ${formattedPrice}`;
                                                        } else {
                                                            priceWrapper.innerText = `IDR ${formattedPrice}`;
                                                        }

                                                        dayElem.appendChild(priceWrapper);
                                                    }
                                                },
                                                onChange: function (selectedDates) {
                                                    const [checkin, checkout] = selectedDates;
                                                    let totalPrice = 0;
                                                    const qty = parseInt($("input[name='qty']").val()) || 1;
                                                    if (checkin) {
                                                        document.getElementById("checkin").value = flatpickr.formatDate(checkin, "d M Y");
                                                    }
                                                    if (checkout) {
                                                        document.getElementById("checkout").value = flatpickr.formatDate(checkout, "d M Y");
                                                    }


                                                    if (selectedDates.length === 2) {
                                                        const start = flatpickr.formatDate(selectedDates[0], "d M Y");
                                                        const end = flatpickr.formatDate(selectedDates[1], "d M Y");
                                                        const diff = Math.ceil((selectedDates[1] - selectedDates[0]) / 86400000);
                                                        document.getElementById("night-info").innerHTML = `<h2>${diff} night${diff > 1 ? 's' : ''}</h2>
                                                        <p>${start} - ${end}</p><input id="night" name="night" type="hidden"><input name="tanggal" type="hidden" value="${tanggal}"><input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                        <input type="hidden" name="id_product" value="${y.id_product}" /><input type="hidden" name="module" value="${moduleId}"/><input type="hidden" name="subtotal" id="subtotal"/>`;
                                                        document.getElementById("night").value = diff;
                                                        // $("#night-info").html(`
                                                        //     <h2>${diff} night${diff > 1 ? 's' : ''}</h2>
                                                        //     <p>${start} - ${end}</p>
                                                        //     <input type="hidden" name="night" value"${diff}"/>
                                                        // `);
                                                    }

                                                    // Hitung total harga dari rentang tanggal
                                                    if (selectedDates.length === 2) {
                                                        const startDate = selectedDates[0];
                                                        const endDate = selectedDates[1];
                                                        const current = new Date(startDate);

                                                        while (current < endDate) {
                                                            const key = flatpickr.formatDate(current, "Y-m-d");
                                                            const day = current.getDay() === 0 ? 7 : current.getDay(); // Minggu = 7

                                                            let priceItem = priceData[key];

                                                            if (!priceItem && dayNumberMap.hasOwnProperty(day)) {
                                                                priceItem = dayNumberMap[day]; // 🔁 fallback by day number
                                                            }

                                                            if (priceItem && !isNaN(priceItem.price)) {
                                                                totalPrice += priceItem.price;
                                                            }

                                                            current.setDate(current.getDate() + 1);
                                                        }

                                                        $(".qty").attr("data-baseprice", totalPrice);

                                                        totalPrice *= qty;
                                                        let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                                        let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                                        let converted = totalPrice * currencyRate;
                                                        let formatted = formatCurrency(converted, selectedCurrency);

                                                        // Tampilkan di elemen total
                                                        $(".total_harga").text(formatted);
                                                        $(".total_harga").attr("data-baseprice", totalPrice);
                                                        document.getElementById("subtotal").value = totalPrice;
                                                    }


                                                }


                                            });
                                            const tanggalAwal = new Date(tanggal);
                                            let tanggalAkhir;

                                            if (tanggal2) {
                                                tanggalAkhir = new Date(tanggal2);
                                            } else {
                                                tanggalAkhir = new Date(tanggalAwal);
                                                tanggalAkhir.setDate(tanggalAkhir.getDate() + 1);
                                            }

                                            const options = { day: '2-digit', month: 'short', year: 'numeric' };
                                            const checkinStr = tanggalAwal.toLocaleDateString('en-GB', options).replace(/ /g, ' ');
                                            const checkoutStr = tanggalAkhir.toLocaleDateString('en-GB', options).replace(/ /g, ' ');

                                            $('#checkin').val(checkinStr);
                                            $('#checkout').val(checkoutStr);

                                            // Tetapkan tanggal langsung ke calendar
                                            if (typeof calendar.setDate === 'function') {
                                                calendar.setDate([tanggalAwal, tanggalAkhir]);
                                                // Hitung total harga untuk range tanggal otomatis
                                                let totalPrice = 0;
                                                const current = new Date(tanggalAwal);
                                                while (current < tanggalAkhir) {
                                                    const key = flatpickr.formatDate(current, "Y-m-d");
                                                    const day = current.getDay() === 0 ? 7 : current.getDay(); // Minggu = 7

                                                    let priceItem = priceData[key];

                                                    if (!priceItem && dayNumberMap.hasOwnProperty(day)) {
                                                        priceItem = dayNumberMap[day]; // fallback ke day number jika tidak ada harga spesifik
                                                    }

                                                    if (priceItem && !isNaN(priceItem.price)) {
                                                        totalPrice += priceItem.price;
                                                    }

                                                    current.setDate(current.getDate() + 1);
                                                }


                                                // Konversi dan tampilkan total harga
                                                let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
                                                let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
                                                let converted = totalPrice * currencyRate;
                                                let formatted = formatCurrency(converted, selectedCurrency);

                                                // Update ke UI
                                                $(".total_harga").text(formatted);
                                                $(".total_harga").attr("data-baseprice", totalPrice);
                                                $(".qty").attr("data-baseprice", totalPrice);;

                                                $("#subtotal").val(totalPrice);

                                            }

                                            // Hitung dan tampilkan jumlah malam di #night-info
                                            const diffInTime = tanggalAkhir.getTime() - tanggalAwal.getTime();
                                            const diffInDays = Math.ceil(diffInTime / (1000 * 3600 * 24));

                                            const startFormatted = checkinStr;
                                            const endFormatted = checkoutStr;

                                            $('#night-info').html(`
                                                    <h2>${diffInDays} night${diffInDays > 1 ? 's' : ''}</h2>
                                                    <p>${startFormatted} - ${endFormatted}</p>
                                                    <input id="night" name="night" type="hidden" value="${diffInDays}">
                                                    <input name="tanggal" type="hidden" value="${tanggal}">
                                                    <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                                    <input type="hidden" name="id_product" value="${y.id_product}" />
                                                    <input type="hidden" name="module" value="${moduleId}"/>
                                                    <input type="hidden" name="subtotal" id="subtotal"/>
                                                `);

                                        }
                                    }, 50);

                                    // pada saat responsive tablet dan mobile calendar yang ditampilkan hanya 1 bulan
                                    const isMobile = window.innerWidth <= 768; // breakpoint responsive

                                    flatpickr("#calendar", {
                                        mode: "range",
                                        showMonths: isMobile ? 1 : 2, // tampilkan 1 bulan jika mobile
                                        inline: true,
                                        disableMobile: true, // paksa tampilkan versi desktop di mobile
                                    });


                                    $(document).on("click", "#clear-dates", function () {
                                        if (calendar && typeof calendar.clear === "function") {
                                            calendar.clear();
                                        }
                                        $("#checkin").val("");
                                        $("#checkout").val("");


                                        $("#night-info").html(`
                                            <h2>Select dates</h2>
                                            <p>Add your travel dates for exact pricing</p>
                                            <input id="night" name="night" type="hidden">
                                            <input name="tanggal" type="hidden" value="${tanggal}">
                                            <input type="hidden" name="id_rateopt" value="${yy.id}" />
                                            <input type="hidden" name="id_product" value="${y.id_product}" />
                                            <input type="hidden" name="module" value="${moduleId}"/>
                                            <input type="hidden" name="subtotal" id="subtotal"/>`);

                                        $(".total_harga").text("0");
                                        $(".total_harga").attr("data-baseprice", 0);
                                    });

                                } else {
                                    swal({
                                        title: "Error",
                                        text: "Unable to determine booking restrictions.",
                                        icon: "error",
                                        button: "OK",
                                    });
                                }
                            } else { // Kalau ada module lain
                                html += '<div style="padding-left:30px">' +
                                    '<a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" class="btn btn-success d-inline-flex align-items-center px-3 py-2" style="gap: 8px;">' +
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-whatsapp" viewBox="0 0 16 16">' +
                                    '<path d="M13.6 2.4A7.953 7.953 0 0 0 8 0a8 8 0 0 0-8 8 7.952 7.952 0 0 0 1.067 4.027L0 16l4.171-1.067A7.951 7.951 0 0 0 8 16a8 8 0 0 0 5.6-13.6M8 14.5a6.467 6.467 0 0 1-3.288-.872l-.236-.141-2.475.632.657-2.414-.153-.248A6.482 6.482 0 0 1 1.5 8a6.5 6.5 0 1 1 6.5 6.5m3.64-4.856c-.2-.1-1.182-.584-1.365-.65-.182-.066-.314-.1-.446.1s-.51.65-.626.785c-.115.134-.23.15-.43.05A5.274 5.274 0 0 1 7.9 8.868a3.018 3.018 0 0 1-.9-1.192c-.1-.168-.01-.303.075-.4.08-.08.18-.2.27-.3.088-.1.117-.168.18-.283.06-.116.03-.217-.015-.3-.045-.084-.445-1.075-.61-1.474-.16-.4-.325-.334-.445-.34-.115-.006-.247-.008-.38-.008a.732.732 0 0 0-.53.248c-.18.2-.7.68-.7 1.66s.72 1.927.82 2.065c.1.134 1.415 2.16 3.44 3.02.48.206.855.33 1.147.42.482.154.92.133 1.265.08.385-.057 1.182-.482 1.347-.948.167-.467.167-.867.117-.948s-.2-.134-.42-.234"/>' +
                                    '</svg>' +
                                    '<span style="margin-left: 8px;">Book via WhatsApp</span>' +
                                    '</a>' +
                                    '</div>';
                            }
                        });
                    }
                    $('#rate_list').html(html);
                });
            }
        });
    });

    // $(document).on('click', '.rate-option', function() {
    //     var selected = $(this);
    //     var harga = selected.data('price');

    //     // Update harga yang dipilih
    //     $('.hargaoption').html(harga);

    //     selected.siblings().removeClass('active');
    //     selected.addClass('active');

    //         $('.show_price').html('Rp ' + harga);  

    // });

    //tanggal 1
    $(document).on('change', '#tanggal', function () {
        var selectedDate = $(this).val();
        var formattedDate = formatDate(selectedDate); // Format tanggal baru

        $('#tanggalDisplay').html(formattedDate);
    });

    //tanggal 2
    $(document).on('change', '#tanggal', function () {
        var selectedDate = $(this).val();
        var formattedDate2 = formatDate2(selectedDate); // Hanya bulan dan tanggal

        $('#tanggalDisplay2').html(formattedDate2); // Update tampilan tanggal di bawah session time
    });

    //person
    $(document).on('change', '#person', function () {
        var person = $(this).val();

        $('#qty').html(person);
    });



    // Event listener untuk tombol time duration
    $(document).on('click', '.btn-duration', function () {
        var selectedTime = $(this).data('time');

        // Update tampilan dengan waktu yang dipilih
        $('.selected-time').html(selectedTime);
    });

    // Event listener untuk tombol book now
    $(document).on('click', '#booknow', function (e) {
        e.preventDefault();
        let frm = $('#rate_form');
        let data = serializeFormJSON(frm);
        let tanggal = $('#tanggal').val();
        let moduleId = parseInt(frm.find('input[name="module"]').val());
        console.log(moduleId);
        let x = 0;
        let y = 0;
        let z = 0;
        //convert to array
        data.qty = Array.isArray(data.qty) ? data.qty : [data.qty];
        data.timeselection = Array.isArray(data.timeselection) ? data.timeselection : [data.timeselection];
        data.id_rateopt = Array.isArray(data.id_rateopt) ? data.id_rateopt : [data.id_rateopt];
        data.id_product = Array.isArray(data.id_product) ? data.id_product : [data.id_product];
        //end convert to array
        $.each(data.qty, function (i, j) {
            console.log(i);
            if (j > 0) {
                x = x + 1; // Validate qty
                if (data.timeselection[i] !== '0' && data.timeselection[i]) { // Validate time selection for each item
                    y = y + 1;
                }
            }
        });
        if (moduleId == 10) {
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            } else {
                if (y == 0) {
                    swal({
                        title: "Missing Time Selection",
                        text: "Please choose Time Selection.",
                        icon: "warning",
                        button: "OK",
                    }).then(() => {
                        $('.timeselection').first().focus(); // Focus ke input time selection
                    });
                    return false;
                }
            }
        } else if (moduleId == 11){
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            }
        } else if (moduleId == 1 || moduleId == 2) {
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            }
        }

        let button = $(this);
        let buttonOffset = button.offset();
        let flyingElement = $('<div class="fly-to-cart">🛒</div>');
        $('body').append(flyingElement);

        flyingElement.css({
            top: buttonOffset.top,
            left: buttonOffset.left,
            position: 'absolute',
            fontSize: '24px'
        });

        let cartIcon = $('#cart-icon');
        let cartOffset = cartIcon.offset();

        let deltaX = 5;
        flyingElement.animate({
            top: cartOffset.top,
            left: cartOffset.left - deltaX,
        }, 1000, function () {
            flyingElement.remove();
        });

        $.ajax({
            url: BASEURL + "/cart/addtocart/",
            type: 'POST',
            data: { 'data': data, 'tanggal': tanggal },
            beforeSend: function () {
                $('#rate').prop('disabled', true);
            },
            success: function (r) {
                location.href = BASEURL + '/cart/';
            }
        });
    });

    // Event listener untuk tombol add to cart
    $(document).on('click', '#addtocart', function (e) {
        e.preventDefault();
        let frm = $('#rate_form');
        let data = serializeFormJSON(frm);
        let tanggal = $('#tanggal').val();
        let moduleId = parseInt(frm.find('input[name="module"]').val());
        console.log(data);
        let x = 0;
        let y = 0;
        let z = 0;
        //convert to array
        data.qty = Array.isArray(data.qty) ? data.qty : [data.qty];
        data.timeselection = Array.isArray(data.timeselection) ? data.timeselection : [data.timeselection];
        data.id_rateopt = Array.isArray(data.id_rateopt) ? data.id_rateopt : [data.id_rateopt];
        data.id_product = Array.isArray(data.id_product) ? data.id_product : [data.id_product];
        //end convert to array
        $.each(data.qty, function (i, j) {
            console.log(i);
            if (j > 0) {
                x = x + 1; // Validate qty
                if (data.timeselection[i] !== '0' && data.timeselection[i]) { // Validate time selection for each item
                    y = y + 1;
                }
            }
        });
        if (moduleId == 10) {
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            } else {
                if (y == 0) {
                    swal({
                        title: "Missing Time Selection",
                        text: "Please choose Time Selection.",
                        icon: "warning",
                        button: "OK",
                    }).then(() => {
                        $('.timeselection').first().focus(); // Focus ke input time selection
                    });
                    return false;
                }
            }
        } else if (moduleId == 1 || moduleId == 2) {
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            }
        } else if (moduleId == 11) {
            if (x == 0) {
                swal({
                    title: "Missing Quantity",
                    text: "Please fill quantity.",
                    icon: "warning",
                    button: "OK",
                }).then(() => {
                    $('.qty').first().focus(); // Focus ke input qty
                });
                return false;
            }
        } 

        let button = $(this);
        let buttonOffset = button.offset();
        let flyingElement = $('<div class="fly-to-cart">🛒</div>');
        $('body').append(flyingElement);

        flyingElement.css({
            top: buttonOffset.top,
            left: buttonOffset.left,
            position: 'absolute',
            fontSize: '24px'
        });

        let cartIcon = $('#cart-icon');
        let cartOffset = cartIcon.offset();

        let deltaX = 5;
        flyingElement.animate({
            top: cartOffset.top,
            left: cartOffset.left - deltaX,
        }, 1000, function () {
            flyingElement.remove();
        });

        $.ajax({
            url: BASEURL + "/cart/addtocart/",
            type: 'POST',
            data: { 'data': data, 'tanggal': tanggal },
            beforeSend: function () {
                $('#rate').prop('disabled', true);
            },
            success: function (r) {
                let dt = JSON.parse(r);
                $('#cartvalue').html('<span class="badge text-bg-danger">' + dt + '</span>');
            }
        });
    }).on('keyup', '.qty', function (e) {
        this.value = this.value.replace(/[^0-9]/g, 0);
    }).on('keyup change', '.qty', function (e) {
        let qty = parseInt($(this).val()) || 0;
        let minQty = parseInt($(this).data('minqty')) || 0;
        let maxQty = parseInt($(this).data('maxqty')) || 0;
        let moduleId = parseInt($(this).data('module')) || 0;

        // Jika min_qty dan max_qty = 0, abaikan logic
        if (minQty === 0 && maxQty === 0) {
            $(this).removeAttr('max').removeAttr('min').removeAttr('step');
        } else {
            // Jika min_qty == max_qty, hanya bisa input 0 atau nilai itu
            if (minQty === maxQty && minQty !== 0) {
                $(this).attr('min', 0);
                $(this).attr('max', maxQty);
                $(this).attr('step', maxQty);
                if (qty !== 0 && qty !== minQty) {
                    $(this).val(minQty);
                }
            } else {
                // Jika min_qty dan max_qty berbeda, 0 tetap bisa di pilih tapi batasi min-max
                $(this).attr('min', 0);
                $(this).attr('max', maxQty);
                $(this).attr('step', 1);
                if (qty < minQty && qty !== 0) {
                    $(this).val(minQty);
                } else if (qty > maxQty) {
                    $(this).val(maxQty);
                }
            }
        }

        // Hitung ulang total harga
        let grand_total = 0;
        let total_harga = 0;
        let total_harga_hotdeals = 0;
        $('.qty').each(function () {
            if (moduleId == 10) {
                let qty = parseInt($(this).val()) || 0;
                let harga = parseFloat($(this).data('harga')) || 0;
                let harga_hotdeals = parseFloat($(this).data('hotdeals')) || 0;
                let minQty = parseInt($(this).data('minqty')) || 0;
                let maxQty = parseInt($(this).data('maxqty')) || 0;
                let breakdown = $(this).data('breakdown') || [];
                let availability = $(this).data('availability') || [];

                let finalPrice = harga;

                // Cek breakdown kalau ada
                if (breakdown) {
                    if (typeof breakdown === "string") {
                        try { breakdown = JSON.parse(breakdown); } catch (e) { breakdown = []; }
                    }
                    if (Array.isArray(breakdown) && breakdown.length > 0) {
                        $.each(breakdown, function (i, bd) {
                            if (
                                bd.availability_id == availability &&
                                qty >= bd.qty_start && qty <= bd.qty_end
                            ) {
                                finalPrice = parseFloat(bd.publish_price);
                                return false; // stop loop
                            }
                        });
                    }
                }

                total_harga = qty * finalPrice;
                total_harga_hotdeals = qty * harga_hotdeals;

                // Jika min_qty dan max_qty = 0, biarkan input bebas tanpa batasan
                if (minQty === 0 && maxQty === 0) {
                    $(this).removeAttr('max').removeAttr('step');
                    $(this).attr('min', 0);
                } else {
                    // Jika min_qty == max_qty, hanya bisa input 0 atau nilai itu
                    if (minQty === maxQty && minQty !== 0) {
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', maxQty);
                        if ($(this).val() != 0 && $(this).val() != minQty) {
                            $(this).val(minQty);
                        }
                    } else {
                        // Jika min_qty dan max_qty berbeda, 0 tetap bisa di pilih tapi batasi min-max
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', 1);
                        if (qty < minQty && qty !== 0) {
                            $(this).val(minQty);
                        } else if (qty > maxQty) {
                            $(this).val(maxQty);
                        }
                    }
                }
            } else if (moduleId == 9) {
                let qty = parseInt($(this).val()) || 0;
                let $container = $(this).closest('.rate_option');
                let harga = parseFloat($(this).data('harga')) || 0;
                let harga_hotdeals = parseFloat($(this).data('hotdeals')) || 0;
                let days = parseInt($container.find('.days').val()) || 1;
                let stock = parseFloat($(this).data('stock')) || 0;
                let availability = $(this).data('availability') || [];
                let breakdown = $(this).data('breakdown') || [];
                let finalPrice = harga;

                if (breakdown) {
                    if (typeof breakdown === "string") {
                        try {
                            breakdown = JSON.parse(breakdown);
                            if (typeof breakdown === "string") {
                                breakdown = JSON.parse(breakdown);
                            }
                        } catch (e) {
                            breakdown = [];
                        }
                    }
                    if (Array.isArray(breakdown) && breakdown.length > 0) {
                        $.each(breakdown, function (i, bd) {
                            if (
                                bd.availability_id == availability &&
                                qty >= bd.qty_start && qty <= bd.qty_end
                            ) {
                                finalPrice = parseFloat(bd.publish_price);
                                return false; // stop loop
                            }
                        });
                    }
                }

                total_harga = qty * days * finalPrice;
                total_harga_hotdeals = qty * days * harga_hotdeals;

                $(this).attr({ min: 0, max: stock > 0 ? stock : '', step: 1 });
            } else if (moduleId == 11) {
                let qty = parseInt($(this).val()) || 0;
                let harga = parseFloat($(this).data('harga')) || 0;
                let harga_hotdeals = parseFloat($(this).data('hotdeals')) || 0;
                let minQty = parseInt($(this).data('minqty')) || 0;
                let maxQty = parseInt($(this).data('maxqty')) || 0;
                let breakdown = $(this).data('breakdown') || [];
                let availability = $(this).data('availability') || [];

                let finalPrice = harga;

                // Cek breakdown kalau ada
                if (breakdown) {
                    if (typeof breakdown === "string") {
                        try { breakdown = JSON.parse(breakdown); } catch (e) { breakdown = []; }
                    }
                    if (Array.isArray(breakdown) && breakdown.length > 0) {
                        $.each(breakdown, function (i, bd) {
                            if (
                                bd.availability_id == availability &&
                                qty >= bd.qty_start && qty <= bd.qty_end
                            ) {
                                finalPrice = parseFloat(bd.publish_price);
                                return false; // stop loop
                            }
                        });
                    }
                }

                total_harga = qty * finalPrice;
                total_harga_hotdeals = qty * harga_hotdeals;

                // Jika min_qty dan max_qty = 0, biarkan input bebas tanpa batasan
                if (minQty === 0 && maxQty === 0) {
                    $(this).removeAttr('max').removeAttr('step');
                    $(this).attr('min', 0);
                } else {
                    // Jika min_qty == max_qty, hanya bisa input 0 atau nilai itu
                    if (minQty === maxQty && minQty !== 0) {
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', maxQty);
                        if ($(this).val() != 0 && $(this).val() != minQty) {
                            $(this).val(minQty);
                        }
                    } else {
                        // Jika min_qty dan max_qty berbeda, 0 tetap bisa di pilih tapi batasi min-max
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', 1);
                        if (qty < minQty && qty !== 0) {
                            $(this).val(minQty);
                        } else if (qty > maxQty) {
                            $(this).val(maxQty);
                        }
                    }
                }
            } else if (moduleId == 1 || moduleId == 2) {
                const qty = parseInt($(this).val()) || 0;
                const base = parseFloat($(this).attr("data-baseprice")) || 0;
                let minQty = parseInt($(this).data('minqty')) || 0;
                let maxQty = parseInt($(this).data('maxqty')) || 0;

                total_harga = base * qty;

                // Jika min_qty dan max_qty = 0, biarkan input bebas tanpa batasan
                if (minQty === 0 && maxQty === 0) {
                    $(this).removeAttr('max').removeAttr('step');
                    $(this).attr('min', 0);
                } else {
                    // Jika min_qty == max_qty, hanya bisa input 0 atau nilai itu
                    if (minQty === maxQty && minQty !== 0) {
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', maxQty);
                        if ($(this).val() != 0 && $(this).val() != minQty) {
                            $(this).val(minQty);
                        }
                    } else {
                        // Jika min_qty dan max_qty berbeda, 0 tetap bisa di pilih tapi batasi min-max
                        $(this).attr('min', 0);
                        $(this).attr('max', maxQty);
                        $(this).attr('step', 1);
                        if (qty < minQty && qty !== 0) {
                            $(this).val(minQty);
                        } else if (qty > maxQty) {
                            $(this).val(maxQty);
                        }
                    }
                }
            }

            if (total_harga_hotdeals > 0) {
                $(this).parent().find('.sub_total').val(total_harga_hotdeals);
                grand_total += total_harga_hotdeals;
            } else {
                $(this).parent().find('.sub_total').val(total_harga);
                grand_total += total_harga;
            }
        });

        // Update data-baseprice agar bisa dikonversi ke currency lain
        $(".total_harga").attr("data-baseprice", grand_total);

        // Ambil rate dan currency dari sessionStorage
        let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
        let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;

        // Update total harga sesuai currency
        updateTotalHarga(currencyRate, selectedCurrency);
    }).on('keyup change', '.days', function (e) {
        let $container = $(this).closest('.rate_option');
        let moduleId = $container.find("input[name='module']").val();
        let days = parseInt($(this).val()) || 0;
        let minQty = parseInt($(this).data('minqty')) || 0;
        let maxQty = parseInt($(this).data('maxqty')) || 0;
        // let moduleId = parseInt($(this).data('module')) || 0;

        // Jika min_qty dan max_qty = 0, abaikan logic
        if (minQty === 0 && maxQty === 0) {
            $(this).removeAttr('max').removeAttr('min').removeAttr('step');
        } else {
            // Jika min_qty == max_qty, hanya bisa input 0 atau nilai itu
            if (minQty === maxQty && minQty !== 0) {
                $(this).attr('min', 0);
                $(this).attr('max', maxQty);
                $(this).attr('step', maxQty);
                if (days !== 0 && days !== minQty) {
                    $(this).val(minQty);
                }
            } else {
                // Jika min_qty dan max_qty berbeda, 0 tetap bisa di pilih tapi batasi min-max
                $(this).attr('min', 0);
                $(this).attr('max', maxQty);
                $(this).attr('step', 1);
                if (days < minQty && days !== 0) {
                    $(this).val(minQty);
                } else if (days > maxQty) {
                    $(this).val(maxQty);
                }
            }
        }

        // Hitung ulang total harga
        if (moduleId == '9') {
        // Ambil nilai qty dan days DARI container YANG SAMA
        let qty = parseInt($container.find('.qty').val()) || 0;
        let days = parseInt($container.find('.days').val()) || 0;

        let harga = parseFloat($container.find('.qty').data('hotdeals')) || parseFloat($container.find('.qty').data('harga')) || 0;

        // PERHITUNGAN FIX
        let total = qty * days * harga;

        let selectedCurrency = sessionStorage.getItem('selectedCurrency') || 'IDR';
        let currencyRate = parseFloat(sessionStorage.getItem('currencyRate')) || 1;
        let converted = total * currencyRate;
        let formatted = formatCurrency(converted, selectedCurrency);

        $(".total_harga").text(formatted);
        $(".total_harga").attr("data-baseprice", total);
        $container.find(".sub_total").val(total);
    }
    });

    // Format Date
    function formatDate(dateString) {
        const date = new Date(dateString);
        if (isNaN(date)) {
            return "Select Date"; // Kembalikan string error jika tidak valid
        }

        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        return date.toLocaleDateString('en-US', options);
    }

    // Format Date 2
    function formatDate2(dateString) {
        const date = new Date(dateString);
        if (isNaN(date)) {
            return "Select Date"; // Kembalikan string error jika tidak valid
        }

        const options = { month: 'long', day: 'numeric' };
        return date.toLocaleDateString('en-US', options);
    }

    // Format Time Slot
    function formatTimeSlot(startTime, interval) {
        let times = [];
        let currentTime = moment(startTime, "hh:mm A");
        let endTime = moment("10:00 PM", "hh:mm A");

        while (currentTime.isBefore(endTime)) {
            times.push(currentTime.format("hh:mm A"));
            currentTime.add(interval, 'minutes');
        }

        return times;
    }



});

function scrollToAvailability() {
    const target = document.getElementById("availabilityDetails");
    if (target) {
        target.scrollIntoView({ behavior: "smooth", block: "start" });
    }
}

var format = function (num) {
    var str = num.toString().replace("", ""), parts = false, output = [], i = 1, formatted = null;
    if (str.indexOf(",") > 0) {
        parts = str.split(",");
        str = parts[0];
    }
    str = str.split("").reverse();
    for (var j = 0, len = str.length; j < len; j++) {
        if (str[j] != ".") {
            output.push(str[j]);
            if (i % 3 == 0 && j < (len - 1)) {
                output.push(".");
            }
            i++;
        }
    }
    formatted = output.reverse().join("");
    return ("" + formatted + ((parts) ? "." + parts[1].substr(0, 2) : ""));
};

document.addEventListener("DOMContentLoaded", function () {
    var id = $('#searchavailability').data('idp');

    $.ajax({
        url: BASEURL + '/product/availability/',
        data: { 'id': id },
        method: 'POST',
        success: function (response) {
            let data = JSON.parse(response);

            let minDate = null;
            if (data.length > 0 && data[0].rates.length > 0) {
                const bookingWindowEnd = parseInt(data[0].rates[0].booking_window_end);
                const daysNeeded = Math.floor(bookingWindowEnd / 1440) + 1;
                const currentDate = new Date();

                if (daysNeeded > 1) {
                    currentDate.setDate(currentDate.getDate() + (daysNeeded - 1));
                }

                minDate = currentDate.toISOString().split('T')[0];

                const blockedDates = data[0].rates[0].blocked_dates;

                // ⬇️ Apply Flatpickr
                flatpickr("#tanggal", {
                    minDate: minDate,
                    disable: blockedDates,
                    disableMobile: true,
                    dateFormat: "Y-m-d"
                });
                flatpickr("#tanggal2", {
                    minDate: minDate,
                    disable: blockedDates,
                    disableMobile: true,
                    dateFormat: "Y-m-d"
                });
            } else {
                swal({
                    title: "Error",
                    text: "Unable to determine booking restrictions.",
                    icon: "error",
                    button: "OK",
                });
            }

        },
    });

    $('.btn-tab').on('click', function () {
    const tab = $(this).data('tab');

    // Remove 'active' dari semua nav-link dan tab-pane
    $('.nav-link').removeClass('active');
    $('.tab-pane').removeClass('active');

    // Tambah 'active' ke tab yang diklik dan konten yang sesuai
    $(this).addClass('active');
    $('#' + tab + '-content').addClass('active');
  });


});

function showMoreImages(reviewId) {
    const hiddenImages = document.querySelectorAll('.extra-image-' + reviewId);
    hiddenImages.forEach(img => img.classList.remove('d-none'));
    const btn = document.getElementById('viewMoreBtn-' + reviewId);
    if (btn) btn.remove();
  }

  // Optional: Toggle komentar panjang
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.read-more-toggle').forEach(btn => {
      btn.addEventListener('click', function () {
        const card = btn.closest('.card-review');
        card.querySelector('.review-short').classList.add('d-none');
        card.querySelector('.review-full').classList.remove('d-none');
        btn.remove();
      });
    });
  });

  Fancybox.bind("[data-fancybox]", {
  type: "image",
  animated: true,
  dragToClose: true,
});