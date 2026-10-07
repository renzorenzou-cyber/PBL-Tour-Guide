<section class="container g-pt-50">
  <div class="mb-4">
    <h2 class="poppins-semibold" style="color: #000;">Most Popular Activities</h2>
  </div>

  <div class="row vh-100 mb-5 pb-4" style="row-gap: 20px;">
    {% if pack is empty %}
    <div class="d-flex justify-content-center mb-3">
          <img src="{{ url() }}img/no-data2.png" style="width: 40%;">
    </div>
    <!-- <div class="d-flex justify-content-center mx-auto">
      <button class="custom-btn poppins-medium shadow">See products in other areas</button>
    </div> -->
    {% else %}
      {% for p in pack %}
          {{ partial('partials/_productCard') }}
      {% endfor %}
    {% endif %}

  </div>
</section>