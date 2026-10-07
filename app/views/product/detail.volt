<section class="container g-pt-50">
  <div class="mb-5" style="margin-top: 3rem;">
    <?php
        $areas = $this->session->get('areas')['selected'];
        $decodedArea = ucwords(str_replace('-', ' ', $areas));
    ?>
    <h5><a href="{{ url() }}area/<?php echo $areas;?>/"><?php echo $decodedArea ?></a> / <a href="{{ url() }}category/{{ product.group_product_url }}/">{{ product.group_product }}</h5>
    <h2 class="h3 g-color-black g-font-weight-500 text-uppercase mb-0">{{ product.name }}</h2>
    <div class="d-inline-block g-width-70 g-height-1 g-bg-black"></div>
    <div class="d-flex align-items-center" style="gap: 3px;">
      <a class="h6 g-color-black g-font-weight-500 text-uppercase mb-0" style="cursor: pointer;" href="{{ config.application.baseUri }}provider/{{product.provider_slug}}/" target="_blank">By {{ product.provider_name }} ・</a>
      <a href="javascript:void(0);" onclick="openReviewTab()">
        <div class="d-flex g-font-weight-500 g-color-black align-items-center" style="gap: 5px;">
          <i class="bi bi-star-fill text-warning"></i>{{average_rating}} ({{total_review}})
        </div>
      </a>
    </div>
  </div>

  <!-- Product Description -->

  <!-- Image gallery START -->
  <div class="row gallery-row mt-md-5">
    <div class="col-8">

      {# Hitung total media #}
      {% set totalPreview = 3 %}
      {% set totalMedia = video|length + images|length %}
      {% set totalDisplayedVideos = video|length > 0 ? 1 : 0 %}
      {% set totalDisplayedImages = totalPreview - totalDisplayedVideos %}

      <div class="row gallery-layout 
      {% if video|length == 1 and images|length == 1 %}gambar-2-khusus
      {% elseif totalMedia == 1 %}gambar-1
      {% elseif totalMedia == 2 %}gambar-2
      {% elseif totalMedia >= 3 %}gambar-3
      {% else %}gambar-3{% endif %}" style="gap: 8px;" id="galleryLayout" data-picture-count="{{ images|length }}">

        {% if video|length > 0 %}
        <div class="gallery-item">
          <div class="video-wrapper" style="position: relative;">
            <a href="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ video[0].name }}" data-fancybox="video" data-caption="{{ product.name }}" data-type ="video">
              <video class="img-fluid" src="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ video[0].name }}"
                muted loop playsinline style="border-radius: 12px; object-fit: cover;"></video>
              <div class="play-overlay"
                style="position: absolute;top: 50%; left: 50%;transform: translate(-50%, -50%);font-size: 40px;color: white;background: rgba(0,0,0,0.4);border-radius: 50%;padding: 10px 25px;pointer-events: none;">
                ▶</div>
            </a>
          </div>
        </div>
        {% endif %}

        {% for image in images %}
        {% if loop.index <= totalDisplayedImages %} <div class="gallery-item">
          <a href="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}" data-fancybox="image" data-caption="{{ product.name }}">
            <img class="img-fluid" src="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}"
              alt="{{ product.name }}">
          </a>
          {% if loop.index == totalDisplayedImages and totalMedia > totalPreview %}
          <div class="extra-images">
            <span>+{{ totalMedia - totalPreview }}</span>
          </div>
          {% endif %}
      </div>
      {% endif %}
      {% endfor %}

      {% for vid in video %}
        <a href="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ vid.name }}"
          data-fancybox="video"
          data-type="video"
          data-caption="{{ product.name }}"
          class="d-none">
          <video src="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ vid.name }}"></video>
        </a>
      {% endfor %}

      {% for image in images %}
      {% if loop.index > totalDisplayedImages %}
      <a href="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}" data-fancybox="image" data-caption="{{ product.name }}"
        class="d-none">
        <img src="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}" alt="{{ product.name }}">
      </a>
      {% endif %}
      {% endfor %}
    </div>
  </div>

  <div class="row ml-1">
      {# Mobile view carousel tetap pakai gambar semua #}
    <div class="col-12 col-md-6 mb-3 d-lg-none">
      <div id="mobileCarousel" class="carousel slide w-100 mx-auto" data-ride="carousel" style="max-width: 700px;">
        <div class="carousel-inner">
          {% for image in images %}
          <div class="carousel-item {% if loop.index == 1 %}active{% endif %}">
            <a href="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}" data-fancybox="gallery" data-caption="{{ product.name }}">
              <img class="d-block w-100 img-fluid"
                src="{{ config.vars.picUrl }}/products/{{ product.id }}/{{ image.name }}" alt="{{ product.name }}">
            </a>
          </div>
          {% endfor %}
        </div>
        <a class="carousel-control-prev" href="#mobileCarousel" role="button" data-slide="prev">
          <i class="bi bi-chevron-left" style="font-size: 2.5rem" aria-hidden="true"></i>
          <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#mobileCarousel" role="button" data-slide="next">
          <i class="bi bi-chevron-right" style="font-size: 2.5rem" aria-hidden="true"></i>
          <span class="sr-only">Next</span>
        </a>
      </div>
    </div>

    <!-- Cek Availability Section -->
    {% if product.latitude is defined and product.latitude and product.longitude is defined and product.longitude %}
    <div class="col-12 col-md-6 col-lg-12 mb-5 check-availability" style="width: 380px;">

      <a id="openMap">
        <div id="mapPreview" data-latitude="{{ product.latitude }}" data-longitude="{{ product.longitude }}"
          data-provider="{{ product.provider_name }}">
        </div>
      </a>

      <div id="mapModal" class="modal d-none">
        <div class="modal-content">
          <span id="closeMap" class="close">&times;</span>
          <div id="startBtn">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
              stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-navigation">
              <polygon points="3 11 22 2 13 21 11 13 3 11" />
            </svg>
          </div>
          <button id="exitBtn" style="display:none; color: red;">Exit</button>
          <div id="mapPopup" style="height: 700px; width: 100%;"></div>
          <div id="mapLoadingOverlay" class="map-loading-overlay">
            <div class="map-loading-content">
              <div class="spinner" style="margin-left: 30px;"></div>
              <div class="glow-text">Loading map...</div>
            </div>
          </div>

        </div>
      </div>


      <div class="container d-flex flex-column align-items-center justify-content-center text-center mt-2 mb-5" style="position: relative; height: 194px; border-radius: 10px; overflow: hidden;">
        {% if product.price > 0 %}
        <!-- Gambar background -->
        <div style="background: url({{ config.vars.picUrl }}/products/{{ product.id }}/{{ product.picture }}) no-repeat center/cover;
                    width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 0;">
        </div>

        <!-- Konten harga & tombol -->
        <div class="position-relative w-100 d-flex flex-column align-items-center justify-content-center" style="z-index: 1; padding-bottom: 7rem;">
          <p class="start_from_container text-white mb-3">
            Start from<br>
            {% if hotdeals[product.id] is defined and hotdeals[product.id]['discounted_price'] > 0 %}
              <span class="g-font-weight-600 original-price" style="color: red; font-size: 11pt;">
                <s><span class="activecurrency">IDR </span><span class="valuecurrency" data-baseprice="{{ product.price }}"> {{ number_format(product.price) }},-</span></s>
              </span><br>
              <span class="g-font-weight-600 discounted-price" style="font-size: 16pt; color: white;">
                <span class="activecurrency">IDR </span><span class="valuecurrency" data-baseprice="{{ hotdeals[product.id]['discounted_price'] }}"></span>
              </span>
            {% else %}
              <span class="start_price">
                <span class="activecurrency">IDR </span><span class="valuecurrency" data-baseprice="{{ product.price }}"> {{ number_format(product.price) }},-</span>
              </span>
            {% endif %}
          </p>

          <div class="pb-4">
            <button class="btn btn-light w-100" style="max-width: 200px; border-radius: 16px;" type="button" onclick="scrollToAvailability()">Check Availability</button>
          </div>
        </div>
      
        {% else %}
          <!-- Gambar dan overlay Not Available -->
          <div style="background: url({{ config.vars.picUrl }}/products/{{ product.id }}/{{ product.picture }}) no-repeat center/cover;
                      width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 0; filter: brightness(40%);">
          </div>

          <div class="position-absolute d-flex flex-column align-items-center justify-content-center text-center w-100 h-100" style="background-color: rgba(0, 0, 0, .0); z-index: 1; border-radius: 10px; padding: 1rem;">
            <h5 class="poppins-bold mb-2" style="color: red;">Not Available</h5>
            <p class="text-white poppins-medium" style="font-size: 13px;">Currently it is not possible to book this product due to its limited availability.</p>
          </div>
        {% endif %}
      </div>

    </div>
    {% else %}

    <div class="col-12 col-md-4 col-lg-12 mb-5 check-availability">
      <div class="container pb-4 d-flex flex-column align-items-center justify-content-center text-center" style="background: url({{ config.vars.picUrl }}/products/{{ product.id }}/{{ product.picture }}) no-repeat center/cover; 
                background-color: #87CEEB; height: 400px; border-radius: 10px; width: 350px;">
        <p class="start_from_container">Start from<br>
          <!-- <span class="start_price"><span class="activecurrency">IDR </span><span class="valuecurrency" data-baseprice="{{ product.price }}"> {{ number_format(product.price) }},-</span></span> -->

          {% if hotdeals[product.id] is defined and hotdeals[product.id]['discounted_price'] > 0 %}
          <span class="g-color-gold g-font-weight-600 original-price" style="color: red;font-size: 11pt;"><s
              style="text-decoration: line-through;color: red;font-size: 11pt;"><span class="activecurrency">IDR
              </span><span class="valuecurrency" data-baseprice="{{ product.price }}"> {{ number_format(product.price)
                }},-</span></s></span><br>
          <span class="g-font-weight-600 discounted-price" style="font-size: 16pt; color: white;"><span
              class="activecurrency">IDR </span><span class="valuecurrency"
              data-baseprice="{{ hotdeals[product.id]['discounted_price'] }}"></span></span>
          {% else %}
          <span class="start_price"><span class="activecurrency">IDR </span><span class="valuecurrency"
              data-baseprice="{{ product.price }}"> {{ number_format(product.price) }},-</span></span>
          {% endif %}
        </p>
        <div class="pt-2 pb-4">
          <button class="btn btn-light w-100" style="max-width: 200px; border-radius: 16px;" type="button"
            onclick="scrollToAvailability()">Check Availability</button>
        </div>
      </div>
    </div>
    {% endif %}
  </div>
</div>

  <!-- Image gallery END -->
  <div class="row">
    <div class="col-12">
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a class="nav-link {% if not reviewTabActive %}show active{% endif %}" data-bs-toggle="tab"
            href="#overview-content">Overview</a>
        </li>
        <li class="nav-item">
          <a class="nav-link {% if reviewTabActive %}active{% endif %}" data-bs-toggle="tab" href="#review-content"
            id="review-tab">Review</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="tab-content pt-3">
    <!-- OVERVIEW -->
    <div class="tab-pane {% if not reviewTabActive %}active{% endif %}" id="overview-content">
      <div class="row">
        <div class="col-lg-7 mt-4 col-sm-12">
          <div class="details__caption">
            <div class="d-flex align-items-center mb-3" style="gap: 10px;">
              <div class="poppins-medium g-color-black">
                <h3 class="g-color-black">{{ product.name }}</h3>
                <p class="g-color-black">{{ product.description }}</p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-lg mt-5 d-none d-lg-block" style="font-size: 12px;">
          {% if (product.itinerary is not empty and product.itinerary|striptags is not empty)
          or (product.inclusion_exclusion is not empty and product.inclusion_exclusion|striptags is not empty)
          or (product.policy is not empty and product.policy|striptags is not empty) %}
          <div class="side-bar-container">
            <div id="text" class="text">
              <div id="content" class="g-color-black">
                {% if product.itinerary is not empty and product.itinerary|striptags is not empty %}
                <div class="itinerary">
                  <h3 class="pt-4 pb-2 text-center">Itinerary</h3>
                  <h6>{{ product.itinerary }}</h6>
                </div>
                {% endif %}
                {% if product.inclusion_exclusion is not empty and product.inclusion_exclusion|striptags is not empty %}
                <div class="inclusion-exclusion">
                  <h3 class="pt-4 pb-2 text-center">Inclusion / Exclusion</h3>
                  <h6>{{ product.inclusion_exclusion }}</h6>
                </div>
                {% endif %}
                {% if product.policy is not empty and product.policy|striptags is not empty %}
                <div class="policy pb-5">
                  <h3 class="pt-4 pb-2 text-center">Policy</h3>
                  <h6>{{ product.policy }}</h6>
                </div>
                {% endif %}
              </div>
              <div id="fade" class="fade">p</div>
            </div>
            <span id="read-more" class="read-more g-font-size-14">Read More</span>
          </div>
          {% endif %}
        </div>
      </div>
    </div>

    <!-- REVIEW -->
    <div class="tab-pane {% if reviewTabActive %}show active{% endif %}" id="review-content">
      <div class="row mt-4">
        <div class="col-12 review-title d-flex justify-content-between">
          <h3 class="g-color-black">Review</h3>
          <div class="d-flex align-items-center" style="gap: 15px;">
            <div class="d-flex align-items-center" style="gap: 8px;">
              <span>Filter by:</span>
              <div class="dropdown dropdown-custom">
                <button class="btn py-2 pr-4 d-flex dropdown-toggle" type="button" data-bs-toggle="dropdown"
                  aria-expanded="false">
                  <div class="d-flex align-items-center" style="gap: 5px;">
                    {% if selectedStar == 1 %}
                    <i class="bi bi-star-fill text-warning"></i>
                    <span>1</span>
                    {% elseif selectedStar == 2 %}
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <span>2</span>
                    {% elseif selectedStar == 3 %}
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <span>3</span>
                    {% elseif selectedStar == 4 %}
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <span>4</span>
                    {% else %}
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <span>5</span>
                    {% endif %}
                  </div>
                </button>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item"
                      href="{{ url.get(product.id ~ '/' ~ product.slug ~ '/review/rating/5/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>5</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(product.id ~ '/' ~ product.slug ~ '/review/rating/4/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>4</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(product.id ~ '/' ~ product.slug ~ '/review/rating/3/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>3</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(product.id ~ '/' ~ product.slug ~ '/review/rating/2/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>2</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(product.id ~ '/' ~ product.slug ~ '/review/rating/1/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>1</span>
                      </div>
                    </a></li>
                </ul>
              </div>
            </div>

            <div class="d-flex align-items-center" style="gap: 8px;">
              <span class="review-filter">Sort by:</span>
              <div class="dropdown dropdown-custom">
                <button class="btn py-2 dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                  {% if selectedSort == 'lowest' %}
                  Lowest to Highest
                  {% elseif selectedSort == 'latest' %}
                  Latest
                  {% elseif selectedSort == 'oldest' %}
                  Oldest
                  {% else %}
                  Latest
                  {% endif %}
                </button>
                <ul class="dropdown-menu">
                  {% set baseUrl = product.id ~ '/' ~ product.slug %}
                  {% if selectedStar %}
                  <li><a class="dropdown-item"
                      href="{{ url.get(baseUrl ~ '/review/rating/' ~ selectedStar ~ '/highest/1') }}">Highest to
                      Lowest</a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(baseUrl ~ '/review/rating/' ~ selectedStar ~ '/lowest/1') }}">Lowest to
                      Highest</a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(baseUrl ~ '/review/rating/' ~ selectedStar ~ '/latest/1') }}">Latest</a></li>
                  <li><a class="dropdown-item"
                      href="{{ url.get(baseUrl ~ '/review/rating/' ~ selectedStar ~ '/oldest/1') }}">Oldest</a></li>
                  {% else %}
                  <li><a class="dropdown-item" href="{{ url.get(baseUrl ~ '/review/highest/1') }}">Highest to Lowest</a>
                  </li>
                  <li><a class="dropdown-item" href="{{ url.get(baseUrl ~ '/review/lowest/1') }}">Lowest to Highest</a>
                  </li>
                  <li><a class="dropdown-item" href="{{ url.get(baseUrl ~ '/review/newest/1') }}">Latest</a></li>
                  <li><a class="dropdown-item" href="{{ url.get(baseUrl ~ '/review/oldest/1') }}">Oldest</a></li>
                  {% endif %}
                </ul>
              </div>
            </div>

          </div>
        </div>
        <div class="col-12 review-star">
          <div class="d-flex align-items-center" style="gap: 10px;">
            <i class="bi bi-star-fill text-warning" style="font-size: 45px;"></i>
            <div class="d-flex align-items-center" style="gap: 10px;">
              <h2 class="g-color-black" style="margin: 0 !important;">{{average_rating}} / 5</h2>
              <h6 class="mt-auto">({{total_review}} reviews)</h6>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-2">
        <?php if (empty($review)): ?>
          <img src="{{ url() }}img/no-data2.png" style="width: 40%;margin:auto;padding-top: 40px;">
        <?php else: ?>
          <?php foreach ($review as $rev): ?>
            <div class="col-12 mb-4">
              <div class="card p-3 card-review shadow h-100">
                <h5 class="g-color-black poppins-semibold" style="margin: 0px !important;">
                  <?= $rev['review_name'] ?>
                </h5>

                <div class="mt-2 mb-3 d-flex align-items-center" style="gap: 5px;">
                  <?php
                    for ($i = 1; $i <= 5; $i++) {
                      if ($i <= $rev['review_star']) {
                        echo '<i class="bi bi-star-fill text-warning" style="font-size: 17px;"></i>';
                      } else {
                        echo '<i class="bi bi-star text-warning" style="font-size: 17px;"></i>';
                      }
                    }
                  ?>
                  <span class="ml-1">
                    <?= $rev['review_star'] ?>
                  </span>
                </div>

                <span class="mb-1">
                  <?= $rev['rate_name'] ?> /
                  <?= $rev['rate_opt_name'] ?> •
                  <?= $rev['formatted_date'] ?>
                </span>

                <?php
                  $words = explode(' ', $rev['review_comment']);
                  $maxWords = 25;
                  $isLong = count($words) > $maxWords;
                  $previewText = implode(' ', array_slice($words, 0, $maxWords));
                ?>

                <div class="card-review">
                  <p class="review-short mb-0"><?= $previewText ?><?= $isLong ? '...' : '' ?></p>

                  <?php if ($isLong): ?>
                    <p class="review-full d-none mb-0"><?= $rev['review_comment'] ?></p>
                    <button class="btn btn-link p-0 read-more-toggle">Read More</button>
                  <?php endif; ?>

                  <!-- TAMPILAN GAMBAR -->
                  <?php if (!empty($rev['images'])): ?>
                    <?php 
                      $totalImages = count($rev['images']);
                      $visibleImages = 4;
                    ?>
                    <div class="review-gallery mt-2" id="review-gallery-<?= $rev['review_id'] ?>">
                      <?php foreach ($rev['images'] as $index => $img): ?>
                        <?php 
                          $isLastVisible = ($index == $visibleImages - 1) && ($totalImages > $visibleImages);
                          $isHidden = ($index >= $visibleImages);
                        ?>
                        <a 
                          href="<?= $this->config->vars->picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $img->name ?>"
                          data-fancybox="gallery-<?= $rev['review_id'] ?>"
                          class="review-image <?= $isHidden ? 'd-none' : '' ?>"
                        >
                          <div style="position: relative; display: inline-block;">
                            <img 
                              src="<?= $this->config->vars->picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $img->name ?>" 
                              class="img-fluid me-2 mb-2" 
                              style="width:90px;height:90px;object-fit:cover; border-radius: 5px;"
                            >
                            <?php if ($isLastVisible): ?>
                              <div class="poppins-medium" style="
                                position: absolute;
                                top: 0;
                                left: 0;
                                width: 90px;
                                height: 90px;
                                background: rgba(0, 0, 0, 0.5);
                                color: white;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                border-radius: 8px;
                                font-size: 14px;
                              ">
                                +<?= $totalImages - $visibleImages + 1 ?> Image
                              </div>
                            <?php endif; ?>
                          </div>
                        </a>
                      <?php endforeach; ?>
                    </div>
                  <?php endif; ?>

                  <!-- TAMPILAN VIDEO -->
                 <?php if (!empty($rev['videos'])): ?>
                  <div class="review-videos mt-2">
                    <?php foreach ($rev['videos'] as $vid): ?>
                      <a 
                        href="<?= $this->config->vars->picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $vid->name ?>"
                        data-fancybox="video"
                        data-type="video"
                        data-caption="Video Review"
                        style="display: inline-block; margin-right: 5px; margin-bottom: 5px;"
                      >
                        <video 
                          width="160" height="100" 
                          muted 
                          style="border-radius: 5px; object-fit: cover;"
                        >
                          <source src="<?= $this->config->vars->picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $vid->name ?>" type="video/mp4">
                        </video>
                      </a>
                    <?php endforeach; ?>
                  </div>
                <?php endif; ?>
                </div>

                <!-- REPLIES -->
                <?php if (!empty($rev['replies'])): ?>
                  <?php foreach ($rev['replies'] as $reply): ?>
                    <div class="card-reply mt-3 py-4 px-4">
                      <div class="pr-3">
                        <i class="bi bi-reply-all-fill"></i>
                      </div>
                      <div class="pl-3" style="border-left: 2px solid rgba(75, 148, 77, .5);">
                        <h6 class="g-color-black" style="font-size: 15px;">
                          Response from Provider
                        </h6>
                        <p class="mb-1"><?= $reply['formatted_date'] ?> / {{ product.provider_name }}</p>
                        <span class="g-color-black"><?= nl2br(htmlspecialchars($reply['review_comment'])) ?></span>

                        <!-- Gambar Reply -->
                        <?php if (!empty($reply['images'])): ?>
                          <div class="reply-images mt-2">
                            <?php foreach ($reply['images'] as $img): ?>
                              <a 
                                href="<?= $this->config->vars->picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $img->name ?>" 
                                data-fancybox="video-<?= $reply['review_id'] ?>"
                              >
                                <img 
                                  src="<?= $this->config->vars->picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $img->name ?>" 
                                  width="80" 
                                  style="margin-right: 5px; margin-top: 5px; border-radius: 5px; object-fit: cover;"
                                >
                              </a>
                            <?php endforeach; ?>
                          </div>
                        <?php endif; ?>

                        <!-- Video Reply -->
                        <?php if (!empty($reply['videos'])): ?>
                          <div class="reply-videos mt-2">
                            <?php foreach ($reply['videos'] as $vid): ?>
                              <video 
                                width="90" 
                                height="90" 
                                controls 
                                style="margin-right: 5px; margin-bottom: 5px; border-radius: 5px; object-fit: cover;"
                              >
                                <source src="<?= $this->config->vars->picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $vid->name ?>" type="video/mp4">
                                Your browser does not support the video tag.
                              </video>
                            <?php endforeach; ?>
                          </div>
                        <?php endif; ?>

                      </div>
                    </div>
                  <?php endforeach; ?>
                <?php endif; ?>

              </div>
            </div>
          <?php endforeach; ?>
        <?php endif; ?>
      </div>
      {% set baseReviewUrl = url.get('' ~ product.id ~ '/' ~ product.slug ~ '/review') %}
      {% if selectedStar is defined and selectedStar and selectedSort is defined and selectedSort %}
      {% set baseReviewUrl = baseReviewUrl ~ '/rating/' ~ selectedStar ~ '/' ~ selectedSort %}
      {% elseif selectedStar is defined and selectedStar %}
      {% set baseReviewUrl = baseReviewUrl ~ '/rating/' ~ selectedStar %}
      {% elseif selectedSort is defined and selectedSort %}
      {% set baseReviewUrl = baseReviewUrl ~ '/' ~ selectedSort %}
      {% endif %}

      {% if totalPages > 1 and total_review > perPage %}
      <div class="pagination mt-4">
        <ul>
          {% if currentPage > 1 %}
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <a href="{{ baseReviewUrl ~ '/' ~ (currentPage - 1) }}" style="text-decoration: none; color: inherit;">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor"
                stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
                <path fill-rule="evenodd"
                  d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0" />
              </svg>
              <span>Prev</span>
            </a>
          </li>
          {% endif %}

          {% for i in 1..totalPages %}
          {% if i == 1 or i == totalPages or (i >= currentPage - 1 and i <= currentPage + 1) %} <li
            class="numb {% if i == currentPage %}active{% endif %}">
            <a href="{{ baseReviewUrl ~ '/' ~ i }}"
              style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
              <span>{{ i }}</span>
            </a>
            </li>
            {% elseif i == currentPage - 2 or i == currentPage + 2 %}
            <li class="dots"><span>...</span></li>
            {% endif %}
            {% endfor %}

            {% if currentPage < totalPages %} <li
              class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
              <a href="{{ baseReviewUrl ~ '/' ~ (currentPage + 1) }}" style="text-decoration: none; color: inherit;">
                <span>Next</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor"
                  stroke-width="1.5" class="bi bi-chevron-right" viewBox="0 0 16 16">
                  <path fill-rule="evenodd"
                    d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708" />
                </svg>
              </a>
              </li>
              {% endif %}
        </ul>
      </div>
      {% endif %}




    </div>
  </div>

  {% if product.price > 0 %}
  <div>
    <form id="formavailability" style="width: 100%;">
      <div id="availabilityDetails">

        {% if product.modules == 10 %}
        <div class="container pt-4 mt-4 pb-4 px-5 search_container">
          <div class="d-flex flex-column flex-md-row align-items-center justify-content-center" style="row-gap: 10px;">
            <div class="col-12 col-md-4 mb-3 mb-md-0">
              <p class="my-auto selectdate_text">Select a date</p>
            </div>
            <div class="col-12 col-md-5 col-lg-4">
              <div class="selectdate_input w-100 w-md-auto" style="position: relative; display: inline-block;">
                <input id="tanggal" type="text" class="form-control" min=""
                  style="background-color: white; border-radius:20px; padding-left: 50px; height:35px;"
                  placeholder="Select Date ">
                <svg xmlns="http://www.w3.org/2000/svg" style="
                    position: absolute;
                    left: 20px;
                    top: 50%;
                    transform: translateY(-50%);
                    pointer-events: none;" width="20" height="20" fill="currentColor" class="bi bi-calendar"
                  viewBox="0 0 16 16">
                  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 
                        2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 
                        1 0V1zm-2 3v1h13V3a1 1 0 0 0-1-1h-1v.5a.5.5 0 0 1-1 
                        0V2h-8v.5a.5.5 0 0 1-1 0V2H2a1 1 0 0 0-1 1zm13 
                        2H1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V5z" />
                </svg>
              </div>
            </div>
            <div class="col-12 col-md-4">
              <button class="btn btn-light w-100 w-md-auto" style="border-radius: 16px;" id="searchavailability"
                type="button" data-module="{{ product.modules }}" data-idp="{{ product.id }}">Search
                Availability</button>
            </div>
          </div>
        </div>
        {% elseif product.modules == 9 %}
        <div class="row rental-container mt-5">
          <div class="col-12 col-md-8 col-lg-9 rental-form">
            <div class="form-group">
              <label class="poppins-semibold">Delivery Date</label>
              <div class="input-wrapper" style="border-right: solid 2px #f4f4f4; border-radius: 10px 0 0 10px;">
                <i class="fa fa-calendar"></i>
                <input type="text" id="tanggal" placeholder="Select date">
              </div>
            </div>
            <div class="form-group">
              <label class="poppins-semibold">Return Date</label>
              <div class="input-wrapper"
                style="border-right: solid 2px #f4f4f4; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                <i class="fa fa-calendar"></i>
                <input type="text" id="tanggal2" placeholder="Select date">
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4 col-lg-3 d-flex align-items-center justify-content-center mt-2">
            <button class="btn btn-light w-100 w-md-auto"
              style="padding: 8px 10px; border-radius: 10px; background-color: #fff;" id="searchavailability"
              type="button" data-module="{{ product.modules }}" data-idp="{{ product.id }}">Search Availability</button>
          </div>
        </div>
        {% elseif product.modules == 11 %}
        <div class="container pt-4 mt-4 pb-4 px-5 search_container">
          <div class="d-flex flex-column flex-md-row align-items-center justify-content-center" style="row-gap: 10px;">
            <div class="col-12 col-md-4 mb-3 mb-md-0">
              <p class="my-auto selectdate_text">Select a date</p>
            </div>
            <div class="col-12 col-md-5 col-lg-4">
              <div class="selectdate_input w-100 w-md-auto" style="position: relative; display: inline-block;">
                <input id="tanggal" type="text" class="form-control" min=""
                  style="background-color: white; border-radius:20px; padding-left: 50px; height:35px;"
                  placeholder="Select Date ">
                <svg xmlns="http://www.w3.org/2000/svg" style="
                    position: absolute;
                    left: 20px;
                    top: 50%;
                    transform: translateY(-50%);
                    pointer-events: none;" width="20" height="20" fill="currentColor" class="bi bi-calendar"
                  viewBox="0 0 16 16">
                  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 
                        2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 
                        1 0V1zm-2 3v1h13V3a1 1 0 0 0-1-1h-1v.5a.5.5 0 0 1-1 
                        0V2h-8v.5a.5.5 0 0 1-1 0V2H2a1 1 0 0 0-1 1zm13 
                        2H1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V5z" />
                </svg>
              </div>
            </div>
            <div class="col-12 col-md-4">
              <button class="btn btn-light w-100 w-md-auto" style="border-radius: 16px;" id="searchavailability"
                type="button" data-module="{{ product.modules }}" data-idp="{{ product.id }}">Search
                Availability</button>
            </div>
          </div>
        </div>
        {% else %}
        <div class="row rental-container mt-5">
          <div class="col-12 col-md-8 col-lg-9 rental-form">
            <div class="form-group">
              <label class="poppins-semibold">Start Date</label>
              <div class="input-wrapper" style="border-right: solid 2px #f4f4f4; border-radius: 10px 0 0 10px;">
                <i class="fa fa-calendar"></i>
                <input type="text" id="tanggal" placeholder="Select date">
              </div>
            </div>
            <div class="form-group">
              <label class="poppins-semibold">End Date</label>
              <div class="input-wrapper"
                style="border-right: solid 2px #f4f4f4; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                <i class="fa fa-calendar"></i>
                <input type="text" id="tanggal2" placeholder="Select date">
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4 col-lg-3 d-flex align-items-center justify-content-center mt-2">
            <button class="btn btn-light w-100 w-md-auto"
              style="padding: 8px 10px; border-radius: 10px; background-color: #fff;" id="searchavailability"
              type="button" data-module="{{ product.modules }}" data-idp="{{ product.id }}">Search Availability</button>
          </div>
        </div>
        {% endif %}

      </div>
    </form>
    <div class="col-sm-12 mt-4">
      <div id="show_result"></div>
    </div>
    <div class="faq-section mt-4">
    <div id="faqAccordion" class="accordion">
      {% for faq in faqs %}
      <div class="card">
        <div class="card-header" id="heading{{ loop.index }}">
          <h5 class="mb-0">
            <button class="btn btn-link collapsed w-100 px-3"
              data-toggle="collapse" data-target="#collapse{{ loop.index }}" aria-expanded="false"
              aria-controls="collapse{{ loop.index }}">
              <span class="faq-question text-left">{{ faq.question }}</span>
              <span class="u-accordion__control-icon ml-auto">
                <i class="fa fa-angle-down"></i>
                <i class="fa fa-angle-up"></i>
              </span>
            </button>
          </h5>
        </div>

        <div id="collapse{{ loop.index }}" class="collapse" aria-labelledby="heading{{ loop.index }}"
          data-parent="#faqAccordion" style="margin-left: 20px;">
          <div class="card-body">
            {{ faq.answer }}
          </div>
        </div>
      </div>
      {% endfor %}
    </div>
