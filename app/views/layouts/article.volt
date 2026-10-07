<section class="container py-5">
  <div class="mb-4">
    <h2 class="poppins-semibold" style="color: #000;">Latest Article</h2>
  </div>

  <div class="row">
  {% for group in articleGroups %}
    <div class="article-column bg-light col-sm-12 col-md-6 col-lg-4 py-4">
      {% for a in group %}
        <div class="col" style="margin-bottom: 10px;">
          <article class="row d-flex align-items-center justify-content-center" style="gap: 0;">
            <div class="col-4">
              <div class="article-wrapper">
                <img src="{{ config.vars.picUrl }}/articles/{{ a.picture }}" alt="{{ a.article_title }}">
                <div class="overlay">
                  <div>
                    <span class="overlay-text">Read More</span><br>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-right-short arrow-icon" viewBox="0 0 16 16">
                      <path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8"/>
                    </svg>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-8">
              <div class="article-content">
                <figcaption class="">{{ a.article_category }}</figcaption>
                <span class="poppins-semibold" style="font-size: 16px; color: #000;">
                  <a target="_blank" class="article-title" href="{{ config.vars.artUrl }}/{{ a.id }}/{{ a.article_slug }}/">{{ a.article_title }}</a>
                </span>            
              </div>
            </div>
          </article>
        </div>
      {% endfor %}
    </div>
  {% endfor %}
</div>

  
</section>
