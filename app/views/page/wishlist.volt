<section class="container g-pt-50">
  <div class="row mt-5" id="save-wishlist-btn"></div>
  <div id="popup-content" style="display:none;">
    <form action="" class="sign-in-form form-login" id="form_signin" style="width:75%; margin: auto;">
              <h2 class="title poppins-bold pb-4">Login</h2>
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                </svg>
                  <input type="text" name="email" placeholder="Email">
              </div>
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock" viewBox="0 0 16 16">
                  <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2M5 8h6a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1"/>
                </svg>
                  <input type="password" name="password" placeholder="Password">
              </div>
              
              <div class="forgotpass-content d-flex justify-content-between align-items-center w-100 mt-2" style="padding: 0 20px;">
                <div class="form-check d-flex align-items-center">
                  <?php /*?><input class="form-check-input me-2" type="checkbox" id="flexCheckDefault">
                  <label class="d-flex align-items-center my-auto py-auto text-muted" for="flexCheckDefault">
                    Keep Signed In
                  </label><?php */?>
                </div>
                <a href="{{ url() }}account/forgetpassword/" class="text-decoration-none forgot-link" style="color: #87CEEB;">Forgot Password?</a>
              </div>
              
              <input type="submit" id="signin" value="Login" class="btn-login">
              <p class="text-muted poppins-medium">Or</p>
              <a href="{{ url('account/logingoogle') }}" id="login-google"
                class="btn w-100 mb-5 d-flex align-items-center justify-content-center"
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
                  <img src="{{ url() }}img/google.png" style="width: 20px; margin-right: 10px;" alt="">
                  <span class="poppins-medium" style="color: #333;">Sign In with Google</span>
                </a>
              
              <p class="account-text">Don't Have An Account? <a href="{{url()}}account/signup/" id="sign-up-btn" class="color-1">Sign Up</a></p>
          </form>
    </div>

  <?php if($this->session->has('trop_auth') == true){?>
    <h2 class="h3 g-color-black g-font-weight-500 text-uppercase mb-5">Wishlist</h2>
    <div class="row vh-100 mb-5 pb-4" style="row-gap: 20px;">
{% if wishlistData is defined and wishlistData|length > 0 %}

      {% for wishlist in wishlistData %}
            {% set stats = wishlist['review'] is defined ? wishlist['review'] : {} %}
            {% set hotdeal = wishlist['rate'] is defined ? wishlist['rate'] : {} %}
            {% set isProvider = stats['is_provider'] is defined ? stats['is_provider'] : false %}
    
              <div class="col-sm-12 col-md-6 col-lg-3 d-flex justify-content-center mb-4">
                  <div class="card card-fixed shadow position-relative">
                      <figure>
                          <div class="swiper-container" data-product-id="{{ wishlist.product_id }}">
                              <div class="swiper-wrapper">
                                  <div class="swiper-slide">
                                      <a href="{{ picUrl }}/products/{{ wishlist['product_id'] }}/{{ wishlist['product_image'] }}" 
                                        data-fancybox="gallery-{{ wishlist.product_id }}" 
                                        data-caption="{{ wishlist['product_name'] }}">
                                          <img src="{{ picUrl }}/products/{{ wishlist['product_id'] }}/{{ wishlist['product_image'] }}" alt="{{ wishlist['product_name'] }}">
                                      </a>
                                  </div>
                              </div>
                              <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
                              <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
                          </div>
    
                          <div class="d-flex justify-content-between">
                              <figcaption class="label-top poppins-medium" style="transform: translateY(-590%); z-index: 1;">{{ wishlist['product_group'] }}</figcaption>
                              <div class="heart-icon">
                                  <i class="bi bi-heart-fill wishlist active" data-product-id="{{ wishlist.product_id }}"></i>
                              </div>
                          </div>
                      </figure>
    
                      <div class="card-body d-flex flex-column justify-content-between" style="height: 150px;">
                          <div class="card-top">
                              <a class="h4 poppins-semibold card-title truncate-text" href="{{ url() }}{{ wishlist['product_id'] }}/{{ wishlist['product_url'] }}/" target="_blank">{{ wishlist['product_name'] }}</a>
                              <div class="text-muted pt-1" style="font-size: 14px;">
                                {% if stats['average_rating'] > 0 %}
                                  {% if isProvider %}
                                      <div class="provider-rating g-color-black mb-2">
                                          <i class="bi bi-shop"></i>
                                          <span>Provider Rating</span>
                                      </div>
                                      <div class="d-flex align-items-center" style="gap: 3px;">
                                          <div class="d-flex align-items-center" style="gap: 8px;">
                                              <i class="bi bi-star-fill text-warning"></i> {{ stats['average_rating'] }}
                                          </div>
                                          {% if wishlist['ordered'] > 0 %}
                                              <span>・</span>
                                              <span>
                                                  {% if wishlist['ordered'] >= 1000 %}
                                                      {{ wishlist.ordered_formatted }}
                                                  {% else %}
                                                      {{ wishlist['ordered'] }}
                                                  {% endif %}
                                                  booked
                                              </span>
                                          {% endif %}
                                      </div>
                                  {% else %}
                                      <div class="d-flex align-items-center" style="gap: 3px;">
                                          <div class="d-flex" style="gap: 8px;">
                                              <i class="bi bi-star-fill text-warning"></i>
                                              {{ stats['average_rating'] }}/5 ({{ stats['total_review'] }})
                                          </div>
                                          {% if wishlist['ordered'] > 0 %}
                                              <span>・</span>
                                              <span>
                                                  {% if wishlist['ordered'] >= 1000 %}
                                                      {{ wishlist.ordered_formatted }}
                                                  {% else %}
                                                      {{ wishlist['ordered'] }}
                                                  {% endif %}
                                                  booked
                                              </span>
                                          {% endif %}
                                      </div>
                                  {% endif %}
                              {% else %}
                                  <div class="new-product g-color-black mb-2">
                                      <i class="bi bi-tag"></i>
                                      <span>New Product</span>
                                  </div>
                              {% endif %}
                              </div>
                          </div>
    
                          {% if hotdeal['min_publish_price'] > 0 %}
                              <div>
                                  <span class="start-from poopins-medium">Start from</span> 
                                  {% if hotdeal['discounted_price'] > 0 %}
                                      <span class="g-color-gold g-font-weight-600 original-price" style="color: red; font-size: 11pt;">
                                          <s style="text-decoration: line-through; color: red;">
                                              <span class="activecurrency">IDR</span>
                                              <span class="valuecurrency" data-baseprice="{{ hotdeal['rate_option_price'] }}">
                                                  { hotdeal['rate_option_price']}
                                              </span>
                                          </s>
                                      </span><br>
                                      <span class="g-color-gold g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                                          <span class="activecurrency">IDR</span>
                                          <span class="valuecurrency" data-baseprice="{{ hotdeal['discounted_price'] }}">
                                              { hotdeal['discounted_price']}
                                          </span>
                                      </span>
                                  {% else %}
                                      <br>
                                      <span class="g-color-gold g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                                          <span class="activecurrency">IDR</span>
                                          <span class="valuecurrency" data-baseprice="{{ hotdeal['min_publish_price'] is defined and hotdeal['min_publish_price'] ? hotdeal['min_publish_price'] : 0 }}">
                                              {{ (hotdeal['min_publish_price'] is defined and hotdeal['min_publish_price'] ? hotdeal['min_publish_price'] : 0)}}
                                          </span>
                                      </span>
                                  {% endif %}
                                  <div class="see-details">
                                      <a href="{{ url() }}{{ wishlist['product_id'] }}/{{ wishlist['product_url'] }}/" style="color: #555; text-decoration-line: none;">
                                          <div class="d-flex justify-content-end align-items-center hover-move py-1" style="cursor: pointer; padding-bottom: .5rem;">
                                              <span>See details</span>
                                              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                                                  <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                                              </svg>
                                          </div>
                                      </a>
                                  </div>
                              </div>
                          {% else %}
                              <h6 style="color: red;">Not Available</h6>
                              <p>Currently it is not possible to book this product due to its limited availability.</p>
                          {% endif %}
                      </div>
                  </div>
              </div>
      {% endfor %}

<!-- pagination -->
    </div>
    {% if total_pages > 1 %}
    <nav class="g-mt-100" aria-label="Page Navigation">
        <ul class="list-inline mb-0">
            {% if page > 1 %}
            <li class="list-inline-item">
                <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-mr-15"
                href="{{ url.get('wishlist/' ~ (page - 1)) }}" aria-label="Previous">
                <span aria-hidden="true"><i class="fa fa-angle-left"></i></span>
                <span class="sr-only">Previous</span>
                </a>
            </li>
            {% endif %}

            {# First page link #}
            {% if page > 2 %}
                <li class="list-inline-item hidden-down">
                    <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 {{ page == 1 ? 'active' : '' }}" href="{{ url.get('wishlist/' ~ (1)) }}">1</a>
                </li>
                {% if page > 3 %}
                    <li class="list-inline-item hidden-down">
                        <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
                    </li>
                {% endif %}
            {% endif %}

            {# Previous page #}
            {% if page > 1 %}
                <li class="list-inline-item hidden-down">
                    <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5" href="{{ url.get('wishlist/' ~ (page - 1)) }}">{{ page - 1 }}</a>
                </li>
            {% endif %}

            {# Current page #}
            <li class="list-inline-item hidden-down">
                <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 active" href="{{ url.get('wishlist/' ~ (page)) }}">{{ page }}</a>
            </li>

            {# Next page #}
            {% if page < total_pages %}
                <li class="list-inline-item hidden-down">
                    <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5" href="{{ url.get('wishlist/' ~ (page + 1)) }}">{{ page + 1 }}</a>
                </li>
            {% endif %}

            {# Last page link #}
            {% if page < total_pages - 1 %}
                {% if page < total_pages - 2 %}
                    <li class="list-inline-item hidden-down">
                        <span class="u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 g-pa-5">...</span>
                    </li>
                {% endif %}
                <li class="list-inline-item hidden-down">
                    <a class="pagenation u-pagination-v1__item g-width-30 g-height-30 g-font-size-12 rounded-circle g-pa-5 {{ page == total_pages ? 'active' : '' }}" href="{{ url.get('wishlist/' ~ (total_page)) }}">{{ total_pages }}</a>
                </li>
            {% endif %}

            {# Next button #}
            {% if page < total_pages %}
            <li class="list-inline-item">
                <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-ml-15"
                href="{{ url.get('wishlist/' ~ (page + 1)) }}" aria-label="Next">
                <span aria-hidden="true"><i class="fa fa-angle-right"></i></span>
                <span class="sr-only">Next</span>
                </a>
            </li>
            {% endif %}

            <li class="list-inline-item float-right">
                <span class="u-pagination-v1__item-info g-color-gray-dark-v4 g-font-size-12 g-pa-5">
                    Page {{ page }} of {{ total_pages }}
                </span>
            </li>
        </ul>
    </nav>
    {% endif %}
<!-- end pagination -->
 
  {% else %}
    <div class="text-center mt-5 mb-3 col-xl-12" style="padding-top: 80px;">
      <h5 class="text-danger">💔 You haven’t added anything to your wishlist yet.</h5>
    </div>
    <div class="text-center mb-5" style="padding-left:270px;">
      <a href="{{ url() }}" class="btn btn-success btn-lg">
        <i class="bi bi-search"></i> Browse products and tap the heart icon to save your favorites.
      </a>
    </div>
  {% endif %}

    <?php }else{?>
    <div id="wishlist-container" class="row">
    <div class="row mt-5" id="wishlist-container"></div>
    <div id="popup-content" style="display:none;">
    <form action="" class="sign-in-form form-login" id="form_signin" style="width:75%; margin: auto;">
              <h2 class="title poppins-bold pb-4">Login</h2>
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                </svg>
                  <input type="text" name="email" placeholder="Email">
              </div>
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock" viewBox="0 0 16 16">
                  <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2M5 8h6a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1"/>
                </svg>
                  <input type="password" name="password" placeholder="Password">
              </div>
              
              <div class="forgotpass-content d-flex justify-content-between align-items-center w-100 mt-2" style="padding: 0 20px;">
                <div class="form-check d-flex align-items-center">
                  <?php /*?><input class="form-check-input me-2" type="checkbox" id="flexCheckDefault">
                  <label class="d-flex align-items-center my-auto py-auto text-muted" for="flexCheckDefault">
                    Keep Signed In
                  </label><?php */?>
                </div>
                <a href="{{ url() }}account/forgetpassword/" class="text-decoration-none forgot-link" style="color: #87CEEB;">Forgot Password?</a>
              </div>
              
              <input type="submit" id="signin" value="Login" class="btn-login">
              <p class="text-muted poppins-medium">Or</p>
              <a href="{{ url('account/logingoogle') }}" id="login-google"
                class="btn w-100 mb-5 d-flex align-items-center justify-content-center"
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
                  <img src="{{ url() }}img/google.png" style="width: 20px; margin-right: 10px;" alt="">
                  <span class="poppins-medium" style="color: #333;">Sign In with Google</span>
                </a>
              
              <p class="account-text">Don't Have An Account? <a href="{{url()}}account/signup/" id="sign-up-btn" class="color-1">Sign Up</a></p>
          </form>
    </div>
    <div id="wishlist-pagination" class="mt-4"></div>
  <?php }?>
</section>
