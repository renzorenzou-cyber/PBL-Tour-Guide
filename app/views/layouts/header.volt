<!-- Bootstrap Icons CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<header id="js-header" class="u-header u-header--static">
  {% include "layouts/top.volt" %}

    <nav class="navbar">
      <!-- Hamburger Menu -->
      <div class="hamburger" id="hamburger">
        <span></span>
        <span></span>
        <span></span>
      </div>

      <!-- Desktop Navigation -->
      <div class="container">
        {# Hitung jumlah menu utama #}
{% set total_main_menu = 0 %}
{% for m in menu %}
  {% if m.group_product_parent == 0 %}
    {% set total_main_menu = total_main_menu + 1 %}
  {% endif %}
{% endfor %}

<ul class="nav-links">
  {# Tampilkan 5 menu utama pertama #}
  {% set count = 0 %}
  {% for m in menu %}
    {% if m.group_product_parent == 0 and count < 5 %}
      {% if m.is_child == 1 %}
        <li class="nav-item hs-has-sub-menu_2">
          <div class="d-flex align-items-center">
            <a class="nav-link" href="#">{{ m.group_product }}</a>
            <span class="chevron"><i class="bi bi-chevron-down"></i></span>
          </div>
          <ul class="hs-sub-menu_2">
            {% for sm in submenu %}
              {% if sm.group_product_parent == m.id %}
                <li><a class="nav-link" href="{{ url() }}category/{{ sm.group_product_url }}/">{{ sm.group_product }}</a></li>
              {% endif %}
            {% endfor %}
          </ul>
        </li>
      {% else %}
        <li class="nav-item">
          <a class="nav-link text-center" href="{{ url() }}category/{{ m.group_product_url }}/">{{ m.group_product }}</a>
        </li>
      {% endif %}
      {% set count = count + 1 %}
    {% endif %}
  {% endfor %}

  {# Tampilkan More Categories jika ada lebih dari 5 #}
  {% if total_main_menu > 5 %}
    <li class="nav-item hs-has-sub-menu_2">
      <div class="d-flex align-items-center">
        <a class="nav-link text-center" href="#">More Categories</a>
        <span class="chevron"><i class="bi bi-chevron-down"></i></span>
      </div>
      <ul class="hs-sub-menu_2">
        {% set count = 0 %}
        {% for m in menu %}
          {% if m.group_product_parent == 0 %}
            {% if count >= 5 %}
              {% if m.is_child == 1 %}
                <li class="hs-has-sub-menu_2">
                  <div class="d-flex align-items-center">
                    <a class="nav-link" href="#">{{ m.group_product }}</a>
                    <span class="chevron"><i class="bi bi-chevron-down" style="color: #4B944D;"></i></span>
                  </div>
                  <ul class="hs-sub-menu_2 pl-4">
                    {% for sm in submenu %}
                      {% if sm.group_product_parent == m.id %}
                        <li><a class="nav-link" href="{{ url() }}category/{{ sm.group_product_url }}/">{{ sm.group_product }}</a></li>
                      {% endif %}
                    {% endfor %}
                  </ul>
                </li>
              {% else %}
                <li>
                  <a class="nav-link" href="{{ url() }}category/{{ m.group_product_url }}/">{{ m.group_product }}</a>
                </li>
              {% endif %}
            {% endif %}
            {% set count = count + 1 %}
          {% endif %}
        {% endfor %}
      </ul>
    </li>
  {% endif %}

  <?php /*hide temporary?><li class="nav-item">
    <a class="nav-link text-center" href="#"><i class="bi bi-gift mr-2" style="color: #fff; font-size: 16px;"></i>Shopping</a>
  </li><?php */?>
</ul>

      </div>

    </nav>


  <!-- Offcanvas Menu -->
  <div class="offcanvas" id="offcanvas">
     <button id="closeOffcanvas" class="offcanvas-close" aria-label="Close">&times;</button>
    <ul>
      {% for m in menu %}
        {% if m.group_product_parent == 0 %}
          {% if m.is_child == 1 %}
            <li class="nav-item hs-has-sub-menu_2">
              <div class="d-flex align-items-center" style="gap: 5px;">
                <a class="nav-link" href="#" onclick="toggleSubMenu(event)">{{ m.group_product }}</a>
              <span class="chevron"><i class="bi bi-chevron-down"></i></span> 
              </div>
              <ul class="hs-sub-menu_2">
                {% for sm in submenu %}
                  {% if sm.group_product_parent == m.id %}
                    <li><a class="nav-link" href="{{ url() }}category/{{ sm.group_product_url }}/">{{ sm.group_product }}</a></li>
                  {% endif %}
                {% endfor %}
              </ul>
            </li>
          {% else %}
            <li class="nav-item">
              <a class="nav-link" href="{{ url() }}category/{{ m.group_product_url }}/">{{ m.group_product }}</a>
            </li>
          {% endif %}
        {% endif %}
      {% endfor %}
      {% if total_main_menu > 5 %}
    <li class="nav-item hs-has-sub-menu_2">
      <div class="d-flex align-items-center">
        <a class="nav-link" href="#">More Categories</a>
        <span class="chevron"><i class="bi bi-chevron-down"></i></span>
      </div>
      <ul class="hs-sub-menu_2">
        {% set count = 0 %}
        {% for m in menu %}
          {% if m.group_product_parent == 0 %}
            {% if count >= 5 %}
              {% if m.is_child == 1 %}
                <li class="hs-has-sub-menu_2">
                  <div class="d-flex align-items-center">
                    <a class="nav-link" href="#">{{ m.group_product }}</a>
                    <span class="chevron"><i class="bi bi-chevron-down"></i></span>
                  </div>
                  <ul class="hs-sub-menu_2">
                    {% for sm in submenu %}
                      {% if sm.group_product_parent == m.id %}
                        <li><a class="nav-link" href="{{ url() }}category/{{ sm.group_product_url }}/">{{ sm.group_product }}</a></li>
                      {% endif %}
                    {% endfor %}
                  </ul>
                </li>
              {% else %}
                <li>
                  <a class="nav-link" href="{{ url() }}category/{{ m.group_product_url }}/">{{ m.group_product }}</a>
                </li>
              {% endif %}
            {% endif %}
            {% set count = count + 1 %}
          {% endif %}
        {% endfor %}
      </ul>
    </li>
  {% endif %}
      <li class="nav-item">
        <a class="nav-link" href="#"><i class="bi bi-gift mr-2" style="color: #4B944D; font-size: 16px;"></i>Shopping</a>
      </li>
    </ul>
  </div>

<script>
  const hamburger = document.getElementById('hamburger');
  const offcanvas = document.getElementById('offcanvas');

  hamburger.addEventListener('click', () => {
    offcanvas.classList.toggle('open');
  });

  function toggleSubMenu(event) {
    event.preventDefault();

    const parent = event.target.closest('.hs-has-sub-menu_2');
    const allSubMenus = document.querySelectorAll('#offcanvas .hs-has-sub-menu_2');

    allSubMenus.forEach(menu => {
      if (menu !== parent) {
        menu.classList.remove('open');
      }
    });

    parent.classList.toggle('open');
  }

  // Optional: Close menu on outside click
  window.addEventListener('click', (e) => {
    if (!offcanvas.contains(e.target) && !hamburger.contains(e.target)) {
      offcanvas.classList.remove('open');
    }
  });

  // ✅ Tambahkan ini untuk tombol close (X)
  const closeBtn = document.getElementById('closeOffcanvas');
  closeBtn.addEventListener('click', () => {
    offcanvas.classList.remove('open');
  });
</script>

</header>