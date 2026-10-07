<!-- Login -->
  <section class="container g-py-100">
    <div class="row justify-content-center">
      <div class="col-sm-9 col-md-7 col-lg-5">
        <div class="section-forgot g-px-30 g-py-35">
          <header class="text-center">
            <h3 class="title poppins-bold">Forgot Password?</h3>
            <p style="color: rgba(0,0,0,.5);">Enter your e-mail address to reset your password.</p>
          </header>

          <!-- Form -->
          <form class="g-py-15" id="form_forget">
            <div class="mb-4">
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
              </svg>
                  <input type="text" name="email" placeholder="Email">
              </div>
            
            </div>

            <button class="btn btn-custom mt-2 py-2 w-100 poppins-medium" id="forget" type="button">Get New Password</button>

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
            </style>
          </form>
          <!-- End Form -->
        </div>
      </div>
    </div>
  </section>
<!-- End Login -->