</div>

  </div>
  {% else %}
    <div>
    <form  style="width: 100%;">
      <div >

        {% if product.modules == 10 %}
        <div class="container pt-4 mt-4 pb-4 px-5 search_container" style="background-color: #f0f0f0 !important; ">
          <div class="d-flex flex-column flex-md-row align-items-center justify-content-center" style="row-gap: 10px;">
            <div class="col-12 col-md-4 mb-3 mb-md-0">
              <p class="my-auto selectdate_text" >Select a date</p>
            </div>
            <div class="col-12 col-md-5 col-lg-4">
              <div class="selectdate_input w-100 w-md-auto" style="position: relative; display: inline-block;">
                <input type="text" class="form-control" min=""
                  style="background-color: #f5f3f3; border-radius:20px; padding-left: 50px; height:35px;"
                   readonly>
                <svg xmlns="http://www.w3.org/2000/svg" style="
                    position: absolute;
                    left: 20px;
                    top: 50%;
                    transform: translateY(-50%);
                    pointer-events: none;
                    color:#dadada;" width="20" height="20" fill="currentColor" class="bi bi-calendar"
                  viewBox="0 0 16 16">
                  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 
                        2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 
                        1 0V1zm-2 3v1h13V3a1 1 0 0 0-1-1h-1v.5a.5.5 0 0 1-1 
                        0V2h-8v.5a.5.5 0 0 1-1 0V2H2a1 1 0 0 0-1 1zm13 
                        2H1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V5z" />
                </svg>
              </div>
            </div>
            <div class="col-12 col-md-4">
              <button class="btn btn-light w-100 w-md-auto" style="border-radius: 16px;" id="searchavailability"
                type="button" data-module="{{ product.module }}" data-idp="{{ product.id }}" disabled>Search
                Availability</button>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-12">
            <h6 style="color: red; padding-left: 18px;padding-top: 10px; padding-right: 10px;">Not Available</h6>
          <p style="padding-top: 9px;">Currently it is not possible to book this product due to its limited availability.</p>
          </div>
        </div>
        {% elseif product.modules == 9 %}
        <div class="row rental-container mt-5" style="background-color: #f0f0f0 !important; ">
          <div class="col-12 col-md-8 col-lg-9 rental-form">
            <div class="form-group">
              <label class="poppins-semibold">Delivery Date</label>
              <div class="input-wrapper" style="border-right: solid 2px #dadada; border-radius: 10px 0 0 10px;">
                <i class="fa fa-calendar" style="color: #dadada;"></i>
                <input type="text" readonly placeholder="Select date">
              </div>
            </div>
            <div class="form-group">
              <label class="poppins-semibold">Return Date</label>
              <div class="input-wrapper"
                style="border-right: solid 2px #f4f4f4; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                <i class="fa fa-calendar" style="color: #dadada;"></i>
                <input type="text" readonly placeholder="Select date">
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4 col-lg-3 d-flex align-items-center justify-content-center mt-2">
            <button class="btn btn-light w-100 w-md-auto"
              style="padding: 8px 10px; border-radius: 10px; background-color: #fff;" disabled
              type="button" data-module="{{ product.module }}" data-idp="{{ product.id }}">Search Availability</button>
          </div>
        </div>
        <div class="row">
          <h6 style="color: red; padding-left: 18px;padding-top: 10px; padding-right: 10px;">Not Available</h6>
          <p style="padding-top: 9px;">Currently it is not possible to book this product due to its limited availability.</p>
        </div>
        {% else %}
        <div class="row rental-container mt-5" style="background-color: #f0f0f0 !important; ">
          <div class="col-12 col-md-8 col-lg-9 rental-form">
            <div class="form-group">
              <label class="poppins-semibold">Start Date</label>
              <div class="input-wrapper" style="border-right: solid 2px #dadada; border-radius: 10px 0 0 10px;">
                <i class="fa fa-calendar" style="color: #dadada;"></i>
                <input type="text" readonly placeholder="Select date">
              </div>
            </div>
            <div class="form-group">
              <label class="poppins-semibold">End Date</label>
              <div class="input-wrapper"
                style="border-right: solid 2px #f4f4f4; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                <i class="fa fa-calendar" style="color: #dadada;"></i>
                <input type="text" readonly placeholder="Select date">
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4 col-lg-3 d-flex align-items-center justify-content-center mt-2">
            <button class="btn btn-light w-100 w-md-auto"
              style="padding: 8px 10px; border-radius: 10px; background-color: #fff;" disabled
              type="button" data-module="{{ product.module }}" data-idp="{{ product.id }}">Search Availability</button>
          </div>
        </div>
        <div class="row">
          <h6 style="color: red; padding-left: 18px;padding-top: 10px; padding-right: 10px;">Not Available</h6>
          <p style="padding-top: 9px;">Currently it is not possible to book this product due to its limited availability.</p>
        </div>
        {% endif %}

      </div>
    </form>
    <div class="col-sm-12 mt-4">
      <div id="show_result"></div>
    </div>
    <div class="faq-section mt-4">
    <div id="faqAccordion" class="accordion">
      {% for faq in faqs %}
      <div class="card">
        <div class="card-header" id="heading{{ loop.index }}">
          <h5 class="mb-0">
            <button class="btn btn-link collapsed w-100 px-3"
              data-toggle="collapse" data-target="#collapse{{ loop.index }}" aria-expanded="false"
              aria-controls="collapse{{ loop.index }}">
              <span class="faq-question text-left">{{ faq.question }}</span>
              <span class="u-accordion__control-icon ml-auto">
                <i class="fa fa-angle-down"></i>
                <i class="fa fa-angle-up"></i>
              </span>
            </button>
          </h5>
        </div>

        <div id="collapse{{ loop.index }}" class="collapse" aria-labelledby="heading{{ loop.index }}"
          data-parent="#faqAccordion" style="margin-left: 20px;">
          <div class="card-body">
            {{ faq.answer }}
          </div>
        </div>
      </div>
      {% endfor %}
    </div>
