<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.css" rel="stylesheet">

<section class="container g-pt-50" style="margin-top: 3rem;">
  <?php /* ?><form id="search_form">
  <div class="row input-group mb-5 search-areas">   
      <div class="col-6 d-flex align-items-center px-4 border-right" style="gap: 5px;">
        <i class="bi bi-search" style="font-size: 18px;"></i>  
        <input id="search" type="text" class="form-control g-font-size-14" style="border:none;" placeholder="Search your activities..." aria-label="Search your activities...">
      </div>
      
      <div class="col-4 d-flex align-items-center px-4" style="gap: 5px;">
        <i class="bi bi-calendar-week" style="font-size: 18px;"></i>  
        <input id="search" type="text" class="form-control g-font-size-14" style="border:none;" placeholder="Select your date" aria-label="Search your activities...">
      </div>
        <button id="btn-search" class="col-2 btn btn-search-areas g-font-size-16" type="submit">
          Search
        </button> 
    </div>
  </form><?php */?>

{% if search_result|length > 0 %}
  <div class="row">
    <?php /* ?><div class="col-3 d-none d-lg-block">
      
      <div class="left-bar mb-3">
        <label class="poppins-semibold mb-4">Price range</label>
          <div id="slider"></div>
          <div class="mt-4 price-range" style="display: flex; gap: 10px; margin-top: 10px;">
            <input type="number" id="min-price" style="width: 90px;"> 
            <span> - </span>
            <input type="number" id="max-price" style="width: 90px;">
          </div>
      </div>

      <div class="filter-box mb-3">
        <div class="filter-header poppins-semibold" onclick="toggleCheckbox(this)">
          Areas
          <span class="arrow"><i class="bi bi-chevron-up"></i></span> <!-- up arrow -->
        </div>
        <div class="checkbox-group show">
          {% for ar in parent %}
            <label><input type="checkbox" name="accommodation[]" value="{{ ar.area_url }}"> {{ ar.area_name }}</label>
          {% endfor %}
        </div>
      </div>

      <div class="filter-box mb-5">
        <div class="filter-header" onclick="toggleCheckbox(this)">
          Rating
          <span class="arrow"><i class="bi bi-chevron-up"></i></span> <!-- up arrow -->
        </div>
        <div class="checkbox-group show">
          <label><input type="checkbox" name="accommodation[]" value="5"> 
            5
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
          </label>
          <label><input type="checkbox" name="accommodation[]" value="4"> 
            4
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
          </label>
          <label><input type="checkbox" name="accommodation[]" value="3"> 
            3
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
          </label>
          <label><input type="checkbox" name="accommodation[]" value="2"> 
            2
            <i class="bi bi-star-fill text-warning"></i>
            <i class="bi bi-star-fill text-warning"></i>
          </label>
          <label><input type="checkbox" name="accommodation[]" value="1"> 
            1
            <i class="bi bi-star-fill text-warning"></i>
          </label>
        </div>
      </div>

      <div class="filter-box mb-3">
        <div class="filter-header" onclick="toggleCheckbox(this)">
          Category
          <span class="arrow"><i class="bi bi-chevron-up"></i></span>
        </div>
        <div class="checkbox-group show">
          {% for m in menu %}
            {% if m.group_product_parent == 0 %}
              <label><input type="checkbox" name="accommodation[]" value="{{ m.group_product }}"> {{ m.group_product }}</label>
            {% endif %}
          {% endfor %}
        </div>
      </div>
      
      <div class="filter-box mb-3">
        <div class="filter-header" onclick="toggleCheckbox(this)">
          Things To Do
          <span class="arrow"><i class="bi bi-chevron-up"></i></span>
        </div>
        <div class="checkbox-group show">

          {% for m in menu %}
            {% if m.group_product_parent == 0 %}
              {% for sm in submenu %}
                {% if sm.group_product_parent == m.id %}
                  <label><input type="checkbox" name="accommodation[]" value="{{ sm.group_product }}"> {{ sm.group_product }}</label>
                {% endif %}
              {% endfor %}
            {% endif %}
          {% endfor %}
        </div>
      </div>

      <div class="filter-box mb-3">
        <div class="filter-header" onclick="toggleCheckbox(this)">
          Rentals
          <span class="arrow"><i class="bi bi-chevron-up"></i></span>
        </div>
        <div class="checkbox-group show">
          {% for sm in submenu %}
            {% if sm.group_product_parent == 17 %}
              <label><input type="checkbox" name="accommodation[]" value="{{ sm.group_product }}"> {{ sm.group_product }}</label>
            {% endif %}
          {% endfor %}
        </div>
      </div>
    </div><?php */ ?>

    <div class="col-12 d-none d-lg-block">
      <div class="mb-4">
        <div class="d-flex justify-content-between">
          <div class="">
            <h5 class="h4 g-color-black poppins-semibold mb-0">{{ decoded_url|capitalize }}</h5>
            <h6 class="h6 g-color-black mb-0">Found : {{ total_results }} </h6>
          </div>

          <?php /*?><div class="d-flex" style="gap: 1rem;">
            <div class="d-flex align-items-center" style="gap: 8px;">
              <span>Sort by:</span>
              <div class="dropdown-custom">
                <button class="btn py-2 dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Highest Popularity
                </button>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item" href="#">Highest Price</a></li>
                  <li><a class="dropdown-item" href="#">Lowest Price</a></li>
                  <li><a class="dropdown-item" href="#">Highest Popularity</a></li>
                  <li><a class="dropdown-item" href="#">Lowest Popularity</a></li>
                </ul>
              </div>
            </div>

            <div class="d-flex align-items-center" style="gap: 8px;">
              <span>View:</span>
              <div class="btn-group view-toggle" role="group">
                <button id="gridView" class="btn" onclick="setView('grid')">
                  <i class="bi bi-grid-3x3-gap-fill"></i>
                </button>
                <button id="listView" class="btn active" onclick="setView('list')">
                  <i class="bi bi-list"></i>
                </button>
              </div>
            </div>
          </div><?php */ ?>
        </div>
      </div>

      <div class="row mb-4" style="row-gap: 25px;">
        
        {% for p in search_result %}
          {{ partial('partials/_productCard') }}
        {% endfor %}
      </div>

      <div class="col-12 mt-5 d-none">
        {% for p in search_result %}
        <div class="row card d-flex flex-row shadow mobile-card" style="margin-bottom: 1rem;">
            <!-- Image -->
            <figure class="col-4">
              <div class="swiper-container" data-product-id="{{ p.id }}">
                <div class="swiper-wrapper">
                  {% for image in images %}
                    {% if image.id == p.id %}
                        <div class="swiper-slide">
                          <a href="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" data-glightbox="gallery-{{p.id}}">
                            <img src="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" alt="{{ p.name }}">
                          </a>
                        </div>
                      {% endif %}
                    {% endfor %}
                </div>
                <!-- Jika ingin menampilkan tombol navigasi -->
                <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
                <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
              </div>
              <div class="d-flex justify-content-between">
                <?php /*?><div class="heart-icon">
                  <i class="bi bi-heart wishlist hearticon_{{pack.id}}" data-wishlist="{{pack.id}}"></i>
                </div><?php */?>
              </div>
            </figure>
            <!-- End Image -->

            <!-- Konten -->
            <div class="col-5" style="border-right: 1px solid #c0c0c0;">
              <div class="card-top">
                <figcaption class="category poppins-medium mb-3">{{ p.group_product }}</figcaption>
                <a class="h5 poppins-semibold g-color-black card-title truncate-text" href="{{ url() }}{{ p.id }}/{{ p.slug }}/">{{ p.name }}</a>
                <?php><div class="text-muted mb-2" style="font-size: 14px;">
                  <div class="mb-1">
                    <i class="bi bi-star-fill text-warning"></i> (30) 5.0
                  </div>
                  <div class="mb-4">
                    <i class="bi bi-geo-alt text-success"></i> Ubud, Bali
                  </div>
                  <div>
                    <p style="font-size: 13px;">Lorem ipsum dolor sit amet consectetur adipisicing elit..</p>
                  </div>
                </div><?php>
              </div>
            </div>

            <!-- price -->
            <div class="col-3" style="margin-top: auto;">
              <div class="price" style="margin-right: auto;">
                <span class="start-from poopins-medium">Start from</span> 
                {% if hotdeals[p.id] is defined and hotdeals[p.id]['discounted_price'] > 0 %}
                <span class="g-color-black g-font-weight-600 original-price" style="color: red;font-size: 11pt;">
                  <s style="text-decoration: line-through;color: red;font-size: 11pt;">
                      <span class="activecurrency"></span>
                      <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['rate_option_price'] }}">
                      </span>
                  </s>
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
                  <div class="d-flex justify-content-center align-items-center hover-move py-1" style="cursor: pointer; padding-bottom: .5rem;">
                    <span>See details</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                      <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                    </svg>
                  </div>
                </a>
              </div>
            </div>
        </div>
        {% endfor %}
      </div>

      {% if totalPages > 1 %}
    <div class="pagination">
      {% set baseUrl = (category_url is defined and category_url) ? 'category/' ~ category_url ~ '/search/' ~ decoded_url : 'search/' ~ decoded_url %}
      <ul>
        {% if currentPage > 1 %}
        <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
          <a href="{{ url.get(baseUrl ~ '/' ~ (currentPage - 1)) }}" style="text-decoration: none; color: inherit;">
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
              <a href="{{ url.get(baseUrl ~ '/' ~ i) }}" style="display: flex;align-items: center; justify-content: center;text-decoration: none; color: inherit;width: 100%; height: 100%;">
                <span>{{ i }}</span>
              </a>
            </li>
          {% elseif i == currentPage - 2 or i == currentPage + 2 %}
            <li class="dots"><span>...</span></li>
          {% endif %}
        {% endfor %}
        
        {% if currentPage < totalPages %}
        <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
          <a href="{{ url.get(baseUrl ~ '/' ~ (currentPage + 1)) }}" style="text-decoration: none; color: inherit;">
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
    <div class="d-flex d-lg-none flex-nowrap bg-white mb-4" style="overflow: auto; gap: 10px; scrollbar-width: none;">
      <!-- Filter -->
      <button class="filter-button btn d-flex align-items-center px-3" style="gap: 5px;">
        <i class="bi bi-funnel-fill me-2"></i> Filter
      </button>

      <!-- Urutkan -->
      <button class="filter-button btn d-flex align-items-center px-3" data-bs-toggle="modal" data-bs-target="#exampleModal" style="gap: 5px;">
        <i class="bi bi-sliders me-2"></i> Sort by
      </button>

      <!-- Harga -->
        <button class="filter-button btn px-3  d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#exampleModal1" style="gap: 5px;">
          <i class="bi bi-cash-stack me-2"></i> Price
        </button>

      <!-- Bintang -->
        <button class="filter-button btn px-3 d-flex align-items-center" style="gap: 5px;" data-bs-toggle="modal" data-bs-target="#exampleModal2">
          <i class="bi bi-star-fill me-2"></i> Rating
        </button>

      <!-- Areas -->
      <button class="filter-button btn px-3" data-bs-toggle="modal" data-bs-target="#exampleModal3" style="gap: 5px;">
        Areas
      </button>

      <button class="filter-button btn px-3" style="gap: 5px;">
        Villas
      </button>

      <!-- Things To Do -->
      <button class="filter-button btn px-3" data-bs-toggle="modal" data-bs-target="#exampleModal4" style="gap: 5px;">
        Things To Do
      </button>

      <button id="scrollRightBtn" class="scrollright btn btn-light" style="z-index: 10; display: none;">
        <i class="bi bi-chevron-right"></i>
      </button>
    </div>  

    <div class="d-block d-lg-none">
      <div class="row" style="row-gap: 10px;">
        {% for p in search_result %}
        <div class="col-sm-12 col-md-6 col-lg-4 d-flex justify-content-center">
          <div class="card card-fixed shadow rounded-4 position-relative">
            <!-- Image -->
            <figure>
              <!-- <img class="articleimage" src="{{ config.vars.picUrl }}/products/{{ pack.id }}/{{ pack.picture }}" alt="{{ pack.name }}"> -->
              <div class="swiper-container" data-product-id="{{ p.id }}">
                <div class="swiper-wrapper">
                  {% for image in images %}
                    {% if image.id == p.id %}
                        <div class="swiper-slide">
                          <a href="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" data-glightbox="gallery-{{p.id}}">
                            <img src="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" alt="{{ p.name }}">
                          </a>
                        </div>
                      {% endif %}
                    {% endfor %}
                </div>
                <!-- Jika ingin menampilkan tombol navigasi -->
                <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
                <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
              </div>
              <div class="d-flex justify-content-between">
                <figcaption class="label-top poppins-medium" style="transform: translateY(-590%); z-index: 1;">{{ p.group_product }}</figcaption>
                <?php /*?><div class="heart-icon">
                  <i class="bi bi-heart wishlist hearticon_{{pack.id}}" data-wishlist="{{pack.id}}"></i>
                </div><?php */?>
              </div>
            </figure>
            <!-- End Article Image -->

            <!-- Konten -->
            <div class="card-body d-flex flex-column justify-content-between" style="height: 150px;">
              <div class="card-top">
                <a class="h4 poppins-semibold card-title truncate-text" href="{{ url() }}{{ p.id }}/{{ p.slug }}/">{{ p.name }}</a>
                <?php /*?><div class="text-muted mb-2 pt-1" style="font-size: 14px;">
                  <i class="bi bi-star-fill text-warning"></i> (30) 5.0 <span class="mx-1">•</span> Ubud, Bali
                </div><?php */?>
              </div>

              <div>
                <span class="start-from poopins-medium">Start from</span> 
                {% if hotdeals[p.id] is defined and hotdeals[p.id]['discounted_price'] > 0 %}
                <span class="g-color-gold g-font-weight-600 original-price" style="color: red;font-size: 11pt;">
                  <s style="text-decoration: line-through;color: red;font-size: 11pt;">
                      <span class="activecurrency"></span>
                      <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['rate_option_price'] }}">
                      </span>
                  </s>
                </span><br>
                <span class="g-color-gold g-font-weight-600 discounted-price" style="font-size: 16pt; color: #F4A460;">
                    <span class="activecurrency"></span>
                    <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['discounted_price'] }}">
                    </span>
                </span>
                {% else %}
                  <br><span class="g-color-gold g-font-weight-600" style="font-size: 16pt; color: #F4A460;">
                      <span class="activecurrency"></span>
                      <span class="valuecurrency" data-baseprice="{{ hotdeals[p.id]['min_publish_price'] }}">
                      </span>
                  </span>
                {% endif %}
                <div class="see-details">
                  <a href="{{ url() }}{{ p.id }}/{{ p.slug }}/" style="color: #555; text-decoration-line: none;">
                    <div class="d-flex justify-content-end align-items-center hover-move py-1" style="cursor: pointer; padding-bottom: .5rem;">
                      <span>See details</span>
                      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                      </svg>
                    </div>
                  </a>
                </div>
              </div>
            </div>
          </div>
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

  <!-- Sort by modal -->
 <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
     <div class="modal-content">
      <div class="modal-body">
         <button type="button" class="ml-auto d-flex justify-content-end" style="border: none !important; background: #fff !important;" data-bs-dismiss="modal" aria-label="Close">
          <i class="bi bi-x-lg"></i>
        </button>
        <h5 class="poppins-semibold" style="padding: 0px 16px 5px 16px;">
          Sort by:
        </h5>
        <div class="checkbox-group show">
          <label><input type="checkbox" name="accommodation[]" value="Highest Price"> Highest Price</label>
          <label><input type="checkbox" name="accommodation[]" value="Lowest Price"> Lowest Price</label>
          <label><input type="checkbox" name="accommodation[]" value="Highest Popularity"> Highest Popularity</label>
          <label><input type="checkbox" name="accommodation[]" value="Lowest Popularity"> Lowest Popularity</label>
        </div>
        <div class="d-flex justify-content-end" style="gap: 8px;">
            <button class="btn button-save" style="border-radius: 25px; padding: 5px 15px; color: white; background: #87CEEB; border: 1px solid #87CEEB;">Save</button>
            <button class="btn reset-save" style="border-radius: 25px; padding: 5px 15px; color: #87CEEB; background: transparent; border: 1px solid #87CEEB;">Reset</button>
          </div>
      </div>
    </div>
   </div>

 </div>

