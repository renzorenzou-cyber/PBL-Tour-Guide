<section class="container g-pt-50">
  <div class="mb-5">
    <h2 class="h3 g-color-black mb-0">{{ article.article_title }}</h2>
    <div class="d-inline-block g-height-1 g-bg-black">{{ article.publish_date }} / <a class="text-primary" href="{{ lifestyle }}/">Articles</a></div>
  </div>

    <!-- Product Description -->
    <div class="container">
    <div class="row">
        <div class="col-lg-12">
            <figure class="col-lg-6 col-md-6 col-sm-12"><img class="img-fluid w-100" src="{{ pixurl }}/articles/{{ article.picture }}" alt="{{ article.article_title }}"></figure>
            <div class="g-mt-30 g-mb-30">
                {{ article.article_text }}
            </div>
        </div>
    </div>
    </div>
    <!-- End Product Description -->
</section>