</div>

  </div>
  {% endif %}

  <div class="row row-mobile">
    <div class="col-12 my-5" style="font-size: 12px;">
      {% if (product.itinerary is not empty and product.itinerary|striptags is not empty)
      or (product.inclusion_exclusion is not empty and product.inclusion_exclusion|striptags is not empty)
      or (product.policy is not empty and product.policy|striptags is not empty) %}
      <div class="side-bar-container">
        <div id="text" class="text">
          <div id="content">
            {% if product.itinerary is not empty and product.itinerary|striptags is not empty %}
            <div class="itinerary">
              <h3 class="pt-4 pb-2 text-center">Itinerary</h3>
              <h6>{{ product.itinerary }}</h6>
            </div>
            {% endif %}

            {% if product.inclusion_exclusion is not empty and product.inclusion_exclusion|striptags is not empty %}
            <div class="inclusion-exclusion">
              <h3 class="pt-4 pb-2 text-center">Inclusion / Exclusion</h3>
              <h6>{{ product.inclusion_exclusion }}</h6>
            </div>
            {% endif %}

            {% if product.policy is not empty and product.policy|striptags is not empty %}
            <div class="policy pb-5">
              <h3 class="pt-4 pb-2 text-center">Policy</h3>
              <h6>{{ product.policy }}</h6>
            </div>
            {% endif %}
          </div>
          <div id="fade" class="fade">p</div>
        </div>
        <span id="read-more" class="read-more g-font-size-14">Read More</span>
      </div>
      {% endif %}

    </div>
  </div>

