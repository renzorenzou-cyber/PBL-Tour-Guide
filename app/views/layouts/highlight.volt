<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Antigua&display=swap" rel="stylesheet">

<!-- Promo Block - Parallax -->
<section class="dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll dzsprx-readyall" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}'>
  <div class="divimage dzsparallaxer--target w-100 u-bg-overlay g-bg-img-hero g-bg-black-opacity-0_4--after " style="height: 130%; background-image: url({{ url() }}img/bg2.jpg);"></div>

  <!-- Promo Block Content -->
  <div class="container u-bg-overlay__inner text-start g-py-150">
    <h4 class="hero-headline_h4">
      More Than Travel
    </h4>
    <h1 class="h1 hero-headline_h1">It’s Our <span>Passion</span> for Your <span>Journey</span>
    </h1>
    <p class="hero-subtext g-color-white text-start">Tropialis come with expert local guides, seamless travel planning, and exceptional customer service, Tropialis ensures every journey is tailored to your interests and preferences.</p>

      <!-- Search Form -->
      <form id="search_form">
        <div class="row">
          <div class="col-12 col-md-9 col-lg-9 search-row">
            <div class="row search-box" style="row-gap: 10px;">
              <div class="col-11 col-md-8 col-lg-8 search-column d-flex align-items-center justify-content-start">
                <i class="bi bi-search"></i>
                <span id="typingOverlay" class="position-absolute typing-placeholder" style="left: 45px; top: 50%; transform: translateY(-50%); color: #999; pointer-events: none;"></span>
                <input id="search" type="text" name="search" >
              </div>
                
                <div class="col-12 col-md-4 col-lg-4 d-flex justify-content-end button-search">
                  <button id="btn-search" class="w-100">Search</button>
                </div>
            </div>

            <!-- Checkboxes -->
            <?php /*?><div class="g-font-size-15">
              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25">
                <input class="g-hidden-xs-up" type="checkbox" checked>
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Recent
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Related
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Popular
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Most common
              </label><?php */?>
              <!-- End Label -->
            </div>
            <!-- End Checkboxes -->
          </div>
        </div>
      </form>
    <!-- End Search Form -->
     
      <!-- Search Form -->
      <form id="search_form" class="d-none">
        <div class="row">
          <div class="col-12 col-md-9 col-lg-9 search-row">
            <div class="row search-box" style="row-gap: 10px;">
              <div class="col-11 col-md-5 col-lg-5 search-column d-flex align-items-center" style="margin: 0 auto;">
                <i class="bi bi-search"></i>
                <input id="search" type="text" name="search" placeholder="Find Hotel/Villas, and Things To Do" style="border-right: 1px solid rgba(0, 0, 0, 0.2);">
              </div>
                <?php /* ?><li class="col-12 col-md-4 col-lg-4 list-inline-item" style="margin-right: 0 !important;">
                  <div class="areas-column d-flex align-items-center">
                    <i class="bi bi-geo-alt" style="margin-left: 10px;"></i>
                    <select class="form-control" name="areas" id="areas" style="border: none;">
                      <option value="">Select areas</option>
                      {% for ar in parent %}
                        <option value="{{ ar.area_url }}">{{ ar.area_name }}</option>
                      {% endfor %}
                    </select>
                  </div>
                </li><?php */ ?>
                <div class="col-12 col-md-3 col-lg-3 d-flex justify-content-end button-search">
                  <button id="btn-search" class="w-100" type="button">Search</button>
                </div>
            </div>

            <!-- Checkboxes -->
            <?php /*?><div class="g-font-size-15">
              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25">
                <input class="g-hidden-xs-up" type="checkbox" checked>
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Recent
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Related
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Popular
              </label>
              <!-- End Label -->

              <!-- Label -->
              <label class="form-check-inline u-check g-color-white g-pl-25 g-ml-20--md">
                <input class="g-hidden-xs-up" type="checkbox">
                <div class="u-check-icon-checkbox-v6 g-absolute-centered--y g-left-0">
                  <i class="g-brd-white g-brd-primary--checked g-bg-white g-bg-primary--checked g-transition-0_2 g-transition--ease-in g-rounded-2 fa" data-check-icon="&#xf00c"></i>
                </div>
                Most common
              </label><?php */?>
              <!-- End Label -->
            </div>
            <!-- End Checkboxes -->
          </div>
        </div>
      </form>
    <!-- End Search Form -->
  </div>
  <!-- End Promo Block Content -->
</section>
<!-- End Promo Block - Parallax -->
 