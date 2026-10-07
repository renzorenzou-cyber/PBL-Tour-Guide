<!-- Top Bar -->
<div class="top-bar u-header__section g-transition-0_3 py-1" style="background:#fff">
  <div class="container">
    <div class="row d-flex justify-content-between align-items-center">
      <div>
        <!-- Logo -->
        <a href="{{ url() }}" class="navbar-brand">
          <img src="{{ url() }}img/logo.png" height="40px" alt="Tropialis, the best tour and travel in Bali">
        </a>
        <!-- End Logo -->
      </div>

     
        <div class="top-right d-flex align-items-center" style="gap: 2rem;">
          <?php /*?><div class="col-2-sm-auto g-hidden-sm-down g-color-brown g-font-weight-400 g-pl-15 g-pl-0--sm g-py-14 d-flex align-items-center">
            <a href="https://wa.me/62881037336399" target="_blank" class="g-color-brown tropialis-text-hover">
              <i class="fa fa-whatsapp u-line-icon-pro g-font-size-18 g-valign-middle g-color-brown g-mr-1 g-mt-minus-2"></i>
            +62-881-0373-36399</a>
          </div>
          <div class="poppins-medium top-menu">
            <a class="btn btn-primary text-light" style="height: 40px;" href="{{ url() }}page/enquiry/">Make enquiry</a>
          </div><?php */?>

          <div class="poppins-medium top-menu">
            <!-- List -->
            <ul class="list-inline g-overflow-hidden g-pt-1 g-mx-minus-4 mb-0">
              
              <!-- Areas-->
               <li class="list-inline-item">
                <a id="account-dropdown-invoker-2" class="g-text-underline--none--hover" href=""
                    aria-controls="account-dropdown-2"
                    aria-haspopup="true"
                    aria-expanded="false"
                    data-dropdown-event="hover"
                    data-dropdown-target="#account-dropdown-2"
                    data-dropdown-type="css-animation"
                    data-dropdown-duration="300"
                    data-dropdown-hide-on-scroll="false"
                    data-dropdown-animation-in="fadeIn"
                    data-dropdown-animation-out="fadeOut">
                    <div class="d-flex gap-5 align-items-center" style="gap: .5rem;">
                      <i class="bi bi-geo-alt" style="font-size: 18px;"></i>
                      <?php
                      $areas = $this->session->get('areas')['selected'];
                      $decodedArea = ucwords(str_replace('-', ' ', $areas));
                      ?>

                      <span class="select-areas-text" id="selectedAreas"><?php echo $decodedArea ?></span>
                    </div>
                </a>
                <ul id="account-dropdown-2" class="list-unstyled u-shadow-v29 g-pos-abs g-bg-white g-width-160 g-pb-5 g-mt-10 g-z-index-2"
                    aria-labelledby="account-dropdown-invoker-2">
                  <!-- <li>
                    <a class="d-block g-color-black g-color-primary--hover g-text-underline--none--hover g-font-weight-400 g-py-5 g-px-20" href="{{ url() }}area/east-java/">
                      East Java
                    </a>
                  </li> -->
                  {% for ar in parent %}
                    <li>
                      <a class="changeareas d-block g-color-black g-color-primary--hover g-text-underline--none--hover g-font-weight-400 g-py-5 g-px-20" style="cursor: pointer;" data-areas="{{ar.area_url}}">
                        {{ar.area_name}}
                      </a>
                    </li>
                  {% endfor %}
                </ul>
              </li>
              <!-- End Areas -->
            </ul> 
            <!-- End List -->
          </div> 
          <div class="poppins-medium top-menu d-none d-md-block">
            <?php /*?><span>Become a Supplier</span><?php */?>
          </div>
          <?php if($this->session->has('trop_auth') == false){?>
          <div class="poppins-medium top-menu d-flex align-items-center">
            <ul class="profile list-inline g-overflow-hidden" style="margin: 0;">
            <!-- Account -->
              <li class="list-inline-item">
                <a href="{{ url() }}account/login/">
                  <span class="login-text my-auto">Login/Signup</span>
                  <i class="bi bi-person-circle my-auto" style="display: none;"></i>
                </a>
              </li>
            <!-- End Account -->
            </ul>
          </div>
          <?php } else {?>
          <div class="poppins-medium top-menu d-flex align-items-center">
            <ul class="list-inline g-overflow-hidden" style="margin: auto 0;">
              <!-- Account -->
              <li class="list-inline-item">
                <a href="{{ url() }}account/orders/" class="g-color-brown tropialis-text-hover g-font-weight-400 g-text-underline--none--hover">
                    <div class="d-flex gap-5 align-items-center" style="gap: .5rem;">
                      <?php if($this->session->get('trop_auth')['customer_id'] == 'google'): ?>
                      <img src="<?php echo $this->session->get('trop_auth')['customer_picture']?>" width="35px" height="35px" style="border-radius: 50%;">
                      <?php else: ?>
                      <img src="{{ config.vars.picUrl }}/<?php echo $this->session->get('trop_auth')['customer_picture']?>" width="35px" height="35px" style="border-radius: 50%;">
                      <?php endif; ?>
                      <span class="d-none d-md-block"><?php echo $this->session->get('trop_auth')['customer_name']?></span>
                    </div>
                </a>
              </li>
              <!-- End Account -->
            </ul>
          </div>
          <?php }?>
          <div class="d-flex align-items-center" style="gap: 25px;">
            <!-- wishlist -->
            <div class="d-inline-block">
            <a href="{{ url() }}wishlist/" class="top-icon">
              <i class="bi bi-heart"></i>
            </a>
            </div>
          
            <!-- Basket -->
            <div class="u-basket d-inline-block g-z-index-3">
              {% if dispatcher.getControllerName() != 'cart' %}
              <div id="cart-icon">
                <a href="{{ url() }}cart/" id="basket-bar-invoker" class="top-icon"
                    aria-controls="basket-bar"
                    aria-haspopup="true"
                    aria-expanded="false"
                    data-dropdown-event="hover"
                    data-dropdown-target="#basket-bar"
                    data-dropdown-type="css-animation"
                    data-dropdown-duration="300"
                    data-dropdown-hide-on-scroll="false"
                    data-dropdown-animation-in="fadeIn"
                    data-dropdown-animation-out="fadeOut">
                  <?php if($this->session->has('cart') == true){?><span class="u-badge-v1--sm g-color-white g-bg-primary g-font-size-11 g-line-height-1_4 g-rounded-50x g-pa-4" style="top: 7px !important; right: 3px !important;"><?php echo count($this->session->get('cart'));?></span><?php }?>
                  <i class="bi bi-cart3"></i>
                </a>
              </div>
              {% endif %}
    
              <?php /*?><div id="basket-bar" class="u-basket__bar u-dropdown--css-animation u-dropdown--hidden g-text-transform-none g-bg-white g-brd-around g-brd-gray-light-v4" aria-labelledby="basket-bar-invoker">
                <div class="g-brd-bottom g-brd-gray-light-v4 g-pa-15 g-mb-10">
                  <span class="d-block h6 text-center text-uppercase mb-0">Shopping Cart</span>
                </div>
                <div class="js-scrollbar g-height-200">
                  <?php foreach($this->session->get('cart') as $key=>$val){?>
                  <div class="u-basket__product g-brd-none g-px-20">
                    <div class="row no-gutters g-pb-5">
                      <div class="col-4 pr-3">
                        <a class="u-basket__product-img" href="#!">
                          <img class="img-fluid" src="{{ config.vars.picUrl }}/products/<?php echo $val['item_id'];?>/<?php echo $val['item_pix'];?>" alt="Image Description">
                        </a>
                      </div>
    
                      <div>
                        <h6 class="g-font-weight-500 g-font-size-default">
                          <a class="g-color-black g-color-primary--hover g-text-underline--none--hover" href="#!"><?php echo $val['item'];?>/<?php echo $val['item_rate'];?>/<?php echo $val['item_optrate'];?></a>
                        </h6>
                        <small class="g-font-size-12"><?php echo $val['item_qty'];?> x Rp<?php echo $val['item_price'];?></small>
                      </div>
                    </div>
                    <button type="button" class="u-basket__product-remove">&times;</button>
                  </div>
                  <?php }?>
    
                </div>
    
                <div class="clearfix g-px-15">
                  <div class="align-items-center text-center g-brd-y g-brd-gray-light-v4 g-font-size-default">
                    <div class="g-brd-right g-brd-gray-light-v4">
                      <strong class="d-block g-py-10 text-uppercase g-color-main g-font-weight-500 g-py-10">Total</strong>
                    </div>
                    <div>
                      <strong class="d-block g-py-10 g-color-main g-font-weight-500 g-py-10">$433.00</strong>
                    </div>
                  </div>
                </div>
    
                <div class="g-pa-20">
                  <div class="text-center g-mb-15">
                    <a class="text-uppercase g-color-primary g-color-main--hover g-font-weight-500 g-font-size-13 g-text-underline--none--hover" href="page-checkout-1.html">
                      View Cart
                      <i class="ml-2 icon-finance-100 u-line-icon-pro"></i>
                    </a>
                  </div>
                  <a class="btn btn-block u-btn-black g-brd-primary--hover g-bg-primary--hover g-font-size-12 text-uppercase rounded g-py-10" href="page-checkout-1.html">Proceed to Checkout</a>
                </div>
              </div><?php */?>
            </div>
            <!-- End Basket -->
    
            <!-- Search -->
            <!-- <div class="d-inline-block g-valign-middle"> -->
              <!-- <div class="g-py-10">
                <a href="#!" class="g-color-brown g-color-primary--hover g-font-size-17 g-text-underline--none--hover"
                    aria-haspopup="true"
                    aria-expanded="false"
                    data-dropdown-event="hover"
                    aria-controls="searchform-1"
                    data-dropdown-target="#searchform-1"
                    data-dropdown-type="css-animation"
                    data-dropdown-duration="300"
                    data-dropdown-animation-in="fadeInUp"
                    data-dropdown-animation-out="fadeOutDown">
                  <i class="g-pos-rel g-top-3 icon-education-045 u-line-icon-pro"></i>
                </a>
              </div> -->
    
              <!-- Search Form -->
              <!-- <form id="searchform-1" class="u-searchform-v1 u-dropdown--css-animation u-dropdown--hidden u-shadow-v20 g-brd-around g-brd-gray-light-v4 g-bg-white g-right-0 rounded g-pa-10 1g-mt-8">
                <div class="input-group">
                  <input id="search-top" class="form-control g-font-size-13 w-100" type="text" placeholder="Search Here...">
                  <div class="input-group-btn p-0">
                    <button id="btn-search-top" class="btn u-btn-primary g-font-size-12 text-uppercase g-py-13 g-px-15" type="button">GO</button>
                  </div>
                </div>
              </form> -->
              <!-- End Search Form -->
            <!-- </div> -->
            <!-- End Search -->
          </div>
        </div>
     
    </div>
  </div>
</div>
<!-- End Top Bar -->