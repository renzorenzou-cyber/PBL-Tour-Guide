<link href="https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.css" rel="stylesheet">

<section class="container g-pt-50">
  <div class="mb-5 mt-5">
    <!-- <h2 class="h3 g-color-black mb-0">{{ area.area_name }}'s Accommodation, {{ area.area_name }}'s Things to do</h2>
    <h4 class="h5 g-color-black mb-0">{{ area.area_description }}</h4>
    <div class="d-inline-block g-width-50 g-height-1 g-bg-black"></div> -->
  </div>

{% if subarea|length > 0 %}
  <div class="row">
    <div class="col-12">
      <div class="mb-4">
        <div class="d-flex justify-content-between">
          <div class="">
            <h5 class="h4 g-color-black poppins-semibold mb-0">{{ decoded_url|capitalize }} in {{ area.area_name }}</h5>
            <h6 class="h6 g-color-black mb-0">Found : {{ total_results }} Areas</h6>
          </div>
        </div>
      </div>

      <div class="row">
  {% for sa in subarea %}
  <?php if($sa->picture == ''){ $picture = 'default.jpg'; }else{ $picture = $sa->picture;}?>
    <div class="col-sm-12 col-md-6 col-lg-4 g-mb-30">
      <!-- Article -->
      <article class="g-pos-rel g-brd-3 g-brd-primary--hover g-transition-0_3 g-transition--linear transition area-content">
        <!-- Article Image -->
        <figure>
          <div class="swiper-container" data-area-id="{{ sa.id_area }}">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <a href="{{ url() }}area/{{ area.area_url }}/{{ sa.area_url }}/">
                    <img src="{{ config.vars.picUrl }}/areas/<?php echo $picture;?>" alt="{{ sa.area_name }}" style="border-radius: 18px 18px 0 0;">
                    </a>
                </div>
            </div>
          </div>
        </figure>
        <!-- End Article Image -->

        <!-- Article Content -->
        
        <div class="article-content g-py-10 g-px-20">
          <h3 class="h4 g-color-black">
              <a class="g-color-black g-font-weight-600 g-text-underline--none--hover transition g-color-primary--hover-v2" href="{{ url() }}area/{{ area.area_url }}/{{ sa.area_url }}/">{{ sa.area_name }}</a>
          </h3>
          <?php /*?>
          <div class="d-inline-block g-width-300 g-height-2" style="background-color: #bbb;"></div>
          <div class="price-explore mt-1">
            <div class="row justify-content-center px-2 py-3 my-2 gray-color">
              <div class="col-12 col-md-5 col-lg-5 g-mb-10 text-start d-flex align-items-center" style="gap: 5px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-buildings" viewBox="0 0 16 16">
                  <path d="M14.763.075A.5.5 0 0 1 15 .5v15a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5V14h-1v1.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V10a.5.5 0 0 1 .342-.474L6 7.64V4.5a.5.5 0 0 1 .276-.447l8-4a.5.5 0 0 1 .487.022M6 8.694 1 10.36V15h5zM7 15h2v-1.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5V15h2V1.309l-7 3.5z"/>
                  <path d="M2 11h1v1H2zm2 0h1v1H4zm-2 2h1v1H2zm2 0h1v1H4zm4-4h1v1H8zm2 0h1v1h-1zm-2 2h1v1H8zm2 0h1v1h-1zm2-2h1v1h-1zm0 2h1v1h-1zM8 7h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zM8 5h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zm0-2h1v1h-1z"/>
                </svg>
                <span class="text-uppercase">30 hotels</span>
              </div>
              <div class="col-12 col-md-7 col-lg-7 g-mb-10 text-start d-flex align-items-center" style="gap: 5px;">
                <svg id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 300 300" style="enable-background:new 0 0 300 300;" xml:space="preserve" version="1.1">
                  <g id="XMLID_2_">
                    <path id="XMLID_282_" fill="#555" d="M125.6,19.4c-7.2,0.4-12.9,6.5-12.9,13.9v47.4c0,1.9-1.4,3.6-3.3,3.8c-1,0.1-2-0.2-2.8-0.9c-0.8-0.7-1.2-1.7-1.2-2.7V33.4c0-7.5-5.7-13.6-12.9-14c-3.8-0.2-7.3,1.1-10,3.7c-2.7,2.6-4.2,6.1-4.2,9.8v47.8c0,2-1.4,3.6-3.3,3.8c-1,0.1-2-0.2-2.8-0.9C71.4,83,71,82,71,81V33.4c0-7.5-5.7-13.6-12.9-14c-3.8-0.2-7.3,1.1-10,3.7c-2.7,2.6-4.2,6.1-4.2,9.8v50.7c0,26.1,11.6,49.3,29.5,59.3v118.6c0,10.1,8,18.6,17.8,19c0.2,0,0.5,0,0.7,0c4.8,0,9.4-1.8,12.8-5.2c3.7-3.5,5.7-8.3,5.7-13.4V143c17.9-10,29.5-33.2,29.5-59.3V33c0-3.8-1.5-7.2-4.2-9.8C132.9,20.6,129.4,19.3,125.6,19.4z M100.4,139.9v121.9c0,4.5-3.4,8.4-7.7,8.8c-2.4,0.2-4.8-0.5-6.6-2.2c-1.8-1.6-2.8-3.9-2.8-6.3V139.9c0-1.9-1.1-3.7-2.9-4.5c-15.9-7.3-26.6-28-26.6-51.7V33.2c0-2,1.4-3.6,3.3-3.8c0.1,0,0.2,0,0.4,0c0.9,0,1.8,0.3,2.4,0.9C60.6,31,61,32,61,33v47.6c0,7.5,5.7,13.6,12.9,14c3.8,0.2,7.3-1.1,10-3.7c2.7-2.6,4.2-6.1,4.2-9.8V33.2c0-2,1.4-3.6,3.3-3.8c1-0.1,2,0.2,2.8,0.9C95,31,95.5,32,95.5,33v47.6c0,7.5,5.7,13.6,12.9,14c3.8,0.2,7.3-1.1,10-3.7c2.7-2.6,4.2-6.1,4.2-9.8V33.2c0-2,1.4-3.6,3.3-3.8c1-0.1,2,0.2,2.8,0.9c0.8,0.7,1.2,1.7,1.2,2.7v50.7c0,23.7-10.7,44.4-26.6,51.7C101.6,136.2,100.4,138,100.4,139.9z"/>
                    <path id="XMLID_285_" fill="#555" d="M241.1,42.4c-10.4-14.8-24-23-38.2-23c-14.3,0-27.9,8.2-38.2,23c-9.6,13.6-15.1,31.2-15.1,48.2c0,25.9,13.3,46.6,34.7,54.2v116.8c0,10.1,8,18.6,17.8,19c0.2,0,0.5,0,0.7,0c4.8,0,9.4-1.8,12.8-5.2c3.7-3.5,5.7-8.3,5.7-13.4V144.8c21.4-7.6,34.7-28.3,34.7-54.2C256.2,73.6,250.7,56,241.1,42.4z M211.5,141.1v120.7c0,4.5-3.4,8.4-7.7,8.8c-2.5,0.2-4.8-0.5-6.6-2.2c-1.8-1.6-2.8-3.9-2.8-6.3V141.1c0-2.2-1.5-4.2-3.7-4.8c-19.2-5.3-31.1-22.8-31.1-45.7c0-15,4.8-30.5,13.2-42.5c8.5-12.1,19.1-18.7,30.1-18.7S224.5,36,233,48.1c8.4,12,13.2,27.5,13.2,42.5c0,22.9-11.9,40.4-31.1,45.7C213,136.9,211.5,138.9,211.5,141.1z"/>
                  </g>
                </svg>                
                <span class="text-uppercase">20 restaurant</span>
              </div>
              <div class="col-12 col-md-12 col-lg-12 text-start d-flex align-items-center" style="gap: 5px;">
                <?xml version="1.0" ?>
                <!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN' 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
                <svg enable-background="new 0 0 64 64" height="24px" width="24px" id="Layer_1" version="1.1" viewBox="0 0 64 64"
                    xml:space="preserve" xmlns="http://www.w3.org/2000/svg"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                  <path d="M52.52,26.064c-1.612,0-3.149,0.336-4.544,0.939L43.179,15.89c-0.122-0.283-0.337-0.484-0.58-0.637
                    c-0.212-0.147-0.459-0.252-0.738-0.252h-8.897c-0.743,0-1.347,0.603-1.347,1.347c0,0.742,0.604,1.345,1.347,1.345h6.823
                    c0.331,0.018,1.022,0.139,1.319,0.825l0.54,1.247l0,0L41.747,20c0.099,0.291,0.139,0.749-0.604,0.749H22.428
                    c-0.857,0-1.262-0.451-1.434-0.732l-0.11-0.221v-0.003l-0.552-1.092c0,0,0,0,0-0.001l-0.006-0.011l-0.101-0.2l-0.012-0.002
                    l-0.225-0.405c-0.049-0.128-0.031-0.337,0.65-0.337h2.601c0,0,1.528,0.127,1.57-1.274c0.021-0.722-0.487-1.464-1.166-1.464
                    c-0.68,0-9.149,0-9.149,0s-1.464-0.17-1.549,1.369c0,0.688,0.571,1.369,1.379,1.369c0.295,0,0.7-0.003,1.091-0.007
                    c0.512,0.014,1.389,0.121,1.677,0.679l0,0l0.117,0.219c0.287,0.564,0.751,1.473,1.313,2.574c0.04,0.078,0.083,0.166,0.126,0.246
                    c0.107,0.285,0.188,0.807-0.208,1.483l-2.403,4.082c-1.397-0.606-2.937-0.947-4.559-0.947c-6.329,0-11.463,5.131-11.463,11.462
                    S5.15,48.999,11.479,48.999c5.565,0,10.201-3.968,11.243-9.227l5.767,0.478c0.235,0.02,0.453-0.04,0.654-0.127
                    c0.254-0.043,0.507-0.128,0.713-0.311l13.976-12.276c0.192-0.164,0.874-0.679,1.151-0.039l0.446,1.035
                    c-2.659,2.099-4.372,5.343-4.372,8.995c0,6.329,5.131,11.461,11.462,11.461c6.329,0,11.464-5.132,11.464-11.461
                    C63.983,31.196,58.849,26.064,52.52,26.064z M11.479,46.756c-4.893,0-8.861-3.968-8.861-8.861s3.969-8.859,8.861-8.859
                    c1.073,0,2.098,0.201,3.051,0.551l-4.178,7.098c-0.119,0.202-0.167,0.418-0.183,0.633c-0.003,0.022-0.015,0.036-0.016,0.054
                    c-0.007,0.091,0.02,0.172,0.03,0.258c0.008,0.054,0.004,0.105,0.018,0.158c0.132,0.559,0.592,1,1.193,1.05l8.782,0.727
                    C19.397,43.655,15.802,46.756,11.479,46.756z M15.169,36.423c-0.003-0.002-0.003-0.002-0.006-0.002
                    c-1.326-0.109-0.482-1.621-0.436-1.704l2.224-3.78c1.801,1.418,3.037,3.515,3.32,5.908L15.169,36.423z M25.607,37.285l-2.688-0.223
                    c-0.144-3.521-1.87-6.626-4.493-8.629l1.085-1.842c0.938-1.593,1.756,0.001,1.756,0.001l0,0c1.772,3.48,3.65,7.169,4.745,9.331
                    C26.012,35.924,26.746,37.379,25.607,37.285z M43.249,24.273L30.78,35.225c0,0.002,0,0.002,0,0.002
                    c-1.464,1.285-2.177-0.104-2.188-0.127l-5.297-10.517l0,0c-0.471-0.936,0.41-1.062,0.805-1.073h17.926c0,0,1.232-0.012,1.354,0.267
                    v0.002C43.458,23.961,43.473,24.077,43.249,24.273z M52.52,46.745c-4.891,0-8.86-3.968-8.86-8.858c0-2.625,1.146-4.976,2.962-6.599
                    l2.232,5.174c0.421,0.977,0.871,1.061,0.978,1.065h0.023h1.674c0.9,0,0.592-0.913,0.473-1.199l-2.862-6.631
                    c1.043-0.43,2.184-0.672,3.381-0.672c4.891,0,8.861,3.967,8.861,8.861C61.381,42.777,57.41,46.745,52.52,46.745z"
                    fill="#555"/>
                </svg>      
                <span class="text-uppercase">45 things to do</span>
              </div>
            </div>
          </div><?php */?>
        </div>

        <!-- End Article Content -->
      </article>
      <!-- End Article -->
    </div>
  {% endfor %}
  </div>

  {% if totalPages > 1 %}
