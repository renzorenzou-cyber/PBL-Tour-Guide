<!-- Swiper CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5/dist/fancybox/fancybox.css" />
<style>
  .gallery img {
    border-radius: 10px;
    transition: transform 0.2s ease;
    cursor: pointer;
  }

  .gallery img:hover {
    transform: scale(1.03);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
  }
</style>


<!-- Fancybox 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<!-- Header Section -->
<div class="header-gradient mt-5 pt-5">
  <div class="container">
    <div class="d-flex justify-content-between align-items-center">
      <?php /* ?>
      <nav class="breadcrumb bg-transparent p-0 mb-2 text-muted">
        <a href="#" class="poppins-medium text-muted"> Wellness /</a>
        <a href="#" class="poppins-medium text-muted"> Mobile Massage /</a>
        <a href="#" class="poppins-medium text-muted"> Bali /</a>
        <a href="#" class="poppins-medium text-muted"> Ubud / </a>
        <span class="poppins-medium" style="color: #4B944D;">Tropialis</span>
      </nav>
      <?php */ ?>

      <!-- <div class="d-flex justify-content-end mt-3">
        <button class="icon-btn"><i class="bi bi-heart"></i></button>
        <button class="icon-btn"><i class="bi bi-share"></i></button>
        </div> -->
    </div>

    <h1 class="poppins-bold g-color-black">{{provider.name}}</h1>
    <span class="poppins-medium"><i class="bi bi-geo-alt mr-2" style="font-size: 18px;"></i>{{provider.address}} <a
       class="fw-semibold" id="showMapBtn" style="color: #72c02c;cursor: pointer;">Show Map</a></span>
    <?php /*?>
    <p class="poppins-medium"><i class="bi bi-clock mr-2" style="font-size: 18px;"></i>Opening hours: 09:00-22:00 <span
        class="fw-semibold">See Opening Hours</span></p>
    <?php */ ?>

  </div>
</div>

<?php
function buildImageUrl($picUrl, $url) {
    $url = ltrim($url, '/');
    $base = rtrim($picUrl, '/') . '/';

    if (strpos($url, 'uploads/') === 0) {
        $url = substr($url, strlen('uploads/'));
    }

    return $base . $url;
}
?>

