<section class="container g-pt-50">
      <div class="mb-5">
        <h2 class="h3 g-color-black mb-0">Tropialis' Lifestyle</h2>
        <div class="d-inline-block g-width-50 g-height-1 g-bg-black"></div>
      </div>

      <div class="row g-mb-50">
      {% for a in articles %}
        <div class="col-sm-6 col-md-4 g-mb-30">
          <!-- Article -->
          <article class="u-shadow-v11 g-pos-rel g-brd-bottom g-brd-3 g-brd-gray-light-v4 g-brd-primary--hover text-center rounded g-transition-0_3 g-transition--linear">
            <!-- Article Image -->
            <figure>
              <img class="w-100" src="{{ pixurl }}/articles/{{ a.picture }}" alt="{{ a.article_title }}">
              <figcaption class="u-ribbon-v1 g-color-white g-bg-blue-opacity-0_7 g-font-weight-600 g-font-size-11 text-uppercase g-top-10 g-left-10 g-rounded-50 g-px-15">{{ a.article_category }}</figcaption>
            </figure>
            <!-- End Article Image -->

            <!-- Article Content -->
            <div class="g-py-30 g-px-20">
              <h3 class="h4 g-color-black">
                  <a class="g-color-black g-color-primary--hover g-text-underline--none--hover" href="{{ lifestyle }}/{{ a.id }}/{{ a.article_slug }}/">{{ a.article_title }}</a>
                </h3>
              <div class="js-rating g-color-primary g-font-size-20">{{ a.publish_date }}</div>
            </div>
            <!-- End Article Content -->
          </article>
          <!-- End Article -->
        </div>
        {% endfor %}
      </div>

      <div class="pagination">
        <ul>
          <li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
              <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
            </svg>        
            <span>Prev</span>
          </li>
          <li class="numb active"><span>1</span></li>
          <li class="numb"><span>2</span></li>
          <li class="dots"><span>...</span></li>
          <li class="numb"><span>4</span></li>
          <li class="numb"><span>5</span></li>
          <li class="dots"><span>...</span></li>
          <li class="numb"><span>7</span></li>
          <li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto">
            <span>Next</span>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-right" viewBox="0 0 16 16">
              <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
            </svg>
          </li>
        </ul>
      </div>
      
</section>
    
<script>
  const element = document.querySelector(".pagination ul");
  let totalPages = 20;
  let page = 10;
  element.innerHTML = createPagination(totalPages, page);
  function createPagination(totalPages, page){
    let liTag = '';
    let active;
    let beforePage = page - 1;
    let afterPage = page + 1;
    if(page > 1){ 
      liTag += `<li class="btn prev d-flex justify-content-center align-items-center gap-5 my-auto py-auto" onclick="createPagination(totalPages, ${page - 1})">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-left" viewBox="0 0 16 16">
          <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
        </svg>        
        <span>Prev</span>
      </li>`;
    }
    if(page > 2){ 
      liTag += `<li class="first numb" onclick="createPagination(totalPages, 1)"><span>1</span></li>`;
      if(page > 3){
        liTag += `<li class="dots"><span>...</span></li>`;
      }
    }
    if (page == totalPages) {
      beforePage = beforePage - 2;
    } else if (page == totalPages - 1) {
      beforePage = beforePage - 1;
    }
    if (page == 1) {
      afterPage = afterPage + 2;
    } else if (page == 2) {
      afterPage  = afterPage + 1;
    }
    for (var plength = beforePage; plength <= afterPage; plength++) {
      if (plength > totalPages) { 
        continue;
      }
      if (plength == 0) { 
        plength = plength + 1;
      }
      if(page == plength){ 
        active = "active";
      }else{ 
        active = "";
      }
      liTag += `<li class="numb ${active}" onclick="createPagination(totalPages, ${plength})"><span>${plength}</span></li>`;
    }
    if(page < totalPages - 1){ 
      if(page < totalPages - 2){
        liTag += `<li class="dots"><span>...</span></li>`;
      }
      liTag += `<li class="last numb" onclick="createPagination(totalPages, ${totalPages})"><span>${totalPages}</span></li>`;
    }
    if (page < totalPages) { 
      liTag += `<li class="btn next d-flex justify-content-center align-items-center gap-5 my-auto py-auto" onclick="createPagination(totalPages, ${page + 1})">
        <span>Next</span>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" stroke="currentColor" stroke-width="1.5" class="bi bi-chevron-right" viewBox="0 0 16 16">
          <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
        </svg>
      </li>`;
    }
    element.innerHTML = liTag;
    return liTag; 
  }
</script>