</section>

<script>
  Fancybox.bind("[data-fancybox]", {
    type: "image",
    animated: true,
    dragToClose: true,
  });

  Fancybox.bind("[data-fancybox='image']", {
    type: "image",
    animated: true,
    dragToClose: true,
  });

  Fancybox.bind("[data-fancybox='video']", {
    type: "video",
    animated: true,
    dragToClose: true,
  });

  function openReviewTab() {
    const reviewTabTrigger = document.getElementById("review-tab");
    if (reviewTabTrigger) {
      const tab = new bootstrap.Tab(reviewTabTrigger);
      tab.show();

      setTimeout(() => {
        const reviewContent = document.querySelector("#review-content");
        if (reviewContent) {
          reviewContent.scrollIntoView({ behavior: "smooth" });
        }
      }, 300);
    }
  }
  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll('.read-more-toggle').forEach(function (button) {
      button.addEventListener('click', function () {
        const card = button.closest('.card-review');
        const shortText = card.querySelector('.review-short');
        const fullText = card.querySelector('.review-full');

        if (fullText.classList.contains('d-none')) {
          shortText.classList.add('d-none');
          fullText.classList.remove('d-none');
          button.textContent = 'Show Less';
        } else {
          fullText.classList.add('d-none');
          shortText.classList.remove('d-none');
          button.textContent = 'Read More';
        }
      });
    });

    const textContainer = document.querySelector(".text");
    const readMoreButton = document.getElementById("read-more");
    const fadeElement = document.getElementById("fade");

    const fullHeight = textContainer.scrollHeight;
    const limitHeight = 900;

    if (window.location.hash === "#review-content") {
      openReviewTab();
    }

    if (fullHeight <= limitHeight + 50) {
      readMoreButton.style.display = "none";
      fadeElement.style.display = "none";
    }

    readMoreButton.addEventListener("click", function () {
      const isExpanded = textContainer.classList.contains("expanded");

      if (isExpanded) {
        textContainer.classList.remove("expanded");
        readMoreButton.innerText = "Read More";
        fadeElement.classList.remove("hidden");
      } else {
        textContainer.classList.add("expanded");
        readMoreButton.innerText = "Read Less";
        fadeElement.classList.add("hidden");
      }
    });

  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>