<!-- Gallery Section -->
<div class="container gallery-container mt-5 mb-5">
  <?php if (count($uploadedVideos) > 0): ?>
    <!-- VIDEO + PHOTO LAYOUT -->
    <div class="row g-3 gallery d-none d-lg-flex" style="row-gap: 25px;">
      <div class="col-lg-6 gallery-main">
        <a
          href="<?= buildImageUrl($picUrl, $uploadedVideos[0]->url) ?>"
          data-fancybox="video"
          data-type="video"
          data-caption="<?= $uploadedVideos[0]->name ?>">
          <div class="ratio ratio-16x9 shadow" style="max-height: 350px; overflow: hidden;">
            <video class="w-100 h-100" controls style="object-fit: cover;">
              <source src="<?= buildImageUrl($picUrl, $uploadedVideos[0]->url) ?>" type="video/mp4">
            </video>
          </div>
        </a>
      </div>
      <div class="col-lg-6">
        <div class="row" style="row-gap: 18px;">
          <?php foreach ($uploadedPhotos as $index => $photo): ?>
            <?php if ($index < 5): ?>
              <div class="col-6 gallery-thumb">
                <a href="<?= buildImageUrl($picUrl, $photo->url) ?>" data-fancybox="gallery">
                  <img src="<?= buildImageUrl($picUrl, $photo->url) ?>" class="img-fluid shadow-sm" />
                </a>
              </div>
            <?php else: ?>
              <a href="<?= buildImageUrl($picUrl, $photo->url) ?>" data-fancybox="gallery" class="d-none">
                <img src="<?= buildImageUrl($picUrl, $photo->url) ?>" />
              </a>
            <?php endif; ?>
          <?php endforeach; ?>
        </div>
      </div>
    </div>

  <?php elseif (count($uploadedPhotos) > 0): ?>
    <!-- PHOTO ONLY LAYOUT -->
    <div class="row g-3 gallery d-none d-lg-flex" style="row-gap: 25px;">
      <div class="col-lg-6 gallery-main">
        <a href="<?= buildImageUrl($picUrl, $uploadedPhotos[0]->url) ?>" data-fancybox="gallery">
          <img src="<?= buildImageUrl($picUrl, $uploadedPhotos[0]->url) ?>" class="img-fluid shadow-sm" />
        </a>
      </div>
      <div class="col-lg-6">
        <div class="row" style="row-gap: 18px;">
          <?php foreach ($uploadedPhotos as $index => $photo): ?>
            <?php if ($index == 0) continue; ?>
            <?php if ($index < 5): ?>
              <div class="col-6 gallery-thumb">
                <a href="<?= buildImageUrl($picUrl, $photo->url) ?>" data-fancybox="gallery">
                  <img src="<?= buildImageUrl($picUrl, $photo->url) ?>" class="img-fluid shadow-sm" />
                </a>
              </div>
            <?php else: ?>
              <a href="<?= buildImageUrl($picUrl, $photo->url) ?>" data-fancybox="gallery" class="d-none">
                <img src="<?= buildImageUrl($picUrl, $photo->url) ?>" />
              </a>
            <?php endif; ?>
          <?php endforeach; ?>
        </div>
      </div>
    </div>

  <?php elseif (count($randomProductImages) > 0): ?>
    <!-- FALLBACK RANDOM PRODUCT IMAGES -->
    <div class="row g-3 gallery d-none d-lg-flex" style="row-gap: 25px;">
      <div class="col-lg-6 gallery-main">
        <a href="<?= buildImageUrl($picUrl, $randomProductImages[0]->url) ?>" data-fancybox="gallery">
          <img src="<?= buildImageUrl($picUrl, $randomProductImages[0]->url) ?>" class="img-fluid shadow-sm" />
        </a>
      </div>
      <div class="col-lg-6">
        <div class="row" style="row-gap: 18px;">
          <?php foreach ($randomProductImages as $index => $img): ?>
            <?php if ($index == 0) continue; ?>
            <?php if ($index < 5): ?>
              <div class="col-6 gallery-thumb">
                <a href="<?= buildImageUrl($picUrl, $img->url) ?>" data-fancybox="gallery">
                  <img src="<?= buildImageUrl($picUrl, $img->url) ?>" class="img-fluid shadow-sm" />
                </a>
              </div>
            <?php else: ?>
              <a href="<?= buildImageUrl($picUrl, $img->url) ?>" data-fancybox="gallery" class="d-none">
                <img src="<?= buildImageUrl($picUrl, $img->url) ?>" />
              </a>
            <?php endif; ?>
          <?php endforeach; ?>
        </div>
      </div>
    </div>
  <?php endif; ?>

  <!-- Mobile Carousel -->
   <div class="row d-block d-lg-none mx-1">
    <div class="swiper mySwiper">
      <div class="swiper-wrapper">
        <?php foreach($randomProductImages as $photos) :?>
        <div class="swiper-slide">
          <img src="<?= buildImageUrl($picUrl, $photos->url) ?>" alt="Image 1">
        </div>
        <?php endforeach; ?>
      </div>

      <!-- Navigation Buttons -->
      <div class="swiper-button-prev"></div>
      <div class="swiper-button-next"></div>
    </div>

   </div>
</div>