<!-- price filter modal -->
 <div class="modal fade" id="exampleModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
     <div class="modal-content">
      <div class="modal-body">
         <button type="button" class="ml-auto d-flex justify-content-end" style="border: none !important; background: #fff !important;" data-bs-dismiss="modal" aria-label="Close">
          <i class="bi bi-x-lg"></i>
        </button>
        <h5 class="poppins-semibold" style="padding: 0px 16px 5px 16px;">
          Price:
        </h5>
          <div id="slider"></div>
          <div class="mt-4 price-range w-100" style="display: flex; gap: 10px; margin-top: 10px;">
            <input type="number" id="min-price" style="width: 100%; height: 35px;"> 
            <span> - </span>
            <input type="number" id="max-price" style="width: 100%; height: 35px;">
          </div>
          <div class="checkbox-group show mt-5">
          <span class="text-muted">*commonly used price ranges</span>
          <label><input type="checkbox" name="accommodation[]" value=""> IDR 500.000 - IDR 1.000.000</label>
          <label><input type="checkbox" name="accommodation[]" value=""> IDR 1.000.000 - 1.500.000</label>
          <label><input type="checkbox" name="accommodation[]" value=""> IDR 1.500.000 - 2.000.000</label>
        </div>
        <div class="d-flex justify-content-end" style="gap: 8px;">
            <button class="btn button-save" style="border-radius: 25px; padding: 5px 15px; color: white; background: #87CEEB; border: 1px solid #87CEEB;">Save</button>
            <button class="btn reset-save" style="border-radius: 25px; padding: 5px 15px; color: #87CEEB; background: transparent; border: 1px solid #87CEEB;">Reset</button>
          </div>
      </div>
    </div>
   </div>

 </div>

