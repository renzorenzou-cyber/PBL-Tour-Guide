<section class="py-0">
    <div class="container">
        <div class="row mt-4 align-items-center">
            <div class="col-12">
                <div>
                    <h2 class="h3 g-color-black g-font-weight-500 mb-0 mt-5">BOOKING CART</h2>
                    <div class="d-inline-block g-width-70 g-height-2 g-bg-black"></div>
                  </div>
                <!-- Card START -->
                <!-- <div class="overflow-hidden px-sm-5" >
                    <div class="row align-items-center g-4"> -->
                        <!-- Content -->
                        <!-- <div class="banner" style="border-radius: 15px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                            <div class="left-section">
                                <img  src="{{ url() }}assets/img/inline/checkout.png" style="width: 150px;  " alt="">
                            </div>
                            <div class="right-section">
                                <ol class="breadcrumb breadcrumb-dots mb-0" style="background-color: #2c3e50;" >
                                    <li class="breadcrumb-item">
                                        <a href="{{ url() }}">Continue Explore your holiday</a>
                                    </li>
                                </ol>
                                <h1 class="m-0 h2 card-title" style="font-weight: bold; padding-left:15px; font-size:50px;">Checkout</h1>
                            </div>
                        </div> -->

                        <!-- Image -->
                    <!-- </div> -->
                </div>
                <!-- Card END -->
            </div>
        </div>
    </div>
</section>

