<style>
:root { 
  --bg:#0f172a; 
  --card:#ffffff; 
  --text:#1f2937; 
  --muted:#6b7280; 
  --accent:#87ceeb; 
  --accent-hover:#5ab3d9;
}

/* Card Container */
.card {
  width:100%;
  max-width:640px;
  background:rgba(255, 255, 255, 0.92);
  backdrop-filter:saturate(120%) blur(6px);
  border:1px solid var(--accent);
  border-radius:18px;
  box-shadow:0 8px 24px rgba(0,0,0,.25);
  margin:100px auto;
  overflow:hidden;
}

/* Header */
.head {
  padding:24px;
  border-bottom:1px solid var(--accent);
  background:var(--accent);
  color:white;
  text-align:center;
}

.head h1 {
  margin:0;
  font-size:1.4rem;
  font-weight:600;
}

.head p {
  margin:.4rem 0 0;
  color:rgba(255,255,255,.9);
  font-size:.95rem;
}

/* Form */
form {
  padding:24px;
  display:grid;
  gap:16px;
}

@media(min-width:640px){ 
  .row.two {
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
  }
}

label {
  font-size:.9rem;
  font-weight:500;
  color:var(--muted);
  margin-bottom:6px;
  display:block;
}

input, select, textarea {
  width:100%;
  padding:12px 14px;
  border:1px solid var(--accent);
  border-radius:12px;
  background:#f9fafb;
  color:var(--text);
  font-size:.95rem;
  outline:none;
  transition:border .2s, box-shadow .2s;
}

input::placeholder, textarea::placeholder {
  color:#9ca3af;
}

input:focus, select:focus, textarea:focus {
  border-color:var(--accent-hover);
  box-shadow:0 0 0 3px rgba(135,206,235,.25);
}

textarea {
  min-height:120px;
  resize:vertical;
}

/* Button */
.actions {
  display:flex;
  justify-content:flex-end;
  margin-top:12px;
}

.btn {
  appearance:none;
  border:0;
  border-radius:12px;
  padding:12px 20px;
  font-weight:600;
  cursor:pointer;
  font-size:.95rem;
  transition:all .25s ease;
}

.btn.trop {
  background:var(--accent);
  color:white;
}

.btn.trop:hover {
  background:var(--accent-hover);
  transform:translateY(-1px);
  box-shadow:0 4px 12px rgba(0,0,0,.15);
}

.btn.trop:disabled {
  opacity:.6;
  cursor:not-allowed;
}

.error {
  color:#f87171;
  font-size:.85rem;
  display:none;
}
</style>

<section>
    <div class="card">
    <div class="head">
      <h1 style="color: white;">Enquiry Form</h1>
      <p style="color: white;">Please fill in the form below and we will get back to you shortly</p>
    </div>

    <form id="enquiryForm">

      <div class="row two">
        <div>
          <label>Name<span class="text-danger">*</span></label>
          <input name="name" type="text" placeholder="Your Name" required />
        </div>

        <div>
          <label>Email<span class="text-danger">*</span></label>
          <input name="email" type="email" placeholder="Example@gmail.com" required />
        </div>
      </div>

      <div class="row two">
        <div>
          <label>WhatsApp<span class="text-danger">*</span></label>
          <input name="whatsapp" type="text" placeholder="+62xxxxxxxxxxx">
        </div>

        <div>
          <label class="form-label" style="color: rgba(0, 0, 0, .5)">Country <span class="text-danger">*</span></label>
            <select class="form-control border-5" name="country" id="country" style="width:100%;
                padding:12px 14px;
                border:1px solid #87ceeb;
                border-radius:12px;
                background:#f1f0f0;
                color:#272727;
                outline:none;
                height: 48px;
                transition:border .15s, box-shadow .15s">
                <option value="">Select Country</option>
                {% for c in countries %}
                    <option value="{{ c.iso2 }}">{{ c.short_name }}</option>
                {% endfor %}
            </select>
        </div>
      </div>

      <div class="row">
          <label>Enquiry<span class="text-danger">*</span></label>
          <textarea name="enquiry" placeholder="Write your question or request details here…" required></textarea>
      </div>

      <div class="actions">
        <div class="g-recaptcha" data-sitekey="{{config.captcha.siteKey}}"></div>
      </div>
      <div class="actions">
        <a class="btn trop text-light" id="submit_enquiry">Send Enquiry</a>
      </div>
    </form>
  </div>
</section>