<!-- rating filter modal -->
 <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
     <div class="modal-content">
      <div class="modal-body">
         <button type="button" class="ml-auto d-flex justify-content-end" style="border: none !important; background: #fff !important;" data-bs-dismiss="modal" aria-label="Close">
          <i class="bi bi-x-lg"></i>
          </button>
          <h5 class="poppins-semibold" style="padding: 0px 16px 5px 16px;">
            Rating:
          </h5> 
          <div class="checkbox-group show">
            <label><input type="checkbox" name="accommodation[]" value="1"> 1<i class="bi bi-star-fill text-warning"></i></label>
            <label><input type="checkbox" name="accommodation[]" value="2"> 2<i class="bi bi-star-fill text-warning"></i></label>
            <label><input type="checkbox" name="accommodation[]" value="3"> 3<i class="bi bi-star-fill text-warning"></i></label>
            <label><input type="checkbox" name="accommodation[]" value="4"> 4<i class="bi bi-star-fill text-warning"></i></label>
            <label><input type="checkbox" name="accommodation[]" value="5"> 5<i class="bi bi-star-fill text-warning"></i></label>
          </div>
          <div class="d-flex justify-content-end" style="gap: 8px;">
            <button class="btn button-save" style="border-radius: 25px; padding: 5px 15px; color: white; background: #87CEEB; border: 1px solid #87CEEB;">Save</button>
            <button class="btn reset-save" style="border-radius: 25px; padding: 5px 15px; color: #87CEEB; background: transparent; border: 1px solid #87CEEB;">Reset</button>
          </div>
      </div>
    </div>
   </div>
 </div>