<div class="pagination">
  <ul>
    {% if currentPage > 1 %}
    <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
      <a href="{{ url.get('area/' ~ area.area_url ~ '/' ~ (currentPage - 1)) }}" style="text-decoration: none; color: inherit;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
          <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
        </svg>        
        <span>Prev</span>
      </a>
    </li>
    {% endif %}
    
    {% for i in 1..totalPages %}
      {% if i == 1 or i == totalPages or (i >= currentPage - 1 and i <= currentPage + 1) %}
        <li class="numb {% if i == currentPage %}active{% endif %}">
          <a href="{{ url.get('area/' ~ area.area_url ~ '/' ~ i) }}" style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
            <span>{{ i }}</span>
          </a>
        </li>
      {% elseif i == currentPage - 2 or i == currentPage + 2 %}
        <li class="dots"><span>...</span></li>
      {% endif %}
    {% endfor %}
    
    {% if currentPage < totalPages %}
    <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
      <a href="{{ url.get('area/' ~ area.area_url ~ '/' ~ (currentPage + 1)) }}" style="text-decoration: none; color: inherit;">
        <span>Next</span>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-right" viewBox="0 0 16 16">
          <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
        </svg>
      </a>
    </li>
    {% endif %}
  </ul>
</div>
{% endif %}
    </div>
  </div>
{% else %}
    <p style="padding-left: 15px;margin-bottom:450px;">No results found for "<strong>{{ decoded_url }}</strong>" in <strong>{{ area.area_name }}</strong>.</p>
{% endif %}
</section>