<div class="container mb-5">
  <div class="row">
    <div class="col-12 horizontal-menu-wrapper">
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a class="nav-link {% if 'review' not in current_path and 'products' not in current_path and 'location' not in current_path %}active{% endif %}"
            data-bs-toggle="tab" data-tab="overview" href="#overview-content">Overview</a>
        </li>
        <li class="nav-item">
          <a class="nav-link {% if 'products' in current_path %}active{% endif %}" data-bs-toggle="tab" href="#product"
            data-tab="products" id="product-tab">Products</a>
        </li>
        <li class="nav-item">
          <a class="nav-link {% if 'reviews' in current_path %}active{% endif %}" data-bs-toggle="tab" href="#review"
            data-tab="review" id="review-tab">Review</a>
        </li>
        <li class="nav-item">
          <a class="nav-link {% if 'location' in current_path %}active{% endif %}" data-bs-toggle="tab" href="#location"
            data-tab="location" id="location-tab">Location</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="tab-content pt-3">
    <!-- OVERVIEW -->
    <div
      class="tab-pane {% if 'review' not in current_path and 'products' not in current_path and 'location' not in current_path %}active{% endif %}"
      id="overview-content">
      <div class="row">
        <div class="col-8 col-lg-7 mt-4 col-sm-9">
          <div class="details__caption">
            <div class="d-flex align-items-center mb-3" style="gap: 10px;">
              <div class="poppins-medium">
                <h2 class="g-color-black poppins-bold">{{provider.name}}</h2>
                <div class="d-flex justify-content-start d-block d-md-block d-lg-none">
                  <button class="btn-promo poppins-medium py-2 px-3"><i class="bi bi-percent"></i> Get the Best Deals
                    with Us!</button>
                </div>
                <div class="d-flex align-items-center" style="gap: 10px;">
                  <i class="bi bi-star-fill text-warning" style="font-size: 30px;"></i>
                  <div class="d-flex align-items-end" style="gap: 3px;">
                    <h4 class="m-0 g-color-black">{{average_rating}} /</h4>
                    <h5 class="m-0 g-color-black"> 5</h5>
                    <span class="g-color-black ml-2 d-none d-md-block"> ({{total_review}} reviews • {{ordered}} sold)</span>
                  </div>
                </div>
                <span class="g-color-black ml-5 d-block d-md-none"> ({{total_review}} reviews • {{ordered}} sold)</span>
                <span>{{provider.description}}</span>
              </div>
            </div>
          </div>
        </div>

        <div class="col-4 col-lg-5 col-sm-3 mt-4">
          <div class="justify-content-end mb-3 d-none d-md-none d-lg-flex">
            <button class="btn-promo poppins-medium py-2 px-3"><i class="bi bi-percent"></i> Get the Best Deals with
              Us!</button>
          </div>
          <h6 class="text-right">Start form</h6>
          <h4 class="text-right poppins-semibold g-color-black">
            <span class="activecurrency"></span>
            <span class="valuecurrency" data-baseprice="{{ cheapest.publish_price }}">
          </h4>
          <div class="d-flex justify-content-end">
            <?php /*?><button class="btn-highlight poppins-medium py-2 px-4">See Highlight</button><?php */ ?>
          </div>
        </div>

      </div>

      <?php /* ?><div class="row">
        <div class="col-12 card highlights-card shadow p-4">
          <h3 class="poppins-bold g-color-black">
            Highlights
          </h3>
          <p class="poppins-medium">Lorem ipsum, dolor sit amet consectetur adipisicing elit. Quae quisquam quis aliquam
            perferendis esse amet id soluta aut quaerat, voluptate suscipit sint magnam minima dolor consequuntur cumque
            velit do.</p>
          <ul>
            <li class="poppins-medium">Customizable Sessions</li>
            <li class="poppins-medium">Convenience at Your Doorstep</li>
            <li class="poppins-medium">Expert Therapists</li>
            <li class="poppins-medium">Suitable for: Group Traveler & Family Vacationer</li>
          </ul>
          <p class="poppins-medium">Lorem ipsum, dolor sit amet consectetur adipisicing elit. Quae quisquam quis aliquam
            perferendis esse amet id soluta aut quaerat, voluptate suscipit sint magnam minima dolor consequuntur cumque
            velit do.</p>
          <ul>
            <li class="poppins-medium">Convenience at Your Doorstep</li>
            <li class="poppins-medium">Expert Therapists</li>
            <li class="poppins-medium">Customizable Sessions</li>
            <li class="poppins-medium">Convenience at Your Doorstep</li>
            <li class="poppins-medium">Expert Therapists</li>
            <li class="poppins-medium">Suitable for: Group Traveler & Family Vacationer</li>
          </ul>
        </div>
      </div><?php */ ?>
    </div>

    <!-- PRODUCT -->
    <div class="tab-pane {% if 'products' in current_path %}active{% endif %}" id="product">
      <?php /* ?>
      <div class="d-flex justify-content-start my-4">
        <button class="btn-promo poppins-medium py-2 px-3">Packages</button>
      </div>
      <div class="row card-product shadow px-3 py-4 my-3">
        <div class="col-3">
          <img src="{{ url() }}img/7.jpg" class="product-thumb" alt="">
        </div>
        <div class="col-6">
          <h4 class="poppins-semibold g-color-black">Balinese Massage + Pedicure</h4>
          <div class="d-flex align-items-center mb-4" style="gap: 8px;">
            <div class="d-flex" style="gap: 5px;">
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star text-warning" style="font-size: 16px;"></i>
            </div>
            <span class="poppins-medium">4.3 / 5.0 (5)</span>
          </div>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Esse animi reiciendis illum inventore debitis,
            fugit autem.. <a href="" class="details-product">See Details</a></p>
        </div>
        <div class="col-3 my-auto" style="border-left: 2px dashed #ccc; width: 100%;">
          <h6 class="text-left card-product-text poppins-medium">Start from</h6>
          <div class="d-flex price-flex align-items-center justify-content-start" style="gap: 5px;">
            <h4 class="poppins-semibold" style="color: #000;">IDR 400.000 </h4>
            <h6>/ packages</h6>
          </div>
          <div class="d-flex justify-content-start card-product-button">
            <button class="product-btn poppins-medium py-2 px-4">Book Now</button>
          </div>
        </div>
      </div>
      <div class="row card-product d-flex shadow px-3 py-4 my-3">
        <div class="col-3">
          <img src="{{ url() }}img/7.jpg" class="product-thumb" alt="">
        </div>
        <div class="col-6">
          <h4 class="poppins-semibold g-color-black">Balinese Massage + Pedicure</h4>
          <div class="d-flex align-items-center mb-4" style="gap: 8px;">
            <div class="d-flex" style="gap: 5px;">
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star text-warning" style="font-size: 16px;"></i>
            </div>
            <span class="poppins-medium">4.3 / 5.0 (5)</span>
          </div>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Esse animi reiciendis illum inventore debitis,
            fugit autem.. <a href="" class="details-product">See Details</a></p>
        </div>
        <div class="col-3 my-auto" style="border-left: 2px dashed #ccc; width: 100%;">
          <h6 class="text-left card-product-text poppins-medium">Start from</h6>
          <div class="price-flex d-flex align-items-center justify-content-start" style="gap: 5px;">
            <h4 class="poppins-semibold" style="color: #000;">IDR 400.000 </h4>
            <h6>/ packages</h6>
          </div>
          <div class="d-flex justify-content-start card-product-button">
            <button class="product-btn poppins-medium py-2 px-4">Book Now</button>
          </div>
        </div>
      </div>
      <div class="row card-product d-flex shadow px-3 py-4 my-3">
        <div class="col-3">
          <img src="{{ url() }}img/7.jpg" class="product-thumb" alt="">
        </div>
        <div class="col-6">
          <h4 class="poppins-semibold g-color-black">Balinese Massage + Pedicure</h4>
          <div class="d-flex align-items-center mb-4" style="gap: 8px;">
            <div class="d-flex" style="gap: 5px;">
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star-fill text-warning" style="font-size: 16px;"></i>
              <i class="bi bi-star text-warning" style="font-size: 16px;"></i>
            </div>
            <span class="poppins-medium">4.3 / 5.0 (5)</span>
          </div>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Esse animi reiciendis illum inventore debitis,
            fugit autem.. <a href="" class="details-product">See Details</a></p>
        </div>
        <div class="col-3 my-auto" style="border-left: 2px dashed #ccc; width: 100%;">
          <h6 class="text-left poppins-medium card-product-text">Start from</h6>
          <div class="d-flex price-flex align-items-center justify-content-start" style="gap: 5px;">
            <h4 class="poppins-semibold" style="color: #000;">IDR 400.000 </h4>
            <h6>/ packages</h6>
          </div>
          <div class="d-flex justify-content-start card-product-button">
            <button class="product-btn poppins-medium py-2 px-4">Book Now</button>
          </div>
        </div>
      </div>
      <?php */ ?>

      <div class="d-flex justify-content-start my-4">
        <button class="btn-promo poppins-medium py-2 px-3">Products</button>
      </div>
      {% for p in products %}
      <div class="row card d-flex flex-row shadow mobile-card" style="margin-bottom: 1rem;">
        <!-- Image -->
        <figure class="col-12 col-md-4 image-margin">
          <div class="swiper-container" data-product-id="{{ p.id }}">
            <div class="swiper-wrapper">
              {% for image in images %}
                {% if image.id == p.id %}
                  <div class="swiper-slide">
                    <a href="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}"
                      data-fancybox="{{ p.id }}"
                      data-caption="{{ p.name }}">
                      <img src="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" alt="{{ p.name }}">
                    </a>
                  </div>
                {% endif %}
              {% endfor %}
            </div>

            <!-- Navigasi Swiper -->
            <div class="swiper-button-next" style="color:white; width: 50px; height: 0px;"></div>
            <div class="swiper-button-prev" style="color:white; width: 50px; height: 0px;"></div>
          </div>

          <div class="d-flex justify-content-between">
            {# Tombol wishlist jika ingin diaktifkan kembali #}
            {#
            <div class="heart-icon">
              <i class="bi bi-heart wishlist hearticon_{{ p.id }}" data-wishlist="{{ p.id }}"></i>
            </div>
            #}
          </div>
        </figure>
        <!-- End Image -->

        <!-- Konten -->
        <div class="col-12 col-md-5 card-konten" style="border-right: 2px dashed #ccc;">
          <div class="card-top">
            <figcaption class="category poppins-medium mb-3">{{ p.group_product }}</figcaption>
            <a class="h5 poppins-semibold card-title truncate-text"
              href="{{ url() }}{{ p.id }}/{{ p.slug }}/">{{ p.name }}</a>
            <div class="text-muted mb-2" style="font-size: 14px;">
              <?php $stats = $reviewStats[$p->id]; ?>
              <?php if ($stats['average_rating'] > 0): ?>

              <?php if (!empty($stats['is_provider']) && $stats['is_provider']): ?>
              <div class="provider-rating g-color-black mb-2">
                <i class="bi bi-shop"></i>
                <span>Provider Rating</span>
              </div>
              <?php endif; ?>

              <div class="d-flex align-items-center" style="gap: 3px;">
                <div class="d-flex align-items-center" style="gap: 8px;">
                  <?php
                          $rating = number_format($stats['average_rating'], 1);
                          echo '<i class="bi bi-star-fill text-warning"></i> ';
                        ?>
                  <?= $stats['average_rating'] ?>
                </div>
                <?php if ($p->ordered > 0): ?>
                <span>・</span>
                <span>
                  <?= ($p->ordered >= 1000) 
                            ? (intval($p->ordered / 1000) == ($p->ordered / 1000) 
                                ? intval($p->ordered / 1000) 
                                : number_format($p->ordered / 1000, 1)
                              ) . 'k' 
                            : $p->ordered 
                        ?> booked
                </span>
                <?php endif; ?>
              </div>

              <?php else: ?>
              <div class="new-product g-color-black mb-2">
                <i class="bi bi-tag"></i>
                <span>New Product</span>
              </div>
              <?php endif; ?>

              <div class="card-description">
                <p class="mt-5">
                  <?= $p->page_title ?>
                </p>
              </div>

            </div>

          </div>
        </div>

        <!-- price -->
        <div class="col-12 col-md-3" style="margin-top: auto;">
          <div class="price" style="margin-right: auto;">
            <span class="start-from text-muted poopins-medium">Start from</span>
            {% if hotdeals[p.id] is defined and hotdeals[p.id]['discounted_price'] > 0 %}
            <br><span class="g-color-black g-font-weight-600 original-price" style="color: red;font-size: 11pt;">
              <span style="text-decoration: line-through;color: red;font-size: 11pt;">
                <span class="activecurrency"></span>
                <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['rate_option_price'] }}">
                </span>
              </span>
            </span><br>
            <span class="g-color-black g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
              <span class="activecurrency"></span>
              <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['discounted_price'] }}">
              </span>
            </span>
            {% else %}
            <br><span class="g-color-black g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
              <span class="activecurrency"></span>
              <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['min_publish_price'] }}">
              </span>
            </span>
            {% endif %}
          </div>
          <div class="see-details mt-3">
            <a href="{{ url() }}{{ p.id }}/{{ p.slug }}/" style="text-decoration-line: none;">
              <div class="d-flex justify-content-center align-items-center hover-move py-1"
                style="cursor: pointer; padding-bottom: .5rem;">
                <span>See details</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor"
                  class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                  <path fill-rule="evenodd"
                    d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8" />
                </svg>
              </div>
            </a>
          </div>
        </div>
      </div>
      {% endfor %}

      <!-- pagination -->
      {% if totalPages > 1 %}
      <div class="pagination" id="pagination-container">
        <ul>
          {% if currentPage > 1 %}
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <a href="{{ url.get('provider/' ~ provider.slug ~ '/products/' ~ (currentPage - 1)) }}"
              style="text-decoration: none; color: inherit;">
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
            <a href="{{ url.get('provider/' ~ provider.slug ~ '/products/' ~ i) }}"
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
              <a href="{{ url.get('provider/' ~ provider.slug ~ '/products/' ~ (currentPage + 1)) }}"
                style="text-decoration: none; color: inherit;">
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
      <!-- pagination end -->
    </div>

    <!-- REVIEW -->
    <div class="tab-pane {% if 'reviews' in current_path %}active{% endif %}" id="review">
      <div class="row mt-4">
        <div class="col-12 d-flex justify-content-between">
          <h2 class="poppins-bold g-color-black">Review</h2>
          <?php /* ?><div class="d-flex align-items-center" style="gap: 15px;">
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
                  <li><a class="dropdown-item" href="{{ url.get( 'provider/'~ provider.slug ~'/reviews/rating/5') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>5</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item" href="{{ url.get( 'provider/'~ provider.slug ~'/reviews/rating/4') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>4</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item" href="{{ url.get( 'provider/'~ provider.slug ~'/reviews/rating/3') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>3</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item" href="{{ url.get( 'provider/'~ provider.slug ~'/reviews/rating/2') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>2</span>
                      </div>
                    </a></li>
                  <li><a class="dropdown-item" href="{{ url.get( 'provider/'~ provider.slug ~'/reviews/rating/1') }}">
                      <div class="d-flex align-items-center" style="gap: 5px;">
                        <i class="bi bi-star-fill text-warning"></i>
                        <span>1</span>
                      </div>
                    </a></li>
                </ul>
              </div>
            </div>
          </div>
          <div class="d-flex align-items-center" style="gap: 8px;">
            <span class="review-filter">Sort by:</span>
            <div class="dropdown dropdown-custom">
              <button class="btn py-2 dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                Highest to Lowest
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="#">Highest to Lowest</a>
                </li>
                <li><a class="dropdown-item" href="#">Lowest to Highest</a>
                </li>
                <li><a class="dropdown-item" href="#">Latest</a></li>
                <li><a class="dropdown-item" href="#">Oldest</a></li>
              </ul>
            </div>
          </div><?php */?>
        </div>
      </div>
      <div class="col-12 review-star">
        <div class="d-flex align-items-center" style="gap: 10px;">
          <i class="bi bi-star-fill text-warning" style="font-size: 30px;"></i>
          <div class="d-flex align-items-end" style="gap: 3px;">
            <h4 class="m-0 g-color-black">{{average_rating}} /</h4>
            <h5 class="m-0 g-color-black"> 5</h5>
            <span class="g-color-black ml-2"> ({{total_review}} reviews • {{ordered}} sold)</span>
          </div>
        </div>
      </div>

      <!-- review content -->
      <div class="row mt-2">
        <?php if (isset($review) && is_array($review) && count($review) > 0): ?>
        <?php foreach ($review as $rev): ?>
        <?php if (is_array($rev) && isset($rev['review_name'])): ?>
        <div class="col-12 mb-4">
          <div class="card p-3 card-review shadow h-100">
            <h5 class="g-color-black poppins-semibold" style="margin: 0px !important;">
              <?= $rev['review_name'] ?>
            </h5>

            <div class="my-2 d-flex align-items-center" style="gap: 5px;">
              <?php for ($i = 1; $i <= 5; $i++): ?>
              <?php if ($i <= $rev['review_star']): ?>
              <i class="bi bi-star-fill text-warning" style="font-size: 17px;"></i>
              <?php else: ?>
              <i class="bi bi-star text-warning" style="font-size: 17px;"></i>
              <?php endif; ?>
              <?php endfor; ?>
              <span class="ml-1">
                <?= $rev['review_star'] ?>
              </span>
            </div>

            <div>
              <strong class="g-color-black">
                <?= $rev['product_name'] ?>
              </strong><br>
              <span class="mb-1">
                <?= $rev['rate_name'] ?> /
                <?= $rev['rate_opt_name'] ?> •
                <?= $rev['formatted_date'] ?>
              </span>
            </div>

            <?php
                      $words = explode(' ', $rev['review_comment']);
                      $maxWords = 25;
                      $isLong = count($words) > $maxWords;
                      $previewText = implode(' ', array_slice($words, 0, $maxWords));
                    ?>

            <div class="card-review mt-2">
              <p class="review-short mb-0">
                <?= $previewText ?>
                <?= $isLong ? '...' : '' ?>
              </p>

              <?php if ($isLong): ?>
              <p class="review-full d-none mb-0">
                <?= $rev['review_comment'] ?>
              </p>
              <button class="btn btn-link p-0 read-more-toggle">Read More</button>
              <?php endif; ?>

              <!-- GAMBAR -->
              <?php if (!empty($rev['images'])): ?>
              <div class="review-gallery mt-2" id="review-gallery-<?= $rev['review_id'] ?>">
                <?php foreach ($rev['images'] as $index => $img): ?>
                <?php
                              $totalImages = count($rev['images']);
                              $visibleImages = 4;
                              $isLastVisible = ($index == $visibleImages - 1) && ($totalImages > $visibleImages);
                              $isHidden = ($index >= $visibleImages);
                            ?>
                <a href="<?= $picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $img->name ?>"
                  data-fancybox="gallery-<?= $rev['review_id'] ?>"
                  class="review-image <?= $isHidden ? 'd-none' : '' ?>">
                  <div style="position: relative; display: inline-block;">
                    <img src="<?= $picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $img->name ?>"
                      class="img-fluid me-2 mb-2" style="width:90px;height:90px;object-fit:cover; border-radius: 5px;">
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
                      +
                      <?= $totalImages - $visibleImages + 1 ?> Image
                    </div>
                    <?php endif; ?>
                  </div>
                </a>
                <?php endforeach; ?>
              </div>
              <?php endif; ?>

              <!-- VIDEO -->
              <?php if (!empty($rev['videos'])): ?>
              <div class="review-videos mt-2">
                <?php foreach ($rev['videos'] as $vid): ?>
                <a href="<?= $picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $vid->name ?>" data-fancybox="video"
                  data-type="video" data-caption="Video Review"
                  style="display: inline-block; margin-right: 5px; margin-bottom: 5px;">
                  <video width="160" height="100" muted style="border-radius: 5px; object-fit: cover;">
                    <source src="<?= $picUrl ?>/reviews/<?= $rev['review_id'] ?>/<?= $vid->name ?>" type="video/mp4">
                  </video>
                </a>
                <?php endforeach; ?>
              </div>
              <?php endif; ?>
            </div>

            <!-- REPLY -->
            <?php if (!empty($rev['replies'])): ?>
            <?php foreach ($rev['replies'] as $reply): ?>
            <div class="card-reply mt-3 py-4 px-4">
              <div class="pr-3"><i class="bi bi-reply-all-fill"></i></div>
              <div class="pl-3" style="border-left: 2px solid rgba(75, 148, 77, .5);">
                <h6 class="g-color-black" style="font-size: 15px;">Response from Provider</h6>
                <p class="mb-1">
                  <?= $reply['formatted_date'] ?> /
                  <?= $provider['name'] ?>
                </p>
                <span class="g-color-black">
                  <?= nl2br(htmlspecialchars($reply['review_comment'])) ?>
                </span>

                <!-- REPLY GAMBAR -->
                <?php if (!empty($reply['images'])): ?>
                <div class="reply-images mt-2">
                  <?php foreach ($reply['images'] as $img): ?>
                  <a href="<?= $picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $img->name ?>"
                    data-fancybox="video-<?= $reply['review_id'] ?>">
                    <img src="<?= $picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $img->name ?>" width="80"
                      style="margin-right: 5px; margin-top: 5px; border-radius: 5px; object-fit: cover;">
                  </a>
                  <?php endforeach; ?>
                </div>
                <?php endif; ?>

                <!-- REPLY VIDEO -->
                <?php if (!empty($reply['videos'])): ?>
                <div class="reply-videos mt-2">
                  <?php foreach ($reply['videos'] as $vid): ?>
                  <video width="90" height="90" controls
                    style="margin-right: 5px; margin-bottom: 5px; border-radius: 5px; object-fit: cover;">
                    <source src="<?= $picUrl ?>/reviews/<?= $reply['review_id'] ?>/<?= $vid->name ?>" type="video/mp4">
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
        <?php endif; ?>
        <?php endforeach; ?>
        <?php else: ?>
        <div class="text-center">
          <img src="{{ url() }}img/no-data2.png" style="width: 40%;margin:auto;padding-top: 40px;">
          <p class="mt-3 text-muted">Tidak ada review ditemukan.</p>
        </div>
        <?php endif; ?>
      </div>
      <!-- review content end  -->

      {% set baseReviewUrl = url.get('provider/' ~ provider.slug ~ '/reviews') %}

      {% if totalPagesReview > 1 %}
      <div class="pagination mt-4">
        <ul>
          {% if currentPageReview > 1 %}
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <a href="{{ baseReviewUrl ~ '/' ~ (currentPageReview - 1) }}"
              style="text-decoration: none; color: inherit;">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor"
                stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
                <path fill-rule="evenodd"
                  d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0" />
              </svg>
              <span>Prev</span>
            </a>
          </li>
          {% endif %}

          {% for i in 1..totalPagesReview %}
          {% if i == 1 or i == totalPagesReview or (i >= currentPageReview - 1 and i <= currentPageReview + 1) %} <li
            class="numb {% if i == currentPageReview %}active{% endif %}">
            <a href="{{ baseReviewUrl ~ '/' ~ i }}"
              style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
              <span>{{ i }}</span>
            </a>
            </li>
            {% elseif i == currentPageReview - 2 or i == currentPageReview + 2 %}
            <li class="dots"><span>...</span></li>
            {% endif %}
            {% endfor %}

            {% if currentPageReview < totalPagesReview %} <li
              class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
              <a href="{{ baseReviewUrl ~ '/' ~ (currentPageReview + 1) }}" style="text-decoration: none; color: inherit;">
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

    <!-- LOCATION -->
    <div class="tab-pane {% if 'location' in current_path %}active{% endif %}" id="location">
      <div class="row mt-4">
        <div class="col-12">
          <h2 class="poppins-bold g-color-black">Location</h2>
          <a id="openMap">
            <div id="mapPreview" data-latitude="{{ provider.latitude }}" data-longitude="{{ provider.longitude }}"
              data-provider="{{ provider.name }}">
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
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5/dist/fancybox/fancybox.umd.js"></script>
<script>
  const swiper = new Swiper(".mySwiper", {
    loop: true,
    autoplay: {
      delay: 3000,
      disableOnInteraction: false,
    },
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
  });

  Fancybox.bind("[data-fancybox='video']", {
    type: "video",
    animated: true,
    dragToClose: true,
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
  });
</script>