<!-- areas filter modal -->
 <div class="modal fade" id="exampleModal3" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
     <div class="modal-content">
      <div class="modal-body">
         <button type="button" class="ml-auto d-flex justify-content-end" style="border: none !important; background: #fff !important;" data-bs-dismiss="modal" aria-label="Close">
          <i class="bi bi-x-lg"></i>
          </button>
          <h5 class="poppins-semibold" style="padding: 0px 16px 5px 16px;">
            Areas:
          </h5> 
          <div class="checkbox-group show">
            <h5 class="poppins-medium pt-3" style="border-top: 1px solid #c0c0c0;">Bali</h5>
            <label><input type="checkbox" name="accommodation[]" value="Ubud"> Ubud</label>
            <label><input type="checkbox" name="accommodation[]" value="Kintamani"> Kintamani</label>
            <label><input type="checkbox" name="accommodation[]" value="Canggu"> Canggu</label>
            <label><input type="checkbox" name="accommodation[]" value="Nusa Dua"> Nusa Dua</label>
            <label><input type="checkbox" name="accommodation[]" value="Petitenget"> Petitenget</label>
          </div>
          <div class="checkbox-group show">
            <h5 class="poppins-medium pt-3" style="border-top: 1px solid #c0c0c0;">Lombok</h5>
            <label><input type="checkbox" name="accommodation[]" value="Ubud"> Ubud</label>
            <label><input type="checkbox" name="accommodation[]" value="Kintamani"> Kintamani</label>
            <label><input type="checkbox" name="accommodation[]" value="Canggu"> Canggu</label>
            <label><input type="checkbox" name="accommodation[]" value="Nusa Dua"> Nusa Dua</label>
            <label><input type="checkbox" name="accommodation[]" value="Petitenget"> Petitenget</label>
          </div>
          <div class="d-flex justify-content-end" style="gap: 8px;">
            <button class="btn button-save" style="border-radius: 25px; padding: 5px 15px; color: white; background: #87CEEB; border: 1px solid #87CEEB;">Save</button>
            <button class="btn reset-save" style="border-radius: 25px; padding: 5px 15px; color: #87CEEB; background: transparent; border: 1px solid #87CEEB;">Reset</button>
          </div>
      </div>
    </div>
   </div>
 </div>

