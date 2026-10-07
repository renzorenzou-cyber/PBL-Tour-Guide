<section class="py-0">
    <div class="container g-pt-50">
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
                                    <!-- <h4 class="mb-3 text-dark">Thursday, March 27</h4> -->

                                    <?php 
                                    $total = 0;
                                    foreach($this->session->get('cart') as $key => $val) {
                                        if (!empty($val['item_hotdeal_total'])) { 
                                            $total += $val['item_hotdeal_total'];
                                        } else { 
                                            $total += $val['item_total'];
                                        } 
                                    ?>
                                        <!-- Tour list START -->
                                    <?php if ($val['module'] == '10') { ?>
                                        <div class="card mb-4 w-100" style="border-radius: 20px; border: 1px solid #e0e0e0;">
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
                                                            <h5 class="card-title mb-3 poppins-semibold">
                                                                <a href="{{ url() }}<?php echo $val['item_id'];?>/<?php echo $val['item_url'];?>/" class="text-dark"><?php echo $val['item'];?></a>
                                                            </h5>
                                                            <div>
                                                                <div class="col-lg-3 d-flex text-right align-items-center fs-14" style="font-size: 12pt;">
                                                                        <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['cart_id'];?>">
                                                                            <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                        </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="d-flex" style="gap:3px;">
                                                            <?php $stats = $reviewStats[$val['item_id']]; ?>
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
                                                        
                                                        <div class="d-flex align-items-center mb-2" style="gap: 20px;">
                                                            <?xml version="1.0" ?>
                                                            <svg height="18" viewBox="0 0 24 24" width="18" xmlns="http://www.w3.org/2000/svg">
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
                                                        <div class="d-flex align-items-center mb-2" style="gap: 23px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" class="bi bi-clock clock-icon" viewBox="0 0 16 16" fill="rgba(0, 0, 0, 0.5)" stroke="rgba(0, 0, 0, 0.3)" stroke-width="0.5">
                                                                <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71z"/>
                                                                <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0"/>
                                                              </svg>
                                                              
                                                            
                                                            <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php echo $val['tanggal'];?> ・ <?php echo $val['timeselection'];?></h6>
                                                        </div>

                                                        <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" class="bi bi-people people-icon" viewBox="0 0 16 16" fill="rgba(0, 0, 0, 0.5)" stroke="rgba(0, 0, 0, 0.3)" stroke-width="0.5">
                                                                <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                                                            </svg>
                                                            
                                                            <div class="col-lg-3">
                                                                <input type="hidden" name="order_date" value="<?php echo $val['tanggal'];?>" />
                                                                <input type="hidden" name="order_time" value="<?php echo $val['timeselection'];?>" />
                                                                <input type="hidden" name="id" value="<?php echo $val['id'];?>" />
                                                                <div class="qty-wrapper">
                                                                    <input
                                                                        data-harga="<?php echo $val['item_price'];?>"
                                                                        name="qty"
                                                                        class="form-control qty"
                                                                        type="number"
                                                                        min="0"
                                                                        value="<?php echo $val['item_qty'];?>"
                                                                    />
                                                                    <input type="hidden" name="cart_id" value="<?php echo $val['cart_id'];?>">
                                                                    <h6 class="qty-label my-auto" style="color: rgba(0, 0, 0, .5);"><?php echo $val['item_unit'];?>(s)</h6>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="row mt-2">
                                                            <div class="col-6">
                                                                <div class="text-end text-dark mt-2">

                                                                    <button id="addExtras" class="btn btn-danger d-none justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" >
                                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                          </svg>  
                                                                        <div>
                                                                            <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                        </div>
                                                                    </button>
                                                                    
                                                                </div>
                                                                <!-- <div class="d-flex" style="gap: 5px;">
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
                                                                            <span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_price']?>" data-hotdeal="<?php echo $val['item_hotdeal_price']?>"> <?php echo number_format($val['item_hotdeal_price'], 0, ',', '.');?></span></span>
                                                                        <?php } else { ?>
                                                                            <span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_price'];?>"></span>
                                                                        <?php } ?>
                                                                        </h6>
                                                                    </div>
                                                                </div> -->
                                                            </div>
                                                            <div class="col-6 mt-2" style="text-align: right;">
                                                                <?php if ($val['item_hotdeal_total'] > 0) { ?>
                                                                        <h5><span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_total']?>" data-hotdeal="<?php echo $val['item_hotdeal_total']?>"> <?php echo number_format($val['item_hotdeal_total'], 0, ',', '.');?></span></h5>
                                                                <?php } else { ?>
                                                                    <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> <?php echo number_format($val['item_total'], 0, ',', '.');?></span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total'];?>"></span></h5>
                                                                <?php } ?>
                                                            </div>
                                                            
                                                        </div>

                                                        <!-- <div class="text-end text-dark mt-2">

                                                            <button id="addExtras" class="btn btn-danger d-flex justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-itemid="<?php echo $val['item_id'];?>" >
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                  </svg>  
                                                                <div>
                                                                    <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                </div>
                                                            </button>
                                                            
                                                        </div> -->
                                                        <div class="mt-2"><hr />
                                                            <h5 class="text-dark" style="font-size: 12pt; text-align: end; margin: auto 0;">More Information (Optional)</h5>
                                                            <div class="extra_infos mt-4" style="color: #333;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" data-group="<?php echo $val['item_group'];?>">
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Card body END -->
                                            </div>
                                        </div>
                                        <?php } else if ($val['module'] == '11') { ?>
                                        <div class="card mb-4 w-100" style="border-radius: 20px; border: 1px solid #e0e0e0;">
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
                                                            <h5 class="card-title mb-3 poppins-semibold">
                                                                <a href="{{ url() }}<?php echo $val['item_id'];?>/<?php echo $val['item_url'];?>/" class="text-dark"><?php echo $val['item'];?></a>
                                                            </h5>
                                                            <div>
                                                                <div class="col-lg-3 d-flex text-right align-items-center fs-14" style="font-size: 12pt;">
                                                                        <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['cart_id'];?>">
                                                                            <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                        </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="d-flex" style="gap:3px;">
                                                            <?php $stats = $reviewStats[$val['item_id']]; ?>
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
                                                        
                                                        <div class="d-flex align-items-center mb-2" style="gap: 20px;">
                                                            <?xml version="1.0" ?>
                                                            <svg height="18" viewBox="0 0 24 24" width="18" xmlns="http://www.w3.org/2000/svg">
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

                                                        <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                            <path d="M8 2h7l5 5v12a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V5a3 3 0 0 1 3-3z" 
                                                                    stroke="rgba(0,0,0,0.5)" 
                                                                    stroke-width="2" 
                                                                    fill="none"/>
                                                            <rect x="8" y="11" width="8" height="6" rx="1.5" 
                                                                    stroke="rgba(0,0,0,0.5)" 
                                                                    stroke-width="2"/>
                                                            </svg>
                                                            
                                                            <div class="col-lg-3">
                                                                <input type="hidden" name="order_date" value="<?php echo $val['tanggal'];?>" />
                                                                <input type="hidden" name="id" value="<?php echo $val['id'];?>" />
                                                                <div class="qty-wrapper">
                                                                    <input
                                                                        data-harga="<?php echo $val['item_price'];?>"
                                                                        name="qty"
                                                                        class="form-control qty"
                                                                        type="number"
                                                                        min="0"
                                                                        value="<?php echo $val['item_qty'];?>"
                                                                    />
                                                                    <input type="hidden" name="cart_id" value="<?php echo $val['cart_id'];?>">
                                                                    <h6 class="qty-label my-auto" style="color: rgba(0, 0, 0, .5);"><?php echo $val['item_unit'];?>(s)</h6>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="row mt-2">
                                                            <div class="col-6">
                                                                <div class="text-end text-dark mt-2">

                                                                    <button id="addExtras" class="btn btn-danger d-none justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" >
                                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                          </svg>  
                                                                        <div>
                                                                            <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                        </div>
                                                                    </button>
                                                                    
                                                                </div>
                                                                <!-- <div class="d-flex" style="gap: 5px;">
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
                                                                            <span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_price']?>" data-hotdeal="<?php echo $val['item_hotdeal_price']?>"> <?php echo number_format($val['item_hotdeal_price'], 0, ',', '.');?></span></span>
                                                                        <?php } else { ?>
                                                                            <span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_price'];?>"></span>
                                                                        <?php } ?>
                                                                        </h6>
                                                                    </div>
                                                                </div> -->
                                                            </div>
                                                            <div class="col-6 mt-2" style="text-align: right;">
                                                                <?php if ($val['item_hotdeal_total'] > 0) { ?>
                                                                        <h5><span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_total']?>" data-hotdeal="<?php echo $val['item_hotdeal_total']?>"> <?php echo number_format($val['item_hotdeal_total'], 0, ',', '.');?></span></h5>
                                                                <?php } else { ?>
                                                                    <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> <?php echo number_format($val['item_total'], 0, ',', '.');?></span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total'];?>"></span></h5>
                                                                <?php } ?>
                                                            </div>
                                                            
                                                        </div>

                                                        <!-- <div class="text-end text-dark mt-2">

                                                            <button id="addExtras" class="btn btn-danger d-flex justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-itemid="<?php echo $val['item_id'];?>" >
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                  </svg>  
                                                                <div>
                                                                    <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                </div>
                                                            </button>
                                                            
                                                        </div> -->
                                                        <div class="mt-2"><hr />
                                                            <h5 class="text-dark" style="font-size: 12pt; text-align: end; margin: auto 0;">More Information (Optional)</h5>
                                                            <div class="extra_infos mt-4" style="color: #333;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" data-group="<?php echo $val['item_group'];?>">
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Card body END -->
                                            </div>
                                        </div>
                                    <?php } else if ($val['module'] == '1' || $val['module'] == '2') { ?>
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
                                                            <h5 class="card-title mb-3 poppins-semibold">
                                                                <a href="{{ url() }}<?php echo $val['item_id'];?>/<?php echo $val['item_url'];?>/" class="text-dark"><?php echo $val['item'];?></a>
                                                            </h5>
                                                            <div>
                                                                <div class="col-lg-3 d-flex text-right align-items-center fs-14" style="font-size: 12pt;">
                                                                    
                                                                        <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['cart_id'];?>">
                                                                            <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                        </a>
                                                                </div>
                                                            </div>
                                                         </div>

                                                         <div class="d-flex" style="gap:3px;">
                                                            <?php $stats = $reviewStats[$val['item_id']]; ?>
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
                                                        
                                                        <div class="d-flex align-items-center mb-2" style="gap: 28px;">
                                                            <?xml version="1.0" ?>
                                                            <svg height="18.5" viewBox="0 0 24 24" width="18.5" xmlns="http://www.w3.org/2000/svg">
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
                                                        <div class="d-flex align-items-center mb-2" style="gap: 26px; margin-left: 2px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="rgba(0,0,0,0.5)" class="bi bi-calendar2-week" viewBox="0 0 16 16">
                                                            <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v11a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1z"/>
                                                            <path d="M2.5 4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5H3a.5.5 0 0 1-.5-.5zM11 7.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-5 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                                                            </svg>
                                                            <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php echo $val['checkin'];?> - <?php echo $val['checkout'];?></h6>
                                                        </div>
    
                                                        <div class="d-flex align-items-center mb-2" style="gap: 9px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="rgba(0,0,0,0.5)" class="bi bi-cloud-moon" viewBox="0 0 16 16">
                                                            <path d="M7 8a3.5 3.5 0 0 1 3.5 3.555.5.5 0 0 0 .625.492A1.503 1.503 0 0 1 13 13.5a1.5 1.5 0 0 1-1.5 1.5H3a2 2 0 1 1 .1-3.998.5.5 0 0 0 .509-.375A3.5 3.5 0 0 1 7 8m4.473 3a4.5 4.5 0 0 0-8.72-.99A3 3 0 0 0 3 16h8.5a2.5 2.5 0 0 0 0-5z"/>
                                                            <path d="M11.286 1.778a.5.5 0 0 0-.565-.755 4.595 4.595 0 0 0-3.18 5.003 5.5 5.5 0 0 1 1.055.209A3.6 3.6 0 0 1 9.83 2.617a4.593 4.593 0 0 0 4.31 5.744 3.58 3.58 0 0 1-2.241.634q.244.477.394 1a4.59 4.59 0 0 0 3.624-2.04.5.5 0 0 0-.565-.755 3.593 3.593 0 0 1-4.065-5.422z"/>
                                                            </svg>
                                                             
                                                              
                                                            <div class="col-lg-3" style="color: rgba(0, 0, 0, .5)">
                                                                <h6 class="my-auto"><?php echo $val['night']; ?> Night<?php echo $val['night'] > 1 ? 's' : ''; ?></h6>
                                                            </div>
                                                            
                                                        </div>

                                                        <div class="d-flex align-items-center mb-2" style="gap: 13px;">
                                                            <?xml version="1.0" ?>
                                                                <svg fill="none" height="23" viewBox="0 0 24 24" width="23" xmlns="http://www.w3.org/2000/svg">
                                                                <path d="M6.75 4H17.25C18.7125 4 19.9084 5.1417 19.995 6.58248L20 6.75L20.0006 10.1037C21.0968 10.414 21.9147 11.3872 21.9937 12.5628L22 12.75V20.25C22 20.6642 21.6642 21 21.25 21C20.8703 21 20.5565 20.7178 20.5068 20.3518L20.5 20.25V18H3.5V20.25C3.5 20.6297 3.21785 20.9435 2.85177 20.9932L2.75 21C2.3703 21 2.05651 20.7178 2.00685 20.3518L2 20.25V12.75C2 11.4911 2.84596 10.4297 4.00044 10.1034L4 6.75C4 5.28747 5.1417 4.0916 6.58248 4.00502L6.75 4ZM19.25 11.5H4.75C4.10279 11.5 3.57047 11.9919 3.50645 12.6222L3.5 12.75V16.5H20.5V12.75C20.5 12.1028 20.0081 11.5705 19.3778 11.5065L19.25 11.5ZM17.25 5.5H6.75C6.10279 5.5 5.57047 5.99187 5.50645 6.62219L5.5 6.75V10H7C7 9.44772 7.44772 9 8 9H10C10.5128 9 10.9355 9.38604 10.9933 9.88338L11 10H13C13 9.44772 13.4477 9 14 9H16C16.5128 9 16.9355 9.38604 16.9933 9.88338L17 10H18.5V6.75C18.5 6.10279 18.0081 5.57047 17.3778 5.50645L17.25 5.5Z" fill="rgba(0,0,0,0.5)"/>
                                                                </svg>

                                                            <div class="col-lg-3" style="color: rgba(0, 0, 0, .5)">
                                                                <div class="qty-wrapper">
                                                                    <input
                                                                        data-harga="<?php echo $val['item_price'];?>"
                                                                        name="qty"
                                                                        class="form-control qty"
                                                                        type="number"
                                                                        min="0"
                                                                        value="<?php echo $val['item_qty'];?>"
                                                                    />
                                                                    <input type="hidden" name="cart_id" value="<?php echo $val['cart_id'];?>">
                                                                    <h6 class="qty-label my-auto" style="color: rgba(0, 0, 0, .5);"><?php echo $val['item_unit'];?>(s)</h6>
                                                                </div>
                                                            </div>
                                                        </div>
                        
                                                        <div class="row mt-4">
                                                            <div class="col-6">
                                                                <!-- <button id="priceBreakdown" data-breakdown='<?php echo json_encode($val["breakdown"]); ?>' data-total="<?php echo $val['item_total'];?>">
                                                                        <div>
                                                                            <svg style="color:rgba(0,0,0,.5);" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                                                                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-info">
                                                                            <circle cx="12" cy="12" r="10"/>
                                                                            <line x1="12" y1="16" x2="12" y2="12"/>
                                                                            <line x1="12" y1="8" x2="12" y2="8"/>
                                                                            </svg>
                                                                            
                                                                
                                                                        </div>
                                                                        <div>
                                                                            <h6 class="text-dark">Price breakdown</h6>
                                                                        </div>
                                                                    </button> -->
                                                                
                                                                    <button id="addExtras" class="btn btn-danger d-none justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" >
                                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                          </svg>  
                                                                        <div>
                                                                            <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                        </div>
                                                                    </button>
                                                            </div>
                                                            <div class="col-6 mt-1" style="text-align: right;">
                                                                <?php if ($val['item_hotdeal_total'] > 0) { ?>
                                                                    <h5><span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_total']?>" data-hotdeal="<?php echo $val['item_hotdeal_total']?>"> <?php echo number_format($val['item_hotdeal_total'], 0, ',', '.');?></span></h5>
                                                                <?php } else { ?>
                                                                    
                                                                    <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total'] ?>"><?php echo number_format($val['item_total'], 0, ',', '.');?></span></h5>
                                                                <?php } ?>
                                                                    <!-- <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total'];?>"></span></h5> -->
                                                            </div>
                                                            
                                                        </div>
    
                                                        <?php /*?><div class="text-end text-dark mt-2">
                                                            <button class="btn btn-sm btn-danger extraform" data-group="<?php echo $val['item_group'];?>" data-id="<?php echo $val['id'];?>">
                                                                Add Extra Info
                                                            </button>
                                                        </div><?php */?>
                                                        <div class="mt-2"><hr />
                                                            <h5 class="text-dark" style="font-size: 12pt; text-align: end; margin: auto 0;">More Information (Optional)</h5>
                                                            <div class="extra_infos mt-4" style="color: #333;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" data-group="<?php echo $val['item_group'];?>">
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Card body END -->
                                            </div>
                                        </div>
                                    <?php  } else if($val['module'] == '9') { ?>
                                        <div class="card mb-4 w-100" style="border-radius: 20px; border: 1px solid #e0e0e0;">
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
                                                            <h5 class="card-title mb-3 poppins-semibold">
                                                                <a href="{{ url() }}<?php echo $val['item_id'];?>/<?php echo $val['item_url'];?>/" class="text-dark"><?php echo $val['item'];?></a>
                                                            </h5>
                                                            <div>
                                                                <div class="col-lg-3 d-flex text-right align-items-center fs-14" style="font-size: 12pt;">
                                                                        <a class="btn btn-sm text-danger removeitem" data-id="<?php echo $val['cart_id'];?>">
                                                                            <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                        </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="d-flex" style="gap:3px;">
                                                            <?php $stats = $reviewStats[$val['item_id']]; ?>
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
                                                        
                                                        <div class="d-flex align-items-center mb-2" style="gap: 20px;">
                                                            <?xml version="1.0" ?>
                                                            <svg height="18" viewBox="0 0 24 24" width="18" xmlns="http://www.w3.org/2000/svg">
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
                                                        <div class="d-flex align-items-center mb-2" style="gap: 23px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="rgba(0,0,0,0.5)" class="bi bi-calendar2-week" viewBox="0 0 16 16">
                                                                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v11a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1z"/>
                                                                <path d="M2.5 4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5H3a.5.5 0 0 1-.5-.5zM11 7.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-5 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                                                            </svg>
                                                            <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php echo $val['start_date'];?> -<?php echo $val['end_date'];?> 
                                                            </h6>
                                                        </div>

                                                        <div class="d-flex align-items-center mb-2" style="gap: 23px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" class="bi bi-clock clock-icon" viewBox="0 0 16 16" fill="rgba(0, 0, 0, 0.5)" stroke="rgba(0, 0, 0, 0.3)" stroke-width="0.5">
                                                                <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71z"/>
                                                                <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0"/>
                                                              </svg>
                                                              
                                                            
                                                            <h6 class="my-auto" style="color: rgba(0, 0, 0, .5)"><?php if($val['days'] > 1) {?>
                                                                <?php echo $val['days']?> days
                                                            <?php } else {?>
                                                                <?php echo $val['days']?> day
                                                            <?php } ?>
                                                            </h6>
                                                        </div>

                        

                                                        <div class="d-flex align-items-center mb-2" style="gap: 5px;">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="rgba(0, 0, 0, 0.5)" class="bi bi-bicycle" viewBox="0 0 16 16">
                                                            <path d="M4 4.5a.5.5 0 0 1 .5-.5H6a.5.5 0 0 1 0 1v.5h4.14l.386-1.158A.5.5 0 0 1 11 4h1a.5.5 0 0 1 0 1h-.64l-.311.935.807 1.29a3 3 0 1 1-.848.53l-.508-.812-2.076 3.322A.5.5 0 0 1 8 10.5H5.959a3 3 0 1 1-1.815-3.274L5 5.856V5h-.5a.5.5 0 0 1-.5-.5m1.5 2.443-.508.814c.5.444.85 1.054.967 1.743h1.139zM8 9.057 9.598 6.5H6.402zM4.937 9.5a2 2 0 0 0-.487-.877l-.548.877zM3.603 8.092A2 2 0 1 0 4.937 10.5H3a.5.5 0 0 1-.424-.765zm7.947.53a2 2 0 1 0 .848-.53l1.026 1.643a.5.5 0 1 1-.848.53z"/>
                                                            </svg>
                                                            
                                                            <div class="col-lg-3">
                                                                <input type="hidden" name="order_date" value="<?php echo $val['tanggal'];?>" />
                                                                <input type="hidden" name="id" value="<?php echo $val['id'];?>" />
                                                                <div class="qty-wrapper">
                                                                    <input
                                                                        data-harga="<?php echo $val['item_price'];?>"
                                                                        name="qty"
                                                                        class="form-control qty"
                                                                        type="number"
                                                                        min="0"
                                                                        value="<?php echo $val['item_qty'];?>"
                                                                    />
                                                                    <input type="hidden" name="cart_id" value="<?php echo $val['cart_id'];?>">
                                                                    <h6 class="qty-label my-auto" style="color: rgba(0, 0, 0, .5);"><?php echo $val['item_unit'];?>(s)</h6>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="row mt-2">
                                                            <div class="col-6">
                                                                <div class="text-end text-dark mt-2">

                                                                    <button id="addExtras" class="btn btn-danger d-none justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" >
                                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                          </svg>  
                                                                        <div>
                                                                            <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                        </div>
                                                                    </button>
                                                                    
                                                                </div>
                                                                <!-- <div class="d-flex" style="gap: 5px;">
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
                                                                            <span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_price']?>" data-hotdeal="<?php echo $val['item_hotdeal_price']?>"> <?php echo number_format($val['item_hotdeal_price'], 0, ',', '.');?></span></span>
                                                                        <?php } else { ?>
                                                                            <span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_price'];?>"></span>
                                                                        <?php } ?>
                                                                        </h6>
                                                                    </div>
                                                                </div> -->
                                                            </div>
                                                            <div class="col-6 mt-2" style="text-align: right;">
                                                                <?php if ($val['item_hotdeal_total'] > 0) { ?>
                                                                        <h5><span class="activecurrency" style="color: rgba(0, 0, 0, .5)"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" style="color: rgba(0, 0, 0, .5)" data-baseprice="<?php echo $val['item_hotdeal_total']?>" data-hotdeal="<?php echo $val['item_hotdeal_total']?>"> <?php echo number_format($val['item_hotdeal_total'], 0, ',', '.');?></span></h5>
                                                                <?php } else { ?>
                                                                    <h5 style="color: rgba(0, 0, 0, .5)"><span class="activecurrency"><?php echo $this->session->get('currency')['converted'];?> </span><span class="valuecurrency" data-baseprice="<?php echo $val['item_total'];?>"></span></h5>
                                                                <?php } ?>
                                                            </div>
                                                            
                                                        </div>

                                                        <!-- <div class="text-end text-dark mt-2">

                                                            <button id="addExtras" class="btn btn-danger d-flex justify-content-center align-items-center addExtras" style="gap: 8px; border-radius: 50px;"  data-id="<?php echo $val['id'];?>" data-itemid="<?php echo $val['item_id'];?>" >
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="white" class="bi bi-plus-circle" viewBox="0 0 16 16">
                                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                                                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                                                  </svg>  
                                                                <div>
                                                                    <h6 class="text-light m-0" style="font-size:13px;">Add-on</h6>
                                                                </div>
                                                            </button>
                                                            
                                                        </div> -->
                                                        <div class="mt-2"><hr />
                                                            <h5 class="text-dark" style="font-size: 12pt; text-align: end; margin: auto 0;">More Information (Optional)</h5>
                                                            <div class="extra_infos mt-4" style="color: #333;"  data-id="<?php echo $val['id'];?>" data-cartid="<?php echo $val['cart_id'];?>" data-group="<?php echo $val['item_group'];?>">
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Card body END -->
                                            </div>
                                        </div>
                                    <?php } ?>
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

                                <!-- Traveler Information -->
                                 <?php if(!$this->session->get('trop_auth')): ?>
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
                                                <div class="col-md-12">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control border-5" name="cust_name" placeholder="Your Name">
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
                                                            <option value="">Select Country</option>
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
                                    <p style="color: #333;" class="text-center">Or</p>
                                    <a href="{{ url('account/logingoogle') }}"
                                    class="btn w-25 mb-5 d-flex align-items-center justify-content-center"
                                    style="
                                        max-width: 300px;
                                        margin-left: auto;
                                        margin-right: auto;
                                        background-color: white;
                                        border: 1px solid #ddd;
                                        border-radius: 30px;
                                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                                        padding: 10px 15px;
                                        transition: box-shadow 0.3s ease;
                                    ">
                                    <img src="{{ url() }}img/google.png" style="width: 20px; margin-right: 10px;" alt="">
                                    <small style="color: #333;">Sign In with Google</small>
                                    </a>
                                    <!-- Booking detail END -->
                                </div>
                                <?php elseif($this->session->get('trop_auth') && $this->session->get('trop_auth')['customer_id'] == 'google'): ?>
                                <div class="vstack gap-4 mt-5">
                                    <h4 class="mb-3" style="color: rgb(0, 0, 0)">Traveler Information</h4>
                                    <hr class="my-0"> <!-- Divider -->

                                    <!-- Booking detail START -->
                                    <div class="card border mt-3 mb-5" style="border-radius: 15px;">
                                        <div class="card-header border-bottom">
                                            <h5 class="mb-0" style="color: rgb(0, 0, 0)">Your booking detail will be sent here</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row g-4">
                                                <!-- hidden input -->
                                                 <input type="hidden" name="cust_name" value="<?php echo $this->session->get('trop_auth')['customer_name'] ?>">
                                                 <input type="hidden" name="email" value="<?php echo $this->session->get('trop_auth')['customer_email'] ?>">
                                                <!-- Mobile number -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Mobile Number <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="phone_number" id="phone_number" placeholder="Your Phone Number" />
                                                        <span id="phone_text"></span>
                                                    </div>
                                                </div>

                                                <!-- country -->
                                                <div class="col-md-6">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">Country <span class="text-danger">*</span></label>
                                                        <select class="form-control border-5" name="country" id="country">
                                                            <option value="">Select Country</option>
                                                            {% for c in countries %}
                                                                <option value="{{ c.iso2 }}">{{ c.short_name }}</option>
                                                            {% endfor %}
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Booking detail END -->
                                </div>
                                <?php else: ?>
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
                                                <div class="col-md-12">
                                                    <div class="form-control-bg-light">
                                                        <label class="form-label" style="color: rgba(0, 0, 0, .5)">name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control border-5" name="cust_name" placeholder="Your Name">
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
                                                            <option value="">Select Country</option>
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
                                <?php endif; ?>
                            </div>
                            <input type="hidden" id="data_total" name="total" class="form-control" value="<?php echo $total?>">
                        </form>
                    </div>

                    <!-- Right sidebar START -->
                    <aside class="col-xl-4">
                        <div class="vstack gap-4 mb-5">
                            <!-- Price summary START -->
                            <div class="card border" style="border-radius: 20px;">
                                <!-- Card body -->
                                <?php //print_r($this->session->get('cart'));?>
                                <div class="card-body px-4">
                                    <ul class="list-group">
                                        <li class="d-flex justify-content-between align-items-center pt-0">
                                            <h5 class="poppins-semibold mb-0 pt-3 mb-4 text-dark">SubTotal (<?php echo count($this->session->get('cart'));?> Item)</h5>
                                        </li>
                            
                                        <li class="d-flex justify-content-between align-items-center pt-0 my-4 pb-4">
                                            <h5 class="poppins-semibold text-dark">Total</h5>
                                            <h5 class="fs-5"><span class="h5 mb-0 text-dark poppins-semibold"><span>IDR <?php echo number_format($total, 0, ',', '.');?></span></span></h5>
                                        </li>


                                        <h6 id="discount" style="margin-bottom: -2rem; margin-top: -2rem;"></h6>

                                        <?php
                                            $hasAddons = false;
                                            foreach ($this->session->get('cart') as $item) {
                                                if (!empty($item['addons'])) {
                                                $hasAddons = true;
                                                break;
                                                }
                                            }
                                        ?>
                                        <?php if ($hasAddons): ?>
                                            <?php
                                            // Hitung total addon lebih awal
                                            $addonTotal = 0;
                                            foreach ($this->session->get('cart') as $item) {
                                                $addons = $item['addons'] ?? [];
                                                if (!empty($addons)) {
                                                    foreach ($addons as $addon) {
                                                        $lineTotal = $addon['harga'] * $addon['qty'];
                                                        $addonTotal += $lineTotal;
                                                        $total += $lineTotal;
                                                    }
                                                }
                                            }
                                        ?>

                                        <hr style="color: black; width:95%;">
                                        <li class="d-flex justify-content-between align-items-center pt-0">
                                            <h5 class="poppins-semibold text-dark">Add-ons</h5>
                                            <h5 class="fs-5"><span class="h5 mb-0 text-dark poppins-semibold"><span>IDR <?php echo number_format($addonTotal, 0, ',', '.'); ?></span></span></h5>
                                        </li>

                                        <!-- Add-on Total (sudah bisa ditampilkan karena sudah dihitung di atas) -->
                                        <!-- <li class="d-flex justify-content-between align-items-center mt-4" style="list-style: none;">
                                            <strong><span class="mb-0" style="font-size: 16px;">Total Add-ons</span></strong>
                                            <h5 class="mb-0">IDR <?php echo number_format($addonTotal, 0, ',', '.'); ?></h5>
                                        </li> -->

                                        <!-- Sekarang render lagi untuk tampilkan detilnya -->
                                        <?php foreach ($this->session->get('cart') as $item): ?>
                                            <?php $addons = $item['addons'] ?? []; ?>
                                            <?php if (!empty($addons)): ?>
                                                <li class="d-flex justify-content-between align-items-center pt-3">
                                                    <div>
                                                        <span class="poppins-semibold mb-0"><?php echo $item['item']; ?></span>
                                                    </div>
                                                    <?php foreach ($addons as $addon): ?>
                                                        <?php $lineTotal = $addon['harga'] * $addon['qty']; ?>
                                                        <li class="d-flex justify-content-between">
                                                            <span class="poppins-medium"><?php echo $addon['qty']; ?> × <?php echo $addon['name']; ?></span>
                                                            <div>
                                                                <span class="poppins-medium">IDR <?php echo number_format($lineTotal, 0, ',', '.'); ?></span>
                                                                <a href="javascript:void(0)" onclick="hapusAddon('<?php echo $item['item_id']; ?>', '<?php echo addslashes($addon['name']); ?>')" style="margin-left: 10px; color: red; font-weight: bold;" id="deleteaddon" data-addon-name="<?php echo $addon['name']; ?>" data-addon-id="<?php echo $addon['id']; ?>">
                                                                    <i class="fa fa-trash-o" style="font-size:20px;"></i>
                                                                </a>
                                                            </div>
                                                        </li>
                                                    <?php endforeach; ?>
                                                </li>
                                            <?php endif; ?>
                                        <?php endforeach; ?>


                                    <?php endif; ?>
                    
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
                                    <hr style="color: black;width:95%">
                                </div>
                                    <li class="d-flex justify-content-between align-items-center mb-4">
                                        <h5 class="poppins-semibold text-dark mb-0 ml-4">Grand Total</h5>
                                        <h5 class="mb-0" id="grandTotal" style="margin-right: 18px;">
                                            <span class="activecurrency poppins-semibold">
                                                <?php echo $this->session->get('currency')['converted']; ?>
                                            </span>
                                            <span class="valuecurrency poppins-semibold" data-baseprice="<?php echo $total; ?>">
                                                <?php echo number_format($total, 0, ',', '.'); ?>
                                            </span>
                                        </h5>
                                    </li>
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