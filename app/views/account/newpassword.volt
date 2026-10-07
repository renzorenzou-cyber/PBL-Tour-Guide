<!-- New password -->
<section class="container g-py-100">
    <div class="row justify-content-center">
      <div class="col-sm-9 col-md-7 col-lg-5">
        <div class="section-forgot g-px-30 g-py-35">
          <header class="text-center">
            <h3 class="title poppins-bold">Reset Password</h3>
            <p style="color: rgba(0,0,0,.5);">Enter your new password.</p>
          </header>

          <!-- Form -->
          <form class="g-py-15" id="form_newpassword">
            <div class="mb-4">
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock" viewBox="0 0 16 16">
                  <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2M5 8h6a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1"/>
                </svg>
                <input type="password" name="password" placeholder="Your New Password">
              </div>
              <div class="input-field">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock" viewBox="0 0 16 16">
                  <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2M5 8h6a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1"/>
                </svg>
                <input type="password" name="password" placeholder="Confrim Your Password">
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
  <!-- End New password -->