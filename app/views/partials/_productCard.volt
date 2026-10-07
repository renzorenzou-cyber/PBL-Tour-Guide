<div class="col-sm-12 col-md-6 col-lg-3 d-flex justify-content-center">
          <div class="card card-fixed shadow position-relative">
            <!-- Image -->
            <figure>
              <!-- <img class="articleimage" src="{{ config.vars.picUrl }}/products/{{ pack.id }}/{{ pack.picture }}" alt="{{ pack.name }}"> -->
              <div class="swiper-container" data-product-id="{{ p.id }}">
                <div class="swiper-wrapper">
                  {% for image in images %}
                    {% if image.id == p.id %}
                      <div class="swiper-slide">
                        <a href="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" data-fancybox="gallery-{{ p.id }}" data-caption="{{ p.name }}">
                          <img src="{{ config.vars.picUrl }}/products/{{ p.id }}/{{ image.picture }}" alt="{{ p.name }}">
                        </a>
                      </div>
                    {% endif %}
                  {% endfor %}
                </div>

                <div class="swiper-button-next" style="color:white; width: 25px; height: 80px;"></div>
                <div class="swiper-button-prev" style="color:white; width: 25px; height: 80px;"></div>
              </div>

              <div class="d-flex justify-content-between">
                <figcaption class="label-top poppins-medium" style="transform: translateY(-590%); z-index: 1;">{{ p.group_product }}</figcaption>
                <div class="heart-icon">
                  {% if p.id in wishlistProductIds %}
                    <i class="bi bi-heart-fill wishlist active" data-product-id="{{ p.id }}"></i>
                  {% else %}
                    <i class="bi bi-heart wishlist" data-product-id="{{ p.id }}"></i>
                  {% endif %}
                </div>
              </div>
            </figure>
            <!-- End Article Image -->

            <!-- Konten -->
             <?php $stats = $reviewStats[$p->id]; ?>
            <div class="card-body d-flex flex-column justify-content-between" style="height: 150px;">
              <div class="card-top">
                <a class="h4 poppins-semibold card-title truncate-text" href="{{ url() }}{{ p.id }}/{{ p.slug }}/">{{ p.name }}</a>
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
                      <?php if ($p->ordered > 0): ?>
                      <span>・</span>
                    <span><?= ($p->ordered >= 1000) 
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
                  <div class="d-flex align-items-center" style="gap: 3px;">
                    <div class="d-flex" style="gap: 8px;">
                       <?php
                          $rating = number_format($stats['average_rating'], 1);
                          echo '<i class="bi bi-star-fill text-warning"></i> ';
                        ?>
                        <?= $stats['average_rating'] ?>/5 (<?= $stats['total_review'] ?>)
                    </div>
                    <?php if ($p->ordered > 0): ?>
                    <span>・</span>
                    <span><?= ($p->ordered >= 1000) 
                            ? (intval($p->ordered / 1000) == ($p->ordered / 1000) 
                                ? intval($p->ordered / 1000) 
                                : number_format($p->ordered / 1000, 1)
                              ) . 'k' 
                            : $p->ordered 
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
              
              {% if hotdeals[p.id]['min_publish_price'] > 0 %}
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
              {% else %}
              <h6 style="color: red;">Not Available</h6>
              <p>Currently it is not possible to book this product due to its limited availability.</p>
              {% endif %}
            </div>
          </div>
        </div>