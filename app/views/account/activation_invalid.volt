<style>
.invalid-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 30px;
}
.invalid-box {
  text-align: center;
  padding: 30px;
  max-width: 480px;
  width: 100%;
  border: 1px solid #ddd;
  border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.08);
}
.cable-icon {
  width: 260px;
  margin-bottom: 20px;
}
.copper {
  stroke: #DAA520;
  stroke-width: 2;
}
.spark {
  stroke: #FFD700;
  stroke-width: 2;
  filter: drop-shadow(0 0 4px #FFD700);
  opacity: 0;
}
.btn {
  display: block;
  padding: 12px;
  border-radius: 10px;
  text-decoration: none;
  font-weight: bold;
  margin-bottom: 12px;
}
.btn-primary {
  background-color: #87CEEB;
  color: white;
}
.btn-primary:hover {
  background-color: #6bbcd6;
}
.btn-trop {
  background-color: #f1f1f1;
  color: #87CEEB;
  border-color: #87CEEB;
}
.btn-trop:hover {
  background-color: #e1e1e1;
}
</style>
<div class="invalid-container">
  <div class="invalid-box">
    <svg class="cable-icon" id="cableSVG" viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg">
      <g id="cableLeft">
        <path d="M0 60 Q50 40, 120 60" stroke="#87CEEB" stroke-width="18" fill="none" stroke-linecap="round"/>
        <path d="M0 60 Q50 40, 120 60" stroke="#111" stroke-width="10" fill="none" stroke-linecap="round"/>
        <line x1="120" y1="60" x2="110" y2="38" class="copper"/>
        <line x1="120" y1="60" x2="115" y2="70" class="copper"/>
        <line x1="120" y1="60" x2="105" y2="65" class="copper"/>
      </g>
      <g id="cableRight">
        <path d="M180 60 Q250 80, 300 60" stroke="#87CEEB" stroke-width="18" fill="none" stroke-linecap="round"/>
        <path d="M180 60 Q250 80, 300 60" stroke="#111" stroke-width="10" fill="none" stroke-linecap="round"/>
        <line x1="180" y1="60" x2="190" y2="38" class="copper"/>
        <line x1="180" y1="60" x2="185" y2="70" class="copper"/>
        <line x1="180" y1="60" x2="195" y2="65" class="copper"/>
      </g>

      <polyline id="spark1" points="125,55 140,40 150,65 160,45 175,60" fill="none" class="spark"/>
      <polyline id="spark2" points="128,65 142,50 155,75 165,55 172,65" fill="none" class="spark"/>
    </svg>

    <h2>Invalid Activation Link</h2>
    <p>Oops! The activation link you used is invalid or has already been used.</p>
    <a href="{{ url('account/login') }}" class="btn btn-primary">Go to Login</a>
    <a href="{{ url('account/signup') }}" class="btn btn-trop">Sign Up Again</a>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  gsap.to("#cableLeft", {
    rotation: 5,
    y: -3,
    transformOrigin: "right center",
    yoyo: true,
    repeat: -1,
    duration: 1,
    ease: "sine.inOut"
  });

  gsap.to("#cableRight", {
    rotation: -5,
    y: 3,
    transformOrigin: "left center",
    yoyo: true,
    repeat: -1,
    duration: 1,
    ease: "sine.inOut"
  });

  const sparks = ["#spark1", "#spark2"];
  function randomSpark() {
    const spark = gsap.utils.random(sparks);
    gsap.fromTo(spark, {opacity: 0}, {
      opacity: 1,
      duration: 0.1,
      yoyo: true,
      repeat: 3,
      onComplete: () => gsap.to(spark, {opacity: 0, duration: 0.1})
    });
  }
  setInterval(randomSpark, 300);
});
</script>