<script src="https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js"></script>
<script>
    function toggleCheckbox(headerEl) {
    const arrow = headerEl.querySelector('.arrow');
    const checkboxGroup = headerEl.nextElementSibling;
    arrow.classList.toggle('rotate');
    checkboxGroup.classList.toggle('show');
  }

  var slider = document.getElementById('slider');
  var minInput = document.getElementById('min-price');
  var maxInput = document.getElementById('max-price');

  noUiSlider.create(slider, {
    start: [0, 714],
    connect: true,
    range: {
      'min': 0,
      'max': 1000
    },
    step: 1,
    format: {
      to: function (value) {
        return Math.round(value);
      },
      from: function (value) {
        return Number(value);
      }
    }
  });

  // Update input saat slider digeser
  slider.noUiSlider.on('update', function (values, handle) {
    if (handle === 0) {
      minPrice.value = 'IDR ' + values[0];
    } else {
      maxPrice.value = 'IDR ' + values[1];
    }
  });

  // Update slider saat input diketik
  function setSliderFromInputs() {
    var minVal = parseInt(minInput.value);
    var maxVal = parseInt(maxInput.value);
    if (!isNaN(minVal) && !isNaN(maxVal)) {
      slider.noUiSlider.set([minVal, maxVal]);
    }
  }

  minInput.addEventListener('change', setSliderFromInputs);
  maxInput.addEventListener('change', setSliderFromInputs);
</script>
