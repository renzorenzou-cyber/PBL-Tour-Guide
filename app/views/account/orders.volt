<style>
  .filepond--credits {
    display: none !important;
  }
</style>

<div class="container g-pt-40 g-pb-30 mt-5">
  <div class="row" style="gap: 10px;">
    <!-- Profile Settings -->
    <div class="col-md-1 col-lg-4 g-mb-50 sidebar d-none d-md-block d-lg-block">
      <aside class="g-px-20">
        <!-- Profile Picture -->
        <div class="profile-section text-center position-relative g-pos-rel g-mb-10">
          <div class="profile-img-wrapper">

            {% set google = session.get('trop_auth') %}
            {% set google_id = session.get('trop_auth')['customer_id'] %}
            {% set google_name = session.get('trop_auth')['customer_name'] %}
            {% set google_email = session.get('trop_auth')['customer_email'] %}
            {% set google_picture = session.get('trop_auth')['customer_picture'] %}

            {% if google_id is defined and google_id == 'google' %}
              <img class="img-fluid rounded-circle" src="{{ google_picture }}" alt="Google Profile Picture">

            {% elseif images is empty %}
              <img class="img-fluid rounded-circle" src="{{ config.vars.picUrl }}/default-avatar.jpg" alt="Default Profile Picture">

            {% else %}
              {% for image in images %}
                <img class="img-fluid rounded-circle"
                    src="{{ config.vars.picUrl }}/customers/{{ customer.id }}/{{ image.picture }}"
                    alt="Profile Picture">
              {% endfor %}
            {% endif %}


            <div class="edit-icon" title="Change Profile Picture" data-toggle="modal"
              data-target="#editProfilePictureModal">
              <i class="bi bi-pencil"></i>
            </div>
          </div>
          <h4 class="d-none d-lg-block mt-4 g-color-black poppins-semibold"><?php echo $this->session->get('trop_auth')['customer_name']?></h4>

        </div>
        <!-- End Profile Picture -->

        <!-- Profile Settings List -->
        <ul class="menu-section list-unstyled g-mb-10 menu">
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'orders' in current_path %}active{% else %}''{% endif %}"
              href="{{ url() }}account/orders/" id="open-orders-tab">
              <div class="u-icon-v1 mr-2">
                <i class="icon-finance-114 u-line-icon-pro"></i>
              </div>
              <span class="menu-list poppins-medium">All Orders</span>
            </a>
          </li>
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'cancelled' in current_path %}active{% else %}''{% endif %}"
              href="{{ url() }}account/cancelled/" id="cancelled-orders-tab">
              <div class="u-icon-v1 mr-2">
                <i class="icon-finance-113 u-line-icon-pro"></i>
              </div>
              <span class="menu-list poppins-medium">Cancelled Orders</span>
            </a>
          </li>
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'review' in current_path %}active{% else %}''{% endif %}" href="{{ url() }}account/review/"
              id="review-tab">
              <div class="u-icon-v1 mr-2">
                <i class="bi bi-star"></i>
              </div>
              <span class="menu-list poppins-medium">Your Reviews</span>
            </a>
          </li>
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'wishlist' in current_path %}active{% else %}''{% endif %}" href="{{ url() }}account/wishlist/"
              id="wishlist-tab">
              <div class="u-icon-v1 mr-2">
                <i class="bi bi-heart"></i>
              </div>
              <span class="menu-list poppins-medium">Wishlist</span>
            </a>
          </li>
        </ul>

        <ul class="security-section list-unstyled mb-0 menu">
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'login_security' in current_path %}active{% else %}''{% endif %}"
              href="{{ url() }}account/login_security/" id="login-security-tab">
              <div class="u-icon-v1 mr-2">
                <i class="bi bi-lock"></i>
              </div>
              <span class="menu-list poppins-medium">Login &amp; Security</span>
            </a>
          </li>
          <li class="g-py-3">
            <a class="d-block align-middle g-color-text g-pa-3 btn-menu" id="logout">
              <div class="d-flex align-items-center" style="gap: 6px;">
                <div class="u-icon-v1">
                  <i class="icon-logout u-line-icon-pro"></i>
                </div>
                <span class="menu-list poppins-medium">Logout</span>
              </div>
            </a>
          </li>
        </ul>
        <!-- End Profile Settings List -->
      </aside>
    </div>
    <!-- End Profile Settings -->

    <!-- Profile Settings (Mobile) -->
    <div class="col-12 sidebar-mobile d-block d-md-none d-lg-none" data-toggle="modal"
              data-target="#editProfilePictureModal">
      <div class="mx-3 d-flex align-items-center justify-content-between" style="gap: 20px;">
        <!-- Profile Picture -->
        <div class="profile-section text-center position-relative g-pos-rel g-mb-10">
          <div class="profile-img-wrapper">
            {% if images is empty %}
            <img class="img-fluid rounded-circle" src="{{ config.vars.picUrl }}/default-avatar.jpg"
              alt="Default Profile Picture">
            {% else %}
            {% for image in images %}
            <img class="img-fluid rounded-circle"
              src="{{ config.vars.picUrl }}/customers/{{ customer.id }}/{{ image.picture }}" alt="Profile Picture">
            {% endfor %}
            {% endif %}
            <div class="edit-icon" title="Change Profile Picture" data-toggle="modal"
              data-target="#editProfilePictureModal">
              <i class="bi bi-pencil"></i>
            </div>
          </div>
          <h4 class="d-none d-lg-block mt-4 g-color-black poppins-semibold">{{customer.name}}</h4>

        </div>
        <!-- End Profile Picture -->

        <!-- Profile Settings List -->
        <div class="horizontal-menu-wrapper">
          <ul class="menu-section d-flex list-unstyled flex-nowrap g-mb-10 menu">
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'orders' in current_path %}active{% else %}''{% endif %}"
                href="{{ url() }}account/orders/" id="open-orders-tab">
                <div class="u-icon-v1 mr-2">
                  <i class="icon-finance-114 u-line-icon-pro"></i>
                </div>
                <span class="menu-list poppins-medium">All Orders</span>
              </a>
            </li>
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'cancelled' in current_path %}active{% else %}''{% endif %}"
                href="{{ url() }}account/cancelled/" id="cancelled-orders-tab">
                <div class="u-icon-v1 mr-2">
                  <i class="icon-finance-113 u-line-icon-pro"></i>
                </div>
                <span class="menu-list poppins-medium">Cancelled Orders</span>
              </a>
            </li>
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'review' in current_path %}active{% else %}''{% endif %}" href="{{ url() }}account/review/"
                id="review-tab">
                <div class="u-icon-v1 mr-2">
                  <i class="bi bi-star"></i>
                </div>
                <span class="menu-list poppins-medium">Your Reviews</span>
              </a>
            </li>
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'wishlist' in current_path %}active{% else %}''{% endif %}" href="{{ url() }}account/wishlist/"
                id="wishlist-tab">
                <div class="u-icon-v1 mr-2">
                  <i class="bi bi-heart"></i>
                </div>
                <span class="menu-list poppins-medium">Wishlist</span>
              </a>
            </li>
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu button-menu {% if 'login_security' in current_path %}active{% else %}''{% endif %}"
                href="{{ url() }}account/login_security/" id="login-security-tab">
                <div class="u-icon-v1 mr-2">
                  <i class="bi bi-lock"></i>
                </div>
                <span class="menu-list poppins-medium">Login &amp; Security</span>
              </a>
            </li>
            <li class="g-py-3">
              <a class="d-block align-middle g-color-text g-pa-3 btn-menu" id="logout">
                <div class="d-flex align-items-center" style="gap: 6px;">
                  <div class="u-icon-v1">
                    <i class="icon-logout u-line-icon-pro"></i>
                  </div>
                  <span class="menu-list poppins-medium">Logout</span>
                </div>
              </a>
            </li>
          </ul>
        </div>
        <!-- End Profile Settings List -->
      </div>
    </div>
    <!-- End Profile Settings (Mobile) -->

    <!-- Orders -->
    <div class="col g-mb-50 orders-section">

      <!-- open Order -->
      <div id="open-orders" class="orders-content {% if 'orders' in current_path %}active{% else %}''{% endif %}">
        <h4 class="poppins-semibold">All Orders</h4>
        <div class="tabs pt-3">
          <div id="tab-history" class="tab active" onclick="showContent('pesanan')">History Orders</div>
          <?php /*?>
          <div id="tab-unpaid" class="tab" onclick="showContent('unpaid')">Unpaid</div>
          <div id="tab-review" class="tab" onclick="showContent('review')">To Review</div>
          <?php */?>
        </div>
        <div class="d-flex justify-content-end py-4">
          <!-- Search Form & Filter -->
          <?php /*?>
          <div class="d-flex" style="gap: 10px;">
            <form class="search-form">
              <input class="form-control search-input" type="search" placeholder="Search all orders">
              <button class="btn btn-search" type="submit">Search</button>
            </form>

            <button class="d-flex align-items-center btn filter-button" style="gap: 5px;" data-bs-toggle="modal"
              data-bs-target="#exampleModal">
              <i class="bi bi-funnel" style="font-size: 16px;"></i>
              <span class="poppins-medium">Filter</span>
            </button>
          </div>
          <?php */?>

          <!-- End Search Form -->
        </div>

        <?php if(!$orders) { ?>
        <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
          <h5 class="text-danger">Orders empty!</h5>
        </div>
        <div class="text-center mb-5">
          <a href="{{ url() }}" class="btn btn-success btn-lg">
            <i class="bi bi-search"></i> Explore your journey
          </a>
        </div>

        <?php } else { ?>

        <?php foreach ($orders as $order): ?>
        <div class="order" id="orders">
          <!-- header -->
          <?php if ($order['module'] == '10') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
              <span>Order #
                <?= $order['order_code'] ?>
              </span>
                <?php /*>
                <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Activity Date</h4>
                <span>
                  <?= $order['activity_date'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Time/Session</h4>
                <span>
                  <?= $order['rate']?>/
                  <?= $order['rateopt']?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php } else if ($order['module'] == '9') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
                <span>Order #
                  <?= $order['order_code'] ?>
                </span>
                  <?php /*>
                  <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                  <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Pick-up</h4>
                <span>
                  <?= $order['activity_date'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Day(s)</h4>
                <span>
                  <?= $order['days'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Unit</h4>
                <span>
                  <?= $order['qty'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php } else if ($order['module'] == '11') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
                <span>Order #
                  <?= $order['order_code'] ?>
                </span>
                  <?php /*>
                  <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                  <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-4 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-4 g-mb-20 g-mb-0--sm">
                <h4>Quantity</h4>
                <span>
                  <?= $order['qty'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-4 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php } else if ($order['module'] == '1' || $order['module'] == '2') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
                <span>Order #
                  <?= $order['order_code'] ?>
                </span>
                  <?php /*>
                  <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                  <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Room(s)</h4>
                <span>
                  <?= $order['qty'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Night(s)</h4>
                <span>
                  <?= $order['days']?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php }?>
          <!-- header end -->

          <!-- Order Content -->
          <div class="pt-4">
            <div class="row">
              <div class="col-12 col-md-4">
                <img class="img-fluid"
                  src="{{ config.vars.picUrl }}/products/<?= $order['product_id'] ?>/<?= $order['product_image'] ?>"
                  alt="Image Description">
              </div>

              <div class="col-12 col-md-8 order-content">
                <h4 class="h5 poppins-medium mb-2"><a
                    href="{{ url() }}<?= $order['product_id'] ?>/<?= $order['product_url'] ?>/">
                    <?= $order['product_name'] ?>
                  </a></h4>
                <div class="text-muted mb-2 pt-1 d-flex align-items-center" style="font-size: 14px; gap: 10px;">
                  <div class="d-flex" style="gap: 3px;">
                    <?php 
                      $idp = $order['product_id']; 
                      $stats = isset($reviewStats[$idp]) ? $reviewStats[$idp] : ['average_rating' => 0];
                      $rating = round($stats['average_rating']);
                      for ($i = 1; $i <= 5; $i++) {
                          echo '<i class="bi '.($i <= $rating ? 'bi-star-fill' : 'bi-star').' me-1 text-warning"></i>';
                      }
                    ?>
                  </div>
                  <div>
                    <?= $stats['average_rating'] ?> (
                    <?= $stats['total_review'] ?>) <span class="mx-1"></span>
                  </div>
                </div>
                <span class="d-block mb-1">Sold by:
                  <?= $order['provider_name'] ?>
                </span>
                <span class="d-block mb-1">Add-on: No Add-on</span>

                <span class="d-block text-danger mb-2">Total: Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
            <div class="d-flex justify-content-end align-items-center" style="gap: 10px;">
              <!-- <a class="btn btn-order" href="#!">Buy It Again</a> -->
              <?php if ($order['cancel_allowed']) {?>
              <a class="btn btn-order" id="cancel-order" data-code="<?= $order['order_code'] ?>"
                data-orderdetail="<?= $order['order_detail_id'] ?>" data-duedate="<?= $order['activity_date'] ?>">Cancel
                Order</a>
              <?php } else {?>
              <span class="text-muted">Cancel not available</span>
              <?php } ?>
              <?php if ($order['check']): ?>
              <span class="popover-wrapper">
                <button class="btn popovers-button px-4 py-2" disabled style="cursor: not-allowed;">
                  Reviewed
                </button>
                <div class="custom-popover">You have already submitted a review</div>
              </span>
              <?php else: ?>
              <button type="button" class="btn write-review-btn px-4 py-2 rounded-pill fw-semibold shadow-sm"
                data-bs-toggle="modal" data-bs-target="#exampleModal5" data-product-id="<?= $order['product_id'] ?>"
                data-orderdetail="<?= $order['order_detail_id'] ?>">
                Write Review
              </button>
              <?php endif; ?>

            </div>
          </div>
          <!-- End Order Content -->
        </div>
        <?php endforeach; ?>

        <!-- Write a review modal -->
        <div class="modal fade" id="exampleModal5" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
              <div class="modal-body">
                <button type="button" class="ml-auto d-flex justify-content-end"
                  style="border: none !important; outline: none !important; background: #fff !important;"
                  data-bs-dismiss="modal" aria-label="Close">
                  <i class="bi bi-x-lg"></i>
                </button>
                <h3 class="poppins-bold g-color-black text-center" style="padding: 0px 16px 0px 16px;">
                  Share your experience with us!
                </h3>
                <p class="text-center" style="padding: 0px 18px 0px 18px;">your feedback helps future visitors and
                  guides us to keep getting
                  better.</p>

                <form id="form_add_review" method="post" enctype="multipart/form-data" class="px-3 py-2 bg-white">
                  <input type="hidden" name="product_id" id="product_id_modal" value="">

                  <input type="hidden" class="form-control" id="reviewerName" name="review_name"
                    value="<?= $this->session->get('trop_auth')['customer_name'] ?>">
                  <input type="hidden" class="form-control" id="country" name="review_country"
                    value="<?= $this->session->get('trop_auth')['customer_country'] ?>">
                  <input type="hidden" class="form-control" name="orderDetail" id="order_detail_id" value="">

                  <div class="">
                    <div class="star-rating d-flex align-items-center justify-content-center" id="starRating">
                      <input type="radio" name="review_star" id="star5" value="5"><label for="star5"><i
                          class="bi bi-star-fill"></i></label>
                      <input type="radio" name="review_star" id="star4" value="4"><label for="star4"><i
                          class="bi bi-star-fill"></i></label>
                      <input type="radio" name="review_star" id="star3" value="3"><label for="star3"><i
                          class="bi bi-star-fill"></i></label>
                      <input type="radio" name="review_star" id="star2" value="2"><label for="star2"><i
                          class="bi bi-star-fill"></i></label>
                      <input type="radio" name="review_star" id="star1" value="1"><label for="star1"><i
                          class="bi bi-star-fill"></i></label>
                    </div>
                    <div id="ratingText" class="text-center"></div>
                  </div>

                  <div class="mb-3">
                    <label for="review_images" class="form-label">Upload Images or Videos</label>
                    <input type="file" id="review_images" name="review_files[]" multiple data-max-files="8">
                  </div>

                  <div class="my-3">
                    <div class="floating-label">
                      <textarea id="comment" name="review_comment" required></textarea>
                      <label for="comment">Write your experience here...</label>
                    </div>
                  </div>

                  <div class="d-flex justify-content-end" style="gap: 8px;">
                    <button type="button" class="btn button-save-review py-2 px-4">Submit review</button>
                    <button type="reset" class="btn reset-save py-2 px-4">Reset</button>
                  </div>
                </form>

              </div>
            </div>
          </div>

        </div>
        <!-- End Order Content -->

        <!-- Pagination -->
        {% if totalPages > 1 %}
        <nav class="g-mt-100" aria-label="Page Navigation">
          <ul class="list-inline mb-0">

            {# Tombol Previous #}
            {% if currentPage > 1 %}
            <li class="list-inline-item">
              <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-mr-15"
                href="?page={{ currentPage - 1 }}" aria-label="Previous">
                <span aria-hidden="true"><i class="fa fa-angle-left"></i></span>
                <span class="sr-only">Previous</span>
              </a>
            </li>
            {% endif %}

            {# Halaman Pertama #}
            {% if currentPage > 2 %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 {{ 1 == currentPage ? 'active' : '' }}"
                href="?page=1">1</a>
            </li>
            {% if currentPage > 3 %}
            <li class="list-inline-item hidden-down">
              <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
            </li>
            {% endif %}
            {% endif %}

            {# Current -1 #}
            {% if currentPage > 1 %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5"
                href="?page={{ currentPage - 1 }}">{{ currentPage - 1 }}</a>
            </li>
            {% endif %}

            {# Current Page #}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 active"
                href="?page={{ currentPage }}">{{ currentPage }}</a>
            </li>

            {# Current +1 #}
            {% if currentPage < totalPages %} <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5"
                href="?page={{ currentPage + 1 }}">{{ currentPage + 1 }}</a>
              </li>
              {% endif %}

              {# Halaman Terakhir #}
              {% if currentPage < totalPages - 1 %} {% if currentPage < totalPages - 2 %} <li
                class="list-inline-item hidden-down">
                <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
                </li>
                {% endif %}
                <li class="list-inline-item hidden-down">
                  <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 {{ totalPages == currentPage ? 'active' : '' }}"
                    href="?page={{ totalPages }}">{{ totalPages }}</a>
                </li>
                {% endif %}

                {# Tombol Next #}
                {% if currentPage < totalPages %} <li class="list-inline-item">
                  <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-ml-15"
                    href="?page={{ currentPage + 1 }}" aria-label="Next">
                    <span aria-hidden="true"><i class="fa fa-angle-right"></i></span>
                    <span class="sr-only">Next</span>
                  </a>
                  </li>
                  {% endif %}

                  {# Info Halaman #}
                  <li class="list-inline-item float-right">
                    <span class="u-pagination-v1__item-info g-color-gray-dark-v4 g-font-size-12 g-pa-5">Page {{
                      currentPage }} of {{ totalPages }}</span>
                  </li>
          </ul>
        </nav>
        {% endif %}
        <!-- End Pagination -->
        <?php } ?>

      </div>
      <!-- open Order end-->

      <!-- cancelled orders -->
      <div id="cancelled-orders" class="orders-content {% if 'cancelled' in current_path %}active{% else %}''{% endif %}">
        <?php foreach ($cancelled as $cancel): ?>
        <div class="order" id="orders">
          <header>
            <div class="order-code ml-auto mb-3 text-sm-right">
                <span>Order #<?= $cancel['order_code'] ?></h4>
                <?php /*>
                <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                <?php */?>   
              </div>
            <div class="row order-details">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span><?= $cancel['order_placed'] ?></span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Activity Date</h4>
                <span><?= $cancel['activity_date'] ?></span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Time/Session</h4>
                <span>09:00</span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp. <?= $cancel['sub_total'] ?></span>
              </div>
            </div>
          </header>

          <!-- Order Content -->
          <div class="pt-4">
                <div class="row">
                  <div class="col-4">
                    <img class="img-fluid" src="{{ config.vars.picUrl }}/products/<?= $cancel['product_id'] ?>/<?= $cancel['product_image'] ?>" alt="Image Description">
                  </div>

                  <div class="col-8 order-content">
                    <h4 class="h5 poppins-medium mb-3"><a href="{{ url() }}<?= $cancel['product_id'] ?>/<?= $cancel['product_url'] ?>/"><?= $cancel['product_name'] ?></a></h4>
                    <span class="d-block mb-1">Sold by: <?= $cancel['provider_name'] ?></span>
                    <span class="d-block mb-1">Add-on: No Add-on</span>

                    <span class="d-block text-danger mb-2">Total: Rp. <?= $cancel['sub_total'] ?></span>
                  </div>
                </div>
              <div class="d-flex justify-content-end" style="gap: 10px;">
                <div class="cancel-order">
                  <span>Order Cancelled</span>
                </div>
              </div>
          </div>
          <!-- End Order Content -->
        </div>
        <?php endforeach; ?>

        <!-- pagination start -->
        {% if cancelledTotalPages > 1 %}
        <nav class="g-mt-100" aria-label="Page Navigation">
          <ul class="list-inline mb-0">

            {# Tombol Previous #}
            {% if cancelledPage > 1 %}
            <li class="list-inline-item">
              <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-mr-15"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage - 1)) }}" aria-label="Previous">
                <span aria-hidden="true"><i class="fa fa-angle-left"></i></span>
                <span class="sr-only">Previous</span>
              </a>
            </li>
            {% endif %}

            {# Halaman Pertama #}
            {% if cancelledPage > 2 %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 {{ 1 == cancelledPage ? 'active' : '' }}"
                href="{{ url.get('account/cancelled/' ~ (1)) }}">1</a>
            </li>
            {% if cancelledPage > 3 %}
            <li class="list-inline-item hidden-down">
              <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
            </li>
            {% endif %}
            {% endif %}

            {# Current -1 #}
            {% if cancelledPage > 1 %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage - 1)) }}">{{ cancelledPage - 1 }}</a>
            </li>
            {% endif %}

            {# Current Page #}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 active"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage)) }}">{{ cancelledPage }}</a>
            </li>

            {# Current +1 #}
            {% if cancelledPage < cancelledTotalPages %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage + 1)) }}">{{ cancelledPage + 1 }}</a>
            </li>
            {% endif %}

            {# Halaman Terakhir #}
            {% if cancelledPage < cancelledTotalPages - 1 %}
            {% if cancelledPage < cancelledTotalPages - 2 %}
            <li class="list-inline-item hidden-down">
              <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
            </li>
            {% endif %}
            <li class="list-inline-item hidden-down">
              <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 {{ cancelledPage == cancelledTotalPages ? 'active' : '' }}"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage)) }}">{{ cancelledTotalPages }}</a>
            </li>
            {% endif %}

            {# Tombol Next #}
            {% if cancelledPage < cancelledTotalPages %}
            <li class="list-inline-item">
              <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-ml-15"
                href="{{ url.get('account/cancelled/' ~ (cancelledPage + 1)) }}" aria-label="Next">
                <span aria-hidden="true"><i class="fa fa-angle-right"></i></span>
                <span class="sr-only">Next</span>
              </a>
            </li>
            {% endif %}

            {# Info Halaman #}
            <li class="list-inline-item float-right">
              <span class="u-pagination-v1__item-info g-color-gray-dark-v4 g-font-size-12 g-pa-5">Page {{ cancelledPage }} of
                {{ cancelledTotalPages }}</span>
            </li>
          </ul>
        </nav>
        {% endif %}
        <!-- pagination end -->
      </div>
      <!-- cancelled orders end -->

      <!-- review -->
      <div id="review" class="orders-content {% if 'review' in current_path %}active{% else %}''{% endif %}">
        
        <h4 class="poppins-semibold">Your Reviews</h4>
        <div class="tabs pt-3">
          <div id="tab-history" class="tab active" onclick="showContent('pesanan')">Review List</div>
          <div id="tab-unpaid" class="tab" onclick="showContent('unpaid')">Waiting For Your Review</div>
        </div>
        <div class="d-flex justify-content-end py-4">
          <!-- Search Form & Filter -->
          <?php /* ?><div class="d-flex" style="gap: 10px;">
            <form class="search-form">
              <input class="form-control search-input" type="search" placeholder="Search all orders">
              <button class="btn btn-search" type="submit">Search</button>
            </form>

            <button class="d-flex align-items-center btn filter-button" style="gap: 5px;" data-bs-toggle="modal"
              data-bs-target="#exampleModal">
              <i class="bi bi-funnel" style="font-size: 16px;"></i>
              <span class="poppins-medium">Filter</span>
            </button>
          </div><?php */?>

          <!-- End Search Form -->
        </div>

        <?php if(!$reviewedData) { ?>
        <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
          <h5 class="text-danger">You haven’t written any reviews!</h5>
        </div>
        <div class="text-center mb-5">
          <a href="{{ url() }}" class="btn btn-success btn-lg">
            <i class="bi bi-search"></i> Explore your journey
          </a>
        </div>

        <?php } else { ?>

        <?php foreach ($reviewedData as $order): ?>
        <div class="order" id="orders">
          <!-- header -->
          <?php if ($order['module'] == '10') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
              <span>Order #
                <?= $order['order_code'] ?>
              </span>
                <?php /*>
                <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Activity Date</h4>
                <span>
                  <?= $order['activity_date'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Time/Session</h4>
                <span>
                  <?= $order['rate']?>/
                  <?= $order['rateopt']?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php } else if ($order['module'] == '9') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
                <span>Order #
                  <?= $order['order_code'] ?>
                </span>
                  <?php /*>
                  <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                  <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Pick-up</h4>
                <span>
                  <?= $order['activity_date'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Day(s)</h4>
                <span>
                  <?= $order['days'] ?>
                </span>
              </div>
              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Unit</h4>
                <span>
                  <?= $order['qty'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-2 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php } else if ($order['module'] == '1' || $order['module'] == '2') { ?>
          <header>
            <div class="d-flex justify-content-between align-items-center">
              <div class="order-code">
                <span>Order #
                  <?= $order['order_code'] ?>
                </span>
                  <?php /*>
                  <a class="g-font-weight-300 g-font-size-13" href="#!">invoice</a>
                  <?php */?>
              </div>
              <div class="d-block d-md-none">
                <button class="btn button-detail-info" data-bs-toggle="modal" data-bs-target="#modalDetail">
                  <i class="bi bi-info-circle text-danger"></i>
                </button>
              </div>
            </div>
            <div class="row order-details d-none d-md-flex d-lg-flex">
              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Order Placed</h4>
                <span>
                  <?= $order['order_placed'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Room(s)</h4>
                <span>
                  <?= $order['qty'] ?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Night(s)</h4>
                <span>
                  <?= $order['days']?>
                </span>
              </div>

              <div class="order-details-text col-6 col-md-3 g-mb-20 g-mb-0--sm">
                <h4>Total</h4>
                <span>Rp.
                  <?= $order['sub_total'] ?>
                </span>
              </div>
            </div>
          </header>
          <?php }?>
          <!-- header end -->

          <!-- Order Content -->
          <div class="pt-4">
            <div class="row">
              <div class="col-12 col-md-4">
                <img class="img-fluid"
                  src="{{ config.vars.picUrl }}/products/<?= $order['product_id'] ?>/<?= $order['product_image'] ?>"
                  alt="Image Description" data-yui="<?= $order['order_detail_id'] ?>">
              </div>

              <div class="col-12 col-md-8 order-content">
                <h4 class="h5 poppins-medium mb-2"><a
                    href="{{ url() }}<?= $order['product_id'] ?>/<?= $order['product_url'] ?>/">
                    <?= $order['product_name'] ?>
                  </a></h4>
                <div class="text-muted mb-2 pt-1 d-flex align-items-center" style="font-size: 14px; gap: 10px;">
                  <div class="d-flex" style="gap: 3px;">
                    <?php 
                      $od = $order['order_detail_id']; 
                      $stats = $reviewed[$od];
                    ?> 
                    

                    <?= $stats['rate_name'] ?> /
                <?= $stats['rate_opt_name'] ?> •
                <?= $stats['formatted_date'] ?>
              </div>
            </div>
            
              <?php $rating = round($stats['star']);
              for ($i = 1; $i <= 5; $i++) {
                  echo '<i class="bi '.($i <= $rating ? 'bi-star-fill' : 'bi-star').' me-1 text-warning"></i>';
              } ?>
              <?= $stats['star'] ?>/5
            
                <span class="d-block mb-1">
                  <?= $stats['comment'] ?>
                </span>
                <?php if (!empty($stats['images'])): ?>
              <div class="review-gallery mt-2" id="review-gallery-<?= $stats['review_id'] ?>">
                <?php foreach ($stats['images'] as $index => $img): ?>
                <?php
                              $totalImages = count($stats['images']);
                              $visibleImages = 4;
                              $isLastVisible = ($index == $visibleImages - 1) && ($totalImages > $visibleImages);
                              $isHidden = ($index >= $visibleImages);
                            ?>
                <a href="<?= $picUrl ?>/reviews/<?= $stats['review_id'] ?>/<?= $img->name ?>"
                  data-fancybox="gallery-<?= $stats['review_id'] ?>"
                  class="review-image <?= $isHidden ? 'd-none' : '' ?>">
                  <div style="position: relative; display: inline-block;">
                    <img src="<?= $picUrl ?>/reviews/<?= $stats['review_id'] ?>/<?= $img->name ?>"
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

              <?php if (!empty($stats['videos'])): ?>
              <div class="review-videos mt-2">
                <?php foreach ($stats['videos'] as $vid): ?>
                <a href="<?= $picUrl ?>/reviews/<?= $stats['review_id'] ?>/<?= $vid->name ?>" data-fancybox="video"
                  data-type="video" data-caption="Video Review"
                  style="display: inline-block; margin-right: 5px; margin-bottom: 5px;">
                  <video width="160" height="100" muted style="border-radius: 5px; object-fit: cover;">
                    <source src="<?= $picUrl ?>/reviews/<?= $stats['review_id'] ?>/<?= $vid->name ?>" type="video/mp4">
                  </video>
                </a>
                <?php endforeach; ?>
              </div>
              <?php endif; ?>
              </div>
            </div>
            <div class="d-flex justify-content-end align-items-center" style="gap: 10px;">
              <div class="completed-order">
                <span>Completed Order</span>
              </div>


            </div>
          </div>
          <!-- End Order Content -->
        </div>
        <?php endforeach; ?>

        <!-- Pagination -->
        {% if reviewedTotalPages > 1 %}
      <div class="pagination" id="pagination-container">
        <ul>
          {% if reviewedPage > 1 %}
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <a href="{{ url.get('account/review/' ~ (reviewedPage - 1)) }}"
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

          {% for i in 1..reviewedTotalPages %}
          {% if i == 1 or i == reviewedTotalPages or (i >= reviewedPage - 1 and i <= reviewedPage + 1) %} 
          <li class="numb {% if i == reviewedPage %}active{% endif %}">
            <a href="{{ url.get('account/review/' ~ i) }}"
              style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
              <span>{{ i }}</span>
            </a>
          </li>
            {% elseif i == reviewedPage - 2 or i == reviewedPage + 2 %}
            <li class="dots"><span>...</span></li>
            {% endif %}
            {% endfor %}

            {% if reviewedPage < reviewedTotalPages %} 
            <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
              <a href="{{ url.get('account/review/' ~ (reviewedPage + 1)) }}"
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
        <!-- End Pagination -->
        <?php } ?>
       
      </div>
      <!-- review -->

      <!-- wishlist -->
      <div id="wishlist" class="orders-content {% if 'wishlist' in current_path %}active{% else %}''{% endif %}">
        <h4 class="poppins-semibold">Wishlist</h4>
        <div class="d-flex justify-content-end py-4">
          <!-- Search Form & Filter -->
          <?php /* ?><div class="d-flex" style="gap: 10px;">
            <form class="search-form">
              <input class="form-control search-input" type="search" placeholder="Search all orders">
              <button class="btn btn-search" type="submit">Search</button>
            </form>

            <button class="d-flex align-items-center btn filter-button" style="gap: 5px;" data-bs-toggle="modal"
              data-bs-target="#exampleModal">
              <i class="bi bi-funnel" style="font-size: 16px;"></i>
              <span class="poppins-medium">Filter</span>
            </button>
          </div><?php */ ?>

          <!-- End Search Form -->
        </div>
          <?php if(!$wishlistData) { ?>
        <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
          <h5 class="text-danger">💔 You haven’t added anything to your wishlist yet.</h5>
        </div>
        <div class="text-center mb-5">
          <a href="{{ url() }}" class="btn btn-success btn-lg">
            <i class="bi bi-search"></i>  Browse products and tap the heart icon to save your favorites.
          </a>
        </div>

        <?php } else { ?>

        <?php foreach ($wishlistData as $wishlist): ?>
        <div class="order" id="orders">
          <!-- Order Content -->
            <div class="row">
              <div class="col-12 col-md-4">
                <img class="img-fluid"
                  src="{{ config.vars.picUrl }}/products/<?= $wishlist['product_id'] ?>/<?= $wishlist['product_image'] ?>"
                  alt="Image Description" style="border-radius: 8px;">
              </div>

              <div class="col-12 col-md-5 order-content" style="border-right: 2px dashed #ccc;">
                <figcaption class="category poppins-medium mb-3"><?= $wishlist['product_group'] ?></figcaption>
                
                <h4 class="h5 poppins-medium mb-3"><a
                    href="{{ url() }}<?= $wishlist['product_id'] ?>/<?= $wishlist['product_url'] ?>/">
                    <?= $wishlist['product_name'] ?>
                  </a></h4>
                <div class="d-flex mb-1" style="gap: 5px;">
                  <?php $stats = $reviewStats[$wishlist['product_id']]; ?>
                  <?php if ($stats['average_rating'] > 0): ?>
                <div class="text-muted pt-1" style="font-size: 14px;">
                  
                  <?php if (!empty($stats['is_provider']) && $stats['is_provider']): ?>
                    <div class="provider-rating g-color-black mb-2">
                      <i class="bi bi-shop"></i>
                      <span>Provider Rating</span>
                    </div>
                    <div class="d-flex align-items-center" style="gap: 3px;">
                      <div class="d-flex align-items-center" style="gap: 8px;">
                        <?php
                          $rating = number_format($stats['average_rating'], 1);
                          echo '<i class="bi bi-star-fill text-warning"></i> ';
                        ?>
                        <?= $stats['average_rating'] ?>
                      </div>
                      <?php if ($wishlist['ordered'] > 0): ?>
                      <span>・</span>
                    <span><?= ($wishlist['ordered'] >= 1000) 
                            ? (intval($wishlist['ordered'] / 1000) == ($wishlist['ordered'] / 1000) 
                                ? intval($wishlist['ordered'] / 1000) 
                                : number_format($wishlist['ordered'] / 1000, 1)
                              ) . 'k' 
                            : $wishlist['ordered']
                        ?> booked
                    </span>
                    <?php endif; ?>
                    </div>
                  <?php else: ?>
                  <div class="d-flex align-items-center" style="gap: 3px;">
                    <div class="d-flex" style="gap: 8px;">
                       <?php
                          $rating = number_format($stats['average_rating'], 1);
                          echo '<i class="bi bi-star-fill text-warning"></i> ';
                        ?>
                        <?= $stats['average_rating'] ?>/5 (<?= $stats['total_review'] ?>)
                    </div>
                    <?php if ($wishlist['ordered'] > 0): ?>
                    <span>・</span>
                    <span><?= ($wishlist['ordered'] >= 1000) 
                            ? (intval($wishlist['ordered'] / 1000) == ($wishlist['ordered'] / 1000) 
                                ? intval($wishlist['ordered'] / 1000) 
                                : number_format($wishlist['ordered'] / 1000, 1)
                              ) . 'k' 
                            : $wishlist['ordered'] 
                        ?> booked
                    </span>
                    <?php endif; ?>
                  </div>
                  <?php endif; ?>

                </div>
              <?php else: ?>
                <div class="new-product g-color-black mb-2">
                  <i class="bi bi-tag"></i>
                  <span>New Product</span>
                </div>
              <?php endif; ?>
            </div>
            <div>
              <p class="mt-2 text-muted">{{ wishlist['product_desc'] }}</p>
            </div>

              </div>

              <div class="col-12 col-md-3" style="position: relative;">
                <!-- Heart icon -->
                <div class="heart-icon" style="top: 1% !important;">
                  {% if wishlist['product_id'] in wishlistProductIds %}
                    <i class="bi bi-heart-fill wishlist active" data-product-id="{{ wishlist['product_id'] }}"></i>
                  {% else %}
                    <i class="bi bi-heart-fill wishlist" data-product-id="{{ wishlist['product_id'] }}"></i>
                  {% endif %}
                </div>

                <!-- Harga di kanan bawah -->
                <div class="price-wrapper" style="
                  position: absolute;
                  right: 0;
                  bottom: 0;
                  padding: 10px;
                  text-align: right;">
                  <span>Start from</span><br>

                  {% if hotdeals[wishlist['product_id']] is defined and hotdeals[wishlist['product_id']]['discounted_price'] > 0 %}
                    <span class="g-color-gold g-font-weight-600 original-price" style="color: red; font-size: 11pt;">
                      <span style="text-decoration: line-through; color: red;">
                        <span class="activecurrency"></span>
                        <span class="valuecurrency" data-baseprice="{{ hotdeals[wishlist['product_id']]['rate_option_price'] }}"></span>
                      </span>
                    </span><br>

                    <span class="g-color-gold g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                      <span class="activecurrency"></span>
                      <span class="valuecurrency" data-baseprice="{{ hotdeals[wishlist['product_id']]['discounted_price'] }}"></span>
                    </span>

                  {% else %}
                    <span class="g-color-gold g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                      <span class="activecurrency"></span>
                      <span class="valuecurrency" data-baseprice="{{ hotdeals[wishlist['product_id']]['min_publish_price'] }}"></span>
                    </span>
                  {% endif %}
                </div>
              </div>

            </div>


          <!-- End Order Content -->
        </div>
        <?php endforeach; ?>

        <!-- Pagination -->
        {% if wishlistTotalPages > 1 %}
      <div class="pagination" id="pagination-container">
        <ul>
          {% if wishlistPage > 1 %}
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <a href="{{ url.get('account/wishlist/' ~ (wishlistPage - 1)) }}"
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

          {% for i in 1..wishlistTotalPages %}
          {% if i == 1 or i == wishlistTotalPages or (i >= wishlistPage - 1 and i <= wishlistPage + 1) %} 
          <li class="numb {% if i == wishlistPage %}active{% endif %}">
            <a href="{{ url.get('account/wishlist/' ~ i) }}"
              style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
              <span>{{ i }}</span>
            </a>
          </li>
            {% elseif i == wishlistPage - 2 or i == wishlistPage + 2 %}
            <li class="dots"><span>...</span></li>
            {% endif %}
            {% endfor %}

            {% if wishlistPage < wishlistTotalPages %} 
            <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
              <a href="{{ url.get('account/wishlist/' ~ (wishlistPage + 1)) }}"
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
        <!-- End Pagination -->
        <?php } ?>
      </div>
      <!-- wishlist end -->

      <!-- profile -->
      <div id="login-security" class="orders-content {% if 'login_security' in current_path %}active{% else %}''{% endif %}">
        <div class="profile-form-container">
          <div class="tabs">
            <div class="profile-tab button-tab tab active" data-target="profile">Personal details</div>
            <div class="password-tab button-tab tab" data-target="password">Change Password</div>
          </div>

          <!-- Form Content for Personal Details -->
          <div id="profile" class="profile-tab-content active">
            <form id="profile_form">
              <div class="form-group">
                <label for="name">Name</label>
                {% if google_id is defined and google_id == 'google' %}
                <input id="name" type="text" name="customer_name" value="{{google_name}}" />
                {% else %}
                <input id="name" type="text" name="customer_name" value="{{customer.name}}" />
                {% endif %}
              </div>
              <div class="form-group">
                <label for="email">Email</label>
                {% if google_id is defined and google_id == 'google' %}
                <input id="name" type="text" name="customer_name" value="{{google_email}}" />
                {% else %}
                <input id="email" type="email" name="customer_email" value="{{customer.email}}" />
                {% endif %}
              </div>
              <div class="submit-btn float-right mt-5 pt-5">
                <button id="save-new-profile">Save</button>
              </div>
            </form>
          </div>

          <!-- Form Content for Change Password -->
          <div id="password" class="profile-tab-content" style="display: none;">
            <form id="changepass_form">
              <div class="form-group">
                <label>New password</label>
                <input type="password" name="new_password" />
              </div>
              <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirm_password" />
              </div>
              <div class="submit-btn float-right mt-5 pt-5">
                <button id="save-new-password">Save</button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <!-- profile end -->

    </div>
    <!-- Orders -->
  </div>
</div>

<div class="modal fade" id="modalDetail" tabindex="-1" role="dialog"
  aria-labelledby="modalDetail" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="row order-details px-4 pb-4">
        <button type="button" class="btn-close ml-auto p-3" data-bs-dismiss="modal" aria-label="Close">
        <i class="bi bi-x-lg"></i>
      </button>
        <div class="order-details-text col-12 g-mb-20 g-mb-0--sm">
          <h4>Order Placed</h4>
          <span>
            <?= $order['order_placed'] ?>
          </span>
        </div>

        <div class="order-details-text col-12 g-mb-20 g-mb-0--sm">
          <h4>Activity Date</h4>
          <span>
            <?= $order['activity_date'] ?>
          </span>
        </div>

        <div class="order-details-text col-12 g-mb-20 g-mb-0--sm">
          <h4>Time/Session</h4>
          <span>
            <?= $order['rate']?>/
            <?= $order['rateopt']?>
          </span>
        </div>

        <div class="order-details-text col-12 g-mb-20 g-mb-0--sm">
          <h4>Total</h4>
          <span>Rp.
            <?= $order['sub_total'] ?>
          </span>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Global Profile Picture Modal -->
<div class="modal fade" id="editProfilePictureModal" tabindex="-1" role="dialog"
  aria-labelledby="editProfilePictureLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="d-flex justify-content-end pt-3 pr-3">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="outline: none;">
          <i class="bi bi-x-lg"></i>
        </button>
      </div>
      <div class="d-flex justify-content-center align-items-center">
        <form id="form_update_avatar" enctype="multipart/form-data" class="p-4 rounded-4"
          style="max-width: 400px; width: 100%;">
          <h4 class="text-center mb-4 g-color-black poppins-semibold">Update Your Profile Photo</h4>

          <div class="mb-3 text-center">
            <label for="new_avatar" class="form-label fw-semibold">Select Profile Picture</label>
            <input type="file" name="avatar" id="new_avatar" accept="image/*" class="form-control" required>
            <small class="form-text text-muted d-block mt-1">Allowed formats: JPG, JPEG, PNG. Max size: 5MB</small>
          </div>

          <div class="d-flex justify-content-between mt-5 mb-2" style="gap: 8px;">
            <button type="button" class="btn reset-save py-2 px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn button-save py-2 px-4" id="simpan_avatar">Upload</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
<!-- End Global Profile Picture Modal -->



<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>

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

  document.addEventListener('DOMContentLoaded', function () {
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
    const popoverList = [...popoverTriggerList].map(el => new bootstrap.Popover(el));
  });

  const ratingText = {
    1: "Poor",
    2: "Fair",
    3: "Good",
    4: "Very Good!",
    5: "Excellent!"
  };

  document.querySelectorAll('input[name="rating"]').forEach(radio => {
    radio.addEventListener('change', () => {
      const value = radio.value;
      document.getElementById("ratingText").textContent = ratingText[value];
    });
  });
  function showContent(type) {
    const tabHistory = document.getElementById('tab-history');
    const tabUnpaid = document.getElementById('tab-unpaid');
    const tabReview = document.getElementById('tab-review');
    const contentHistory = document.getElementById('content-history');
    const contentUnpaid = document.getElementById('content-unpaid');
    const contentReview = document.getElementById('content-review');

    if (type === 'history') {
      tabHistory.classList.add('active');
      tabUnpaid.classList.remove('active');
      tabReview.classList.remove('active');
      contentHistory.style.display = 'block';
      contentUnpaid.style.display = 'none';
      contentReview.style.display = 'none';
    } else if (type === 'unpaid') {
      tabUnpaid.classList.add('active');
      tabHistory.classList.remove('active');
      tabReview.classList.remove('active');
      contentUnpaid.style.display = 'block';
      contentHistory.style.display = 'none';
      contentReview.style.display = 'none';
    } else {
      tabReview.classList.add('active');
      tabHistory.classList.remove('active');
      tabUnpaid.classList.remove('active');
      contentReview.style.display = 'block';
      contentHistory.style.display = 'none';
      contentUnpaid.style.display = 'none';
    }
  }
</script>