<!-- things to do filter modal -->
 <div class="modal fade" id="exampleModal4" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
     <div class="modal-content">
      <div class="modal-body">
         <button type="button" class="ml-auto d-flex justify-content-end" style="border: none !important; background: #fff !important;" data-bs-dismiss="modal" aria-label="Close">
          <i class="bi bi-x-lg"></i>
          </button>
          <h5 class="poppins-semibold" style="padding: 0px 16px 5px 16px;">
            Things To Do:
          </h5> 
          <div class="checkbox-group show">
            <label><input type="checkbox" name="accommodation[]" value="Food & Dining"> Food & Dining</label>
            <label><input type="checkbox" name="accommodation[]" value="Car Charter"> Car Charter</label>
            <label><input type="checkbox" name="accommodation[]" value="Spa & Salon"> Spa & Salon</label>
            <label><input type="checkbox" name="accommodation[]" value="Water Activity"> Water Activity</label>
            <label><input type="checkbox" name="accommodation[]" value="Mobile Massage"> Mobile Massage</label>
          </div>
          <div class="d-flex justify-content-end" style="gap: 8px;">
            <button class="btn button-save" style="border-radius: 25px; padding: 5px 15px; color: white; background: #87CEEB; border: 1px solid #87CEEB;">Save</button>
            <button class="btn reset-save" style="border-radius: 25px; padding: 5px 15px; color: #87CEEB; background: transparent; border: 1px solid #87CEEB;">Reset</button>
          </div>
      </div>
    </div>
   </div>
 </div>
{% else %}
  <div class="d-flex justify-content-center my-5">
    <img src="{{ url() }}img/no-data2.png" style="width: 40%;">
  </div>
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