<section>
    <div class="container">
        <?php if(!$this->session->has('cart')) { ?>
            <div class="text-center mt-5 mb-5 col-xl-12">
                <h5 class="text-danger">Shopping cart empty!</h5>
            </div>
            <div class="text-center mt-5 mb-5">
                <a href="{{ url() }}" class="btn btn-success btn-lg">
                    <i class="bi bi-search"></i> Explore your journey
                </a>
            </div>
        <?php } else { ?>
        <div>
            <!-- Step content START -->
            <div class="bs-stepper-content p-0 pt-3 mt-3">
                <div class="row g-4">
                    <div class="col-xl-8">
                        <form id="form_cart" onsubmit="return false">
                            <div class="content">
                                <div class="vstack gap-4">
                                    <!-- Title -->
                                    <h4 class="mb-3 text-dark">Thursday, March 27</h4>
                                    <hr class="my-0"> <!-- Divider -->

                                    <?php 
                                    //print_r($_SESSION);
                                    $total = 0;
                                    foreach($this->session->get('cart') as $key => $val) {
                                        if (!empty($val['item_hotdeal_total'])) { 
                                            $total += $val['item_hotdeal_total'];
                                        } else { 
                                            $total += $val['item_total'];
                                        } 
                                    ?>
                                    <!-- Tour list START -->
                                    <div class="card mb-4" style="border-radius: 20px; border: 1px solid #e0e0e0;">
                                        <div class="row g-0">
                                            <!-- Image -->
                                            <div class="col-sm-6 col-md-4">
                                                <img src="{{ config.vars.picUrl }}/products/<?php echo $val['item_id'];?>/<?php echo $val['item_pix'];?>" class="img-fluid rounded-start p-3" alt="" style=" height:180px; border-radius: 30px;">
                                            </div>

                                            <!-- Card Body START -->
                                            <div class="col-sm-6 col-md-8">
                                                <div class="card-body p-4">
                                                    <!-- Title -->
                                                     <div class="d-flex justify-content-between">
                                                        <h5 class="card-title mb-2 poppins-semibold">
                                                            <a href="{{ url() }}<?php echo $val['item_id'];?>/<?php echo $val['item_url'];?>/" class="text-dark"><?php echo $val['item'];?></a>
                                                        </h5>
                                                        <div>
                                                            <div class="col-lg-3 d-flex text-right align-items-center fs-14" style="font-size: 12pt;">
                                                                <?php if (!empty($val['item_hotdeal_total'])) { ?>
                                                                    <span class="me-3"><span class="activecurrency"></span><span class="sub_total valuecurrency" data-baseprice="<?php echo $val['item_hotdeal_total'];?>"></span></span>
                                                                    <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['id'];?>">
                                                                        <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                    </a>
                                                                <?php } else { ?>
                                                                    <span><span class="activecurrency"></span><span class="sub_total valuecurrency" data-baseprice="<?php echo $val['item_total'];?>"></span></span>
                                                                    <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['id'];?>">
                                                                        <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                    </a>
                                                                <?php } ?>
                                                            </div>
                                                        </div>
                                                     </div>
                                                    
                                                    <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                        <?xml version="1.0" ?>
                                                        <svg height="16" viewBox="0 0 24 24" width="16" xmlns="http://www.w3.org/2000/svg">
                                                        <path fill="rgba(0,0,0,0.5)" d="M20.787 9.023c-.125.027-1.803.418-3.953 1.774-.323-1.567-1.279-4.501-4.108-7.485L12 2.546l-.726.767C8.435 6.308 7.483 9.25 7.163 10.827 5.005 9.448 3.34 9.052 3.218 9.024L2 8.752V10c0 7.29 3.925 12 10 12 5.981 0 10-4.822 10-12V8.758l-1.213.265zM8.999 12.038c.002-.033.152-3.1 3.001-6.532C14.814 8.906 14.999 12 15 12v.125a18.933 18.933 0 0 0-3.01 3.154 19.877 19.877 0 0 0-2.991-3.113v-.128zM12 20c-5.316 0-7.549-4.196-7.937-8.564 1.655.718 4.616 2.426 7.107 6.123l.841 1.249.825-1.26c2.426-3.708 5.425-5.411 7.096-6.122C19.534 15.654 17.304 20 12 20z"/>
                                                        </svg>
                                                        <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php echo $val['item_rate'];?> / <?php echo $val['item_optrate'];?></h6>
                                                    </div>
                                                    <!-- Rating star -->
                                                    <!-- <ul class="list-inline mb-0">
                                                        <?php for ($i = 0; $i < 5; $i++): ?>
                                                            <li class="list-inline-item me-0 small">
                                                                <i class="fa fa-star text-warning"></i>
                                                            </li>
                                                        <?php endfor; ?>
                                                    </ul> -->

                                                    <!-- List -->
                                                    <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" class="bi bi-clock clock-icon" viewBox="0 0 16 16">
                                                            <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71z"/>
                                                            <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0"/>
                                                          </svg>
                                                          
                                                        <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php echo $val['tanggal'];?> ・ <?php echo $val['timeselection'];?></h6>
                                                    </div>

                                                    <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" class="bi bi-people people-icon" viewBox="0 0 16 16">
                                                            <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                                                          </svg>
                                                             
                                                          <style>
                                                            .people-icon {
                                                              fill: rgba(0, 0, 0, 0.5); /* Warna hitam dengan opacity 50% */
                                                            }
                                                          </style>
                                                          
                                                          <div class="col-lg-3">
                                                            <input type="hidden" name="order_date" value="<?php echo $val['tanggal'];?>" />
                                                            <input type="hidden" name="order_time" value="<?php echo $val['timeselection'];?>" />
                                                            <input type="hidden" name="id" value="<?php echo $val['id'];?>" />
                                                            <input data-harga="<?php echo $val['item_price'];?>" name="qty" class="form-control qty" type="number" min="0" value="<?php echo $val['item_qty'];?>" />
                                                        </div>
                                                    </div>

                                                    
                                                    <div class="row mt-2">
                                                        <div class="col-lg-6">
                                                            <div class="d-flex" style="gap: 5px;">
                                                                <div>
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="rgba(0,0,0,0.5)" class="bi bi-cash-coin" viewBox="0 0 16 16">
                                                                        <path fill-rule="evenodd" d="M11 15a4 4 0 1 0 0-8 4 4 0 0 0 0 8m5-4a5 5 0 1 1-10 0 5 5 0 0 1 10 0"/>
                                                                        <path d="M9.438 11.944c.047.596.518 1.06 1.363 1.116v.44h.375v-.443c.875-.061 1.386-.529 1.386-1.207 0-.618-.39-.936-1.09-1.1l-.296-.07v-1.2c.376.043.614.248.671.532h.658c-.047-.575-.54-1.024-1.329-1.073V8.5h-.375v.45c-.747.073-1.255.522-1.255 1.158 0 .562.378.92 1.007 1.066l.248.061v1.272c-.384-.058-.639-.27-.696-.563h-.668zm1.36-1.354c-.369-.085-.569-.26-.569-.522 0-.294.216-.514.572-.578v1.1zm.432.746c.449.104.655.272.655.569 0 .339-.257.571-.709.614v-1.195z"/>
                                                                        <path d="M1 0a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h4.083q.088-.517.258-1H3a2 2 0 0 0-2-2V3a2 2 0 0 0 2-2h10a2 2 0 0 0 2 2v3.528c.38.34.717.728 1 1.154V1a1 1 0 0 0-1-1z"/>
                                                                        <path d="M9.998 5.083 10 5a2 2 0 1 0-3.132 1.65 6 6 0 0 1 3.13-1.567"/>
                                                                      </svg>                                                                  
                                                                </div>
                                                                <div>
                                                                    <h6 class="text-dark">Price</h6>
                                                                    <h6 style="color:rgba(0,0,0,.5);">
                                                                        <span><?php echo $val['item_qty']?> x </span>
                                                                        <span><?php if ($val['item_hotdeal_price'] > 0) { ?>
                                                                        <span class="activecurrency" style="color: rgba(0, 0, 0, .5)"></span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_price']?>" data-hotdeal="<?php echo $val['item_hotdeal_price']?>"></span></span>
                                                                    <?php } else { ?>
                                                                        <span class="activecurrency"></span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_price']?>"></span>
                                                                    <?php } ?>
                                                                    </h6>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 mt-1" style="text-align: right;">
                                                            <?php if ($val['item_hotdeal_total'] > 0) { ?>
                                                                    <h5><span class="activecurrency" style="color: rgba(0, 0, 0, .5)"></span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_total']?>" data-hotdeal="<?php echo $val['item_hotdeal_total']?>"></span></h5>
                                                            <?php } else { ?>
                                                                <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"></span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total']?>"></span></h5>
                                                            <?php } ?>
                                                        </div>
                                                        
                                                    </div>

                                                    <?php /*?><div class="text-end text-dark mt-2">
                                                        <button class="btn btn-sm btn-danger extraform" data-group="<?php echo $val['item_group'];?>" data-id="<?php echo $val['id'];?>">
                                                            Add Extra Info
                                                        </button>
                                                    </div><?php */?>
                                                    <div class="mt-2"><hr />
                                                        <h5 class="text-dark" style="font-size: 12pt; text-align: end; margin: auto 0;">More Information (Optional)</h5>
                                                        <div class="extra_infos mt-4" style="color: #333;"  data-id="<?php echo $val['id'];?>" data-group="<?php echo $val['item_group'];?>">
                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Card body END -->
                                        </div>
                                    </div>
                                    <!-- Tour list END -->
                                    <?php } ?>

                                    <!-- Step 1 button -->
                                    <div class="d-flex justify-content-end align-items-center" style="gap: 10px;">
                                        <a href="{{ url() }}" class="btn btn-custom d-flex justify-content-center align-items-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="24" fill="currentColor" class="bi bi-chevron-left" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
                                            </svg>
                                        </a>
                                        <button class="btn btn-custom-2 poppins-medium" id="updatecart">Update Cart</button>
                                        <button class="btn btn-custom  poppins-medium" id="clearcart">Clear Cart</button>
                                    </div>
                                </div>

                                <style>
                                    .btn-custom {
                                        background-color: #87CEEB;
                                        border: solid 2px #87CEEB;
                                        border-radius: 50px;
                                        color: white;
                                    }

                                    .btn-custom:hover {
                                        background-color: transparent;
                                        border: solid 2px #87CEEB;
                                        border-radius: 50px;
                                        color: #87CEEB;
                                        transition: all 0.3s;
                                    }

                                    .btn-custom-2 {
                                        background-color: transparent;
                                        border: solid 2px #87CEEB;
                                        border-radius: 50px;
                                        color: #87CEEB;
                                        transition: all 0.3s;
                                    }

                                    .btn-custom-2:hover {
                                        background-color: #87CEEB;
                                        border: solid 2px #87CEEB;
                                        border-radius: 50px;
                                        color: white;
                                    }
                                    
                                </style>

                                <!-- Traveler Information -->
                                <div class="vstack gap-4 mt-5">
                                    <h4 class="mb-3" style="color: rgb(0, 0, 0)">Traveler Information</h4>
                                    <hr class="my-0"> <!-- Divider -->

                                    <!-- Traveler form START -->
                                    <div class="card border" style="border-radius: 15px;">
                                        <div class="card-header border-bottom">
                                            <h5 class="mb-0" style="color: rgb(0, 0, 0)">Customer Detail</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row g-4">
                                                <!-- First Name -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">First name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control border-5" name="first_name" placeholder="Your First Name">
                                                    </div>
                                                </div>

                                                <!-- Last name -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Last name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control border-5" name="last_name" placeholder="Your Last Name">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row g-4 mt-3">

                                                <!-- Passport number -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">ID / Passport number <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control border-5" name="passport" placeholder="Your Passport Number">
                                                    </div>
                                                </div>

                                                <!-- Country -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Country <span class="text-danger">*</span></label>
                                                        <select class="form-control border-5" name="country" id="country">
                                                            <option value="Indonesia">Indonesia</option>
                                                            {% for c in countries %}
                                                                <option value="{{ c.iso2 }}">{{ c.short_name }}</option>
                                                            {% endfor %}
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Traveler form END -->

                                    <!-- Booking detail START -->
                                    <div class="card border mt-3 mb-5" style="border-radius: 15px;">
                                        <div class="card-header border-bottom">
                                            <h5 class="mb-0" style="color: rgb(0, 0, 0)">Your booking detail will be sent here</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row g-4">
                                                <!-- Mobile number -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Mobile Number <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="phone_number" id="phone_number" placeholder="Your Phone Number" />
                                                        <span id="phone_text"></span>
                                                    </div>
                                                </div>

                                                <!-- Email id -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Email <span class="text-danger">*</span></label>
                                                        <input type="email" class="form-control" name="email" id="email" placeholder="Your Email" />
                                                        <span id="emailMessage"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Booking detail END -->
                                </div>
                            </div>
                            <input type="hidden" id="data_total" name="total" class="form-control" value="<?php echo $total?>">
                        </form>
                    </div>

                    <!-- Right sidebar START -->
                    <aside class="col-xl-4">
                        <div class="vstack gap-4">
                            <!-- Price summary START -->
                            <div class="card border" style="border-radius: 20px;">
                                <!-- Card body -->
                                <div class="card-body px-4">
                                    <ul class="list-group">
                                        <li class="d-flex justify-content-between align-items-center pt-0">
                                            <h5 class="poppins-semibold mb-0 pt-3">SubTotal <br> (<?php echo count($this->session->get('cart'));?> Item)</h5>
                                            <h5 class="fs-5 poppins-semibold"><span class="activecurrency"></span><span class="valuecurrency" data-baseprice="<?php echo $total?>"></span></h5>
                                        </li>
                                        <h6 class="d-flex justify-content-between align-items-center pt-3" id="discount">

                                        </h6>
                                        <hr style="color: black;width:95%">
                                        <li class="d-flex justify-content-between align-items-center pt-0">
                                            <h5 class="poppins-semibold mb-0 pt-3">Total</h5>
                                            <h5 class="fs-5"><span class="h5 mb-0" id="newTotal"><span class="activecurrency"></span><span class="valuecurrency" data-baseprice="<?php echo $total;?>"> <?php echo number_format($total, 0, ',', '.');?></span></span></h5>
                                        </li>
                                    </ul>
                                    <a href="javascript:void(0);" id="applyPromoLink" class="g-color-primary-v2 mt-3 d-block">Apply Promo Code</a>
                                    <div id="promoCodeForm" class="promo-form mt-3 mb-3">
                                        <form id="promotionForm">
                                            <div class="input-group">
                                                <input type="text" id="promoCode" name="promo_code" class="form-control" placeholder="Enter Promo Code">
                                                <input type="hidden"  name="total" class="form-control" value="<?php echo $total?>">
                                                <button class="btn btn-primary" id="applyPromoButton">Apply</button>
                                            </div>
                                        </form>
                                        <small id="promoFeedback" class="text-danger mt-2" style="display: none;">Invalid promo code!</small>
                                    </div>
                                </div>
                                <div class="d-flex" style="margin-left: 10px;">
                                    <button class="btn btn-custom w-100 mb-3" id="checkout-button" style="margin-right: 20px;">Pay Now</button>
                                </div>
                            </div>
                            <!-- Price summary END -->
                        </div> <!-- Row END -->
                    </aside>
                    <!-- Right sidebar END -->
                </div>
            </div>
            <!-- Step content END -->
        </div>
        <?php } ?>
    </div>
</section>


<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
    }
    .banner {
        display: flex;
        width: 100%;
        height: 150px;
    }
    .left-section {
        background-color: #ffffff;
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding-left: 50px;
    }
    .left-section h1 {
        font-size: 24px;
        color: #333;
        margin: 0;
    }
    .left-section h2 {
        font-size: 18px;
        color: #999;
        margin: 10px 0;
    }
    .left-section p {
        font-size: 14px;
        color: #999;
        max-width: 300px;
    }
    .right-section {
        background-color: #2c3e50;
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        position: relative;
        padding: 20px;
    }
    .right-section::before {
        content: '';
        position: absolute;
        left: -30px;
        top: 0;
        bottom: 0;
        width: 60px;
        background-color: #87CEEB ;
        transform: skewX(-20deg);
    }
    .right-section::after {
        content: '';
        position: absolute;
        left: -60px;
        top: 0;
        bottom: 0;
        width: 60px;
        background-color: #ffffff;
        transform: skewX(-20deg);
    }
    .right-section h1 {
        font-size: 24px;
        color: #fff;
        margin: 0;
        z-index: 1;
    }
    .right-section h2 {
        font-size: 18px;
        color: #3498db;
        margin: 10px 0;
        z-index: 1;
    }
</style>