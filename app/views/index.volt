<!DOCTYPE html>
<html lang="en">
{% include "layouts/meta.volt" %}
<body>
  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PNQ3X972"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
  <main>
    {% include "layouts/header.volt" %}
    {{ content() }}
    <!-- Copyright Footer -->
    {% include "layouts/footer.volt" %}
  </main>

  <div class="u-outer-spaces-helper"></div>

  {{ assets.outputJs('footer') }}
  
</body>

</html>
