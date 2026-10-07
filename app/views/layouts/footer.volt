
<!-- Footer -->
<div class="g-bg-black-opacity-0_9 g-color-black-opacity-0_8 g-pt-60 g-pb-10" style="background : #ECECEC !important">
  <div class="container">
    <div class="row">
      <!-- Footer Content -->
      <div class="col-lg-3 col-md-6 g-mb-40 g-mb-0--lg">
        <a class="d-block g-mb-20" href="{{ url() }}">
          <img class="img-fluid w-75" src="{{ url() }}img/logo.png" alt="Logo">
        </a>
        <p class="g-color-black">Tropialis is evolving into a one-stop travel platform that allows users to book, explore, and experience Bali and beyond. As a web-based marketplace, it connects travelers with various services, making trip planning seamless and hassle-free.</p>
        <p class="g-color-black">We specialize in personalized itineraries, unique destinations, and sustainable travel practices.</p>
      
        <?php /*?><ul class="list-inline g-overflow-hidden g-pt-1 g-mx-minus-4 mb-0">
          <li class="list-inline-item">
            <a id="currency-dropdown-invoker-2" class="g-color-brown g-font-weight-400 g-text-underline--none--hover tropialis-text-hover" 
                aria-controls="currency-dropdown-2"
                aria-haspopup="true"
                aria-expanded="false"
                data-dropdown-event="hover"
                data-dropdown-target="#currency-dropdown-2"
                data-dropdown-type="css-animation"
                data-dropdown-duration="300"
                data-dropdown-hide-on-scroll="false"
                data-dropdown-animation-in="fadeIn"
                data-dropdown-animation-out="fadeOut">
              
                <div class="currency-selector mt-3">
                  <button class="currency-btn">
                      <img class="activeflag" src="https://flagcdn.com/w40/id.png" alt="IDR"> 
                      <span class="activecurrency">IDR</span>&nbsp;&nbsp;&nbsp;<span class="activecurrencytext">- Indonesian Rupiah</span>
                      <i class="fa fa-chevron-down"></i>
                  </button>
              </div>       
                
            </a>
            <ul id="currency-dropdown-2" class="list-unstyled u-shadow-v29 g-pos-abs g-left-0 g-bg-white g-width-300 g-pb-5 g-mt-19 g-z-index-2" aria-labelledby="currency-dropdown-invoker-2">
              {% for curr in currencies %}
              <li class="changecurrency" data-curr="{{ curr.iso3 }}" data-currtext="{{ curr.currency }}" data-curricon="{{ curr.icon }}" data-flag="{{curr.flag}}">
                <a style="cursor:pointer" class="d-block g-color-black g-color-primary--hover g-text-underline--none--hover g-font-weight-400 g-py-5 g-px-20">
                  <span style="font-weight: bold; float:right">{{ curr.symbol }}</span>
                  {{ curr.currency }}
                </a>
              </li>
              {% endfor %}
            </ul>
          </li><?php */?>
          <?php /*?><li class="list-inline-item g-color-white g-mx-4">|</li>
          <li class="list-inline-item g-mx-4">
            <a class="g-color-white tropialis-text-hover g-font-weight-400 g-text-underline--none--hover" href="page-help-1.html">Help</a>
          </li><?php */?>
        </ul>

      </div>
      <!-- End Footer Content -->

      <!-- Footer Content -->
      <div class="col-lg-3 col-md-6 g-mb-40 g-mb-0--lg">
        <div class="u-heading-v3-1 g-brd-white-opacity-0_3 g-mb-25 d-flex justify-content-center">
          <h2 class="u-heading-v3__title h6 g-font-weight-600 text-uppercase g-brd-primary"><a target="_blank" class="text-dark" target="_blank" href="{{ config.vars.artUrl }}/">Tropialis' Lifestyle</a></h2>
        </div>

        {% for art in articles|slice(0, 2) %}
        <article>
            <div class="g-pos-rel d-flex align-items-center" style="padding: 5px 15px;">
              <i class="fa fa-angle-right" style="margin-right: 15px;"></i>
              <h3 class="h6 g-mb-2">
                <a class="g-color-black-opacity-0_8 g-color-white--hover" href="{{ config.vars.artUrl }}/{{ art.id }}/{{ art.article_slug }}/" target="_blank">{{ art.article_title }}</a>
                <div class="small g-color-black-opacity-0_6">{{ art.publish_date }}</div>
              </h3>
            </div>
        </article>
        <hr class="g-brd-white-opacity-0_1 g-my-10">
        {% endfor %}
      </div>
      <!-- End Footer Content -->

      <!-- Footer Content -->
      <div class="col-lg-3 col-md-6 g-mb-40 g-mb-0--lg">
        <div class="u-heading-v3-1 g-brd-white-opacity-0_3 g-mb-25 d-flex justify-content-center">
          <h2 class="u-heading-v3__title h6 text-uppercase g-brd-primary g-font-weight-600">Tropialis</h2>
        </div>

        <nav class="text-uppercase1">
          <ul class="list-unstyled g-mt-minus-10 mb-0">
            <li class="g-pos-rel g-py-10 d-flex align-items-center" style="padding: 10px 15px;">
              <h4 class="h6 g-pr-20 mb-0">
                  <i class="fa fa-angle-right" style="margin-right: 10px;"></i>
                  <a class="g-color-black-opacity-0_8 g-color-white--hover" href="{{ url() }}page/about-us/">About Us</a>
                </h4>
            </li>
            <li class="g-pos-rel g-py-10 d-flex align-items-center" style="padding: 10px 15px;">
              <h4 class="h6 g-pr-20 mb-0">
                  <i class="fa fa-angle-right" style="margin-right: 10px;"></i>
                  <a class="g-color-black-opacity-0_8 g-color-white--hover" href="{{ url() }}page/faq/">FAQ</a>
              </h4>
            </li>
            <li class="g-pos-rel g-py-10 d-flex align-items-center" style="padding: 10px 15px;">
              <h4 class="h6 g-pr-20 mb-0">
                  <i class="fa fa-angle-right" style="margin-right: 10px;"></i>
                  <a class="g-color-black-opacity-0_8 g-color-white--hover" target="_blank" href="{{ url() }}sitemap.xml">Sitemap</a>
              </h4>
            </li>
          </ul>
        </nav>
      </div>
      <!-- End Footer Content -->

      <!-- Footer Content -->
      <div class="col-lg-3 col-md-6">
        <div class="u-heading-v3-1 g-brd-white-opacity-0_3 g-mb-25 d-flex justify-content-center">
          <h2 class="u-heading-v3__title h6 text-uppercase g-brd-primary g-font-weight-600">Our Contacts</h2>
        </div>

        <address class="g-bg-no-repeat g-line-height-2 g-mt-minus-4" style="background-image: url(../../assets/img/maps/map2.png);">
          <ul class="list-unstyled g-mt-minus-10 mb-0">
            <li class="g-pos-rel d-flex align-items-center" style="padding: 5px;">
              <h4 class="h6 g-pr-20 mb-0 d-flex align-items-center">
                  <i class="fa fa-angle-right" style="margin-right: 15px;"></i>
                  <p>Jl. Srikandi No. 50 Nusa Dua, 
                    Kelurahan Benoa, Kec. Kuta Selatan, Badung, Bali</p>
                </h4>
            </li>
            <li class="g-pos-rel d-flex align-items-center" style="padding: 5px;">
              <h4 class="h6 g-pr-20 mb-0 d-flex align-items-center">
                  <i class="fa fa-angle-right" style="margin-right: 15px;"></i>
                  <p>Phone: +62-881-0373-36399</p>
                </h4>
            </li>
            <li class="g-pos-rel d-flex align-items-center" style="padding: 5px;">
              <h4 class="h6 g-pr-20 mb-0 d-flex align-items-center">
                  <i class="fa fa-angle-right" style="margin-right: 15px;"></i>
                  <p>Email: tropialisexoticparadise@gmail.com</p>
                </h4>
            </li>
          </ul>
        </address>
      </div>
      <!-- End Footer Content -->
    </div>
    <!-- payment methods -->
  <div class="d-flex justify-content-center">
    <h2 class="u-heading-v3__title h6 text-uppercase g-brd-primary g-font-weight-600">Available Payment Methods</h2>
  </div>
  <div class="my-4" style="display: flex; gap: 12px; align-items: center; justify-content: center; flex-wrap: wrap;">
      <img src="{{ url() }}img/logo-visa.png" alt="Visa" height="30" style="padding: 0 5px; background: #fff; border-radius: 5px;">
      <img src="{{ url() }}img/logo-jcb.png" alt="jcb" height="30" style="padding: 0 10px; background: #fff; border-radius: 5px;">
      <img src="{{ url() }}img/logo-mastercard.png" alt="Mastercard" height="30" style="padding: 3px 5px; background: #fff; border-radius: 5px;">
    </div>
    
    <div style="display: flex; gap: 12px; align-items: center; justify-content: center; flex-wrap: wrap;">
      <img src="{{ url() }}img/logo-bni.jpg" alt="Bank BNI" height="30" style="padding: 0 5px; background: #fff; border-radius: 5px;">
      <img src="{{ url() }}img/logo-bri.jpg" alt="Bank BRI" height="30" style="border-radius: 5px;">
      <img src="{{ url() }}img/logo-doku.png" alt="DOKU" height="30" style="background: #fff; padding: 3px 10px; border-radius: 5px;">
      <img src="{{ url() }}img/logo-bsi.png" alt="Bank BSI" height="30" style="background: #fff; padding: 0 5px; border-radius: 5px;">
      <img src="{{ url() }}img/logo-cimb1.jpg" alt="CIMB Niaga" height="30" style="border-radius: 5px; background: #fff; padding: 0 5px;">
      <img src="{{ url() }}img/logo-danamon.jpg" alt="Bank Danamon" height="30" style="border-radius: 5px; background: #fff; padding: 0 5px;">
      <img src="{{ url() }}img/logo-permata.png" alt="Permata Bank" height="30" style="background: #fff; border-radius: 5px;" class="px-3 py-1">
    </div>

    
  </div>
  <div class="d-flex justify-content-center mt-5">
    <div class="d-inline-block w-75 g-height-1" style="background-color: rgba(225, 225, 225, .8);"></div>
  </div>
  <div class="container">
    <div class="mt-5">
      <p style="text-align:center !important">Tropialis come with expert local guides, seamless travel planning, and exceptional customer service, Tropialis ensures every journey is tailored to your interests and preferences. Whether you're seeking adventure, cultural immersion, or relaxation, Tropialis is your trusted partner for exploring the world with ease and comfort.</p>
      <p class="mt-1" style="font-size: 15pt; text-align:center !important">Choose Tropialis for a travel experience that is safe, enriching, and truly memorable.</p>
      <p class="mt-1">Experience ultimate relaxation with Tropialis' mobile massage service across Bali, including areas like Canggu, Ubud, Jimbaran, Nusa Dua, Ungasan, Tabanan, Gianyar, Seminyak, Legian, Umalas, and Labuan Sait. Our professional therapists bring the luxury of spa treatments directly to your villa or hotel, ensuring a rejuvenating experience in the comfort of your own space.</p>
      <div class="row mt-1">
        <div class="col-12 col-lg-4">
          <h6>Book Accommodation</h6>
          <p>Find and book hotels, resorts, villas, and guesthouses. Compare prices, check reviews, and secure stays instantly.</p>
          <h6>Discover &amp; Book Tours &amp; Travel</h6>
          <p>Browse curated tours: island-hopping, cultural excursions, adventure tours. Book private drivers, airport transfers, and car rentals for convenience.</p>
          <h6>Explore &amp; Do Activities</h6>
          <p>Reserve experiences like ATV rides, snorkeling, scuba diving, and trekking. Find cultural and nature-based tours, including rice field walks and temple visits.</p>
        </div>
        <div class="col-12 col-lg-4">
          <h6>Wellness &amp; Spa Services</h6>
          <p>Book massages, beauty treatments, and wellness retreats. Access mobile spa services at your villa or hotel.</p>
          <h6>Buy Attraction &amp; Event Tickets</h6>
          <p>Skip the queues by purchasing tickets for theme parks, water parks, museums, and performances. Get access to exclusive discounts and fast-track entries.</p>
          <h6>Join Classes &amp; Workshops</h6>
          <p>Learn local skills with Balinese cooking classes, traditional dance lessons, and yoga retreats. Participate in craft-making workshops, such as batik painting and wood carving.</p>
        </div>
        <div class="col-12 col-lg-4">
          <h6>Secure &amp; Easy Booking</h6>
          <p>Instant booking confirmation with secure payment options. Manage bookings, receive updates, and get customer support via the platform.</p>
          <h6>Partner &amp; Vendor Hub</h6>
          <p>Allows local businesses, tour operators, and service providers to list their offerings. Access marketing tools, analytics, and payment integration to grow their business.</p>
          <h6>Personalized Travel Recommendations</h6>
          <p>AI-driven suggestions based on interests, location, and travel history. Tailored itineraries for solo travelers, families, or adventure seekers.</p>
        </div>
      </div>
      <h2 class="text-center mt-3">Bali’s Ultimate Guide to Where to Stay, <br />What to Do &amp; How to Unwind</h2>
      <p class="text-center mt-3">With Tropialis, users can book everything they need in one place, making travel simpler, smarter, and more enjoyable. 🚀🌍</p>
    </div>
   <div class="d-flex justify-content-center mt-2">
    <div class="d-inline-block w-100 g-height-1" style="background-color: rgba(225, 225, 225, .8);"></div>
  </div> 
    <div class="row">
      <div class="col-md-12 mx-auto text-md-left mt-3">
        <div class="d-lg-flex justify-content-center">
          <small class="d-block g-font-size-default g-mr-10 g-mb-0--md text-center">2024 © Tropialis - All Rights Reserved.</small>
          <!-- <ul class="u-list-inline">
            <li class="list-inline-item my-auto">
              <a target="_blank" href="https://wa.me/message/432QDHIGU2BPE1" class="btn btn-success"><i class="fa fa-whatsapp"></i> Book via Whatsapp</a>
            </li>
          </ul> -->
        </div>
      </div>
    
      <div class="col-md-4 align-self-center">
        <?php /*?><ul class="list-inline text-center text-md-right mb-0">
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Facebook">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-facebook"></i>
            </a>
          </li>
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Skype">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-skype"></i>
            </a>
          </li>
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Linkedin">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-linkedin"></i>
            </a>
          </li>
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Pinterest">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-pinterest"></i>
            </a>
          </li>
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Twitter">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-twitter"></i>
            </a>
          </li>
          <li class="list-inline-item g-mx-10" data-toggle="tooltip" data-placement="top" title="Dribbble">
            <a href="#!" class="g-color-white-opacity-0_5 g-color-white--hover">
              <i class="fa fa-dribbble"></i>
            </a>
          </li>
        </ul><?php */?>
      </div>
    </div>
  </div>
</div>
<!-- End Footer -->
<footer id="cookieNotice" class="sticky-bottom g-bg-gray-dark-v1 g-color-black-opacity-0_8 g-py-10" style="background: lightgray !important;">
  <div class="container">
    <div class="cookie d-flex align-iitems-center justify-content-center  " style="gap: 10px;">
      <span>We use cookies to ensure you get the best experience on our website. Read our <a target="_blank" href="{{ url() }}page/cookies-policy/" style="color: #4B944D;cursor:pointer;">Cookie Policy</a> for details.
        <button id="acceptCookies">Got It</button>
      </span>
    </div>
  </div>
</footer>
<!-- End Copyright Footer -->

<a class="js-go-to u-go-to-v1" href="#!" data-type="fixed" data-position='{
 "bottom": 63,
 "right": 15
}' data-offset-top="400" data-compensation="#js-header" data-show-effect="zoomIn">
  <i class="hs-icon hs-icon-arrow-top"></i>
</a>