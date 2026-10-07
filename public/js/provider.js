$(document).on('ready', function () {
    let mapPreview = null;
    let mapPopup = null;
    let routingControl = null;
    let userMarker = null;
    let watchId = null;
    let pathLine = null;
    let pathCoords = [];

    const previewDiv = document.getElementById('mapPreview');
    const openMapBtn = document.getElementById('openMap');
    const mapModal = document.getElementById('mapModal');
    const closeMapBtn = document.getElementById('closeMap');
    const startBtn = document.getElementById('startBtn');
    const exitBtn = document.getElementById('exitBtn');

    const latitude = parseFloat(previewDiv.getAttribute('data-latitude'));
    const longitude = parseFloat(previewDiv.getAttribute('data-longitude'));
    const provider = previewDiv.getAttribute('data-provider') || 'Provider';

    function initMapPreview() {
        if (!mapPreview) {
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
        } else {
            setTimeout(() => mapPreview.invalidateSize(), 200);
        }
    }

    function initMapPopup() {
        if (!mapPopup) {
            mapPopup = L.map('mapPopup').setView([latitude, longitude], 15);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
            }).addTo(mapPopup);

            L.marker([latitude, longitude])
                .addTo(mapPopup)
                .bindPopup(`<b>${provider}</b>`)
                .openPopup();
        } else {
            setTimeout(() => {
                mapPopup.invalidateSize();
                mapPopup.setView([latitude, longitude], 15);
            }, 200);
        }
    }

    // Saat tab "location" dibuka
    $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
        const target = $(e.target).attr("href");
        if (target === "#location") {
            initMapPreview();
        }
    });

    // Jika saat page load tab #location sudah aktif
    if ($('#location').hasClass('active') || $('#location').hasClass('show')) {
        initMapPreview();
    }

    // Buka modal map
    openMapBtn.addEventListener('click', function () {
        mapModal.classList.add('show');
        mapModal.classList.remove('d-none');
        initMapPopup();
    });

    // Tutup modal
    function closeModal() {
        mapModal.classList.remove('show');
        mapModal.classList.add('d-none');
    }

    closeMapBtn.addEventListener('click', closeModal);
    window.addEventListener('click', function (event) {
        if (event.target === mapModal) closeModal();
    });

    // Start navigasi
    startBtn.addEventListener('click', () => {
        if (!navigator.geolocation) {
            alert("Geolocation not supported.");
            return;
        }

        document.getElementById('mapLoadingOverlay').style.display = 'flex';

        navigator.geolocation.getCurrentPosition((position) => {
            document.getElementById('mapLoadingOverlay').style.display = 'none';
            const userLatLng = L.latLng(position.coords.latitude, position.coords.longitude);

            const redIcon = L.icon({
                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
                shadowUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png',
                iconSize: [25, 41],
                iconAnchor: [12, 41],
                popupAnchor: [1, -34],
                shadowSize: [41, 41]
            });

            if (routingControl) mapPopup.removeControl(routingControl);
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

            userMarker = L.marker(userLatLng, { icon: redIcon }).addTo(mapPopup)
                .bindPopup("<b>You are here</b>").openPopup();

            mapPopup.setView(userLatLng, 12);

            pathCoords = [userLatLng];
            pathLine = L.polyline(pathCoords, {
                color: '#28a745',
                weight: 3,
                opacity: 0.8
            }).addTo(mapPopup);

            watchId = navigator.geolocation.watchPosition((pos) => {
                const newLatLng = L.latLng(pos.coords.latitude, pos.coords.longitude);
                pathCoords.push(newLatLng);
                pathLine.setLatLngs(pathCoords);

                const currentPos = userMarker.getLatLng();
                const duration = 500;
                let start = null;

                function animateMarker(timestamp) {
                    if (!start) start = timestamp;
                    const progress = timestamp - start;
                    const percent = Math.min(progress / duration, 1);
                    const lat = currentPos.lat + (newLatLng.lat - currentPos.lat) * percent;
                    const lng = currentPos.lng + (newLatLng.lng - currentPos.lng) * percent;
                    userMarker.setLatLng([lat, lng]);
                    mapPopup.setView([lat, lng], 17);
                    if (percent < 1) requestAnimationFrame(animateMarker);
                }

                requestAnimationFrame(animateMarker);
            }, console.error, {
                enableHighAccuracy: true,
                maximumAge: 1000
            });

            startBtn.style.display = 'none';
            exitBtn.style.display = 'block';
        }, () => {
            alert("Failed to get location");
            document.getElementById('mapLoadingOverlay').style.display = 'none';
        });
    });

    // Exit Navigasi
    exitBtn.addEventListener('click', () => {
        document.getElementById('mapLoadingOverlay').style.display = 'none';
        if (watchId) navigator.geolocation.clearWatch(watchId);
        if (routingControl) mapPopup.removeControl(routingControl);
        if (userMarker) mapPopup.removeLayer(userMarker);
        if (pathLine) mapPopup.removeLayer(pathLine);

        routingControl = null;
        userMarker = null;
        pathLine = null;
        pathCoords = [];

        startBtn.style.display = 'block';
        exitBtn.style.display = 'none';
        startBtn.textContent = 'Start Navigation';
    });
});


  document.addEventListener('DOMContentLoaded', function () {
    const tabLinks = document.querySelectorAll('.nav-link[data-tab]');

    function getBaseProviderUrl() {
      const pathParts = window.location.pathname.split('/');
      const providerIndex = pathParts.indexOf('provider');
      if (providerIndex !== -1 && pathParts.length > providerIndex + 1) {
        return BASEURL + '/provider/' + pathParts[providerIndex + 1];
      }
      return BASEURL + '/provider/';
    }

    tabLinks.forEach(tab => {
      tab.addEventListener('click', function (e) {
        e.preventDefault();

        const tabName = this.getAttribute('data-tab');
        const tabTarget = this.getAttribute('href');
        const tabContent = document.querySelectorAll('.tab-pane');

        tabLinks.forEach(link => link.classList.remove('active'));
        tabContent.forEach(pane => pane.classList.remove('active'));

        this.classList.add('active');
        document.querySelector(tabTarget).classList.add('active');

        let baseUrl = getBaseProviderUrl();
        let newUrl = baseUrl;

        if (tabName === 'products') {
          newUrl += '/products/';
        } else if (tabName === 'review') {
          newUrl += '/reviews/';
        } else if (tabName === 'location') {
          newUrl += '/location/';
        } else {
          newUrl += '/';
        }

        window.history.pushState(null, '', newUrl);
      });
    });

    // Back / forward browser
    window.addEventListener('popstate', function () {
      const currentPath = window.location.pathname;
      if (currentPath.includes('/products')) {
        document.querySelector('[data-tab="products"]').click();
      } else if (currentPath.includes('/reviews')) {
        document.querySelector('[data-tab="review"]').click();
      } else if (currentPath.includes('/location')) {
        document.querySelector('[data-tab="location"]').click();
      } else {
        document.querySelector('[data-tab="overview"]').click();
      }
    });

    // Tombol show map scroll + aktifkan tab location
  const showMapBtn = document.getElementById("showMapBtn");
  const locationTab = document.querySelector('[data-tab="location"]');
  const locationContent = document.getElementById("location");

  if (showMapBtn && locationTab) {
    showMapBtn.addEventListener("click", function () {
      // Simulasikan klik pada tab "location" agar event handler di atas ikut jalan
      locationTab.click();

      // Scroll ke kontennya setelah delay biar tab aktif dulu
      setTimeout(() => {
        locationContent?.scrollIntoView({ behavior: "smooth" });
      }, 300);
    });
  }
  });
