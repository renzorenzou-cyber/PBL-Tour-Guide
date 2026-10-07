$(document).ready(function() {
const searchInput = document.getElementById("search");
if (searchInput) {
  const phrases = [
    "Find Hotels or Villas..",
    "Find spa & wellness in Ubud",
    "Explore things to do in Lombok",
    "Try activities in East Java",
    "Where do you want to go?"
  ];

  let currentPhrase = 0;
  let currentChar = 0;
  let isDeleting = false;
  const typingOverlay = document.getElementById("typingOverlay");

  let typingTimer = null;
  let typingStopped = false;
  let userInteracted = false;

  function typeEffect() {
    if (typingStopped) return;

    const phrase = phrases[currentPhrase];

    if (!isDeleting) {
      typingOverlay.textContent = phrase.substring(0, currentChar++);
      if (currentChar > phrase.length) {
        isDeleting = true;
        typingTimer = setTimeout(typeEffect, 1500);
        return;
      }
    } else {
      typingOverlay.textContent = phrase.substring(0, currentChar--);
      if (currentChar === 0) {
        isDeleting = false;
        currentPhrase = (currentPhrase + 1) % phrases.length;
        typingTimer = setTimeout(typeEffect, 500);
        return;
      }
    }

    typingTimer = setTimeout(typeEffect, isDeleting ? 40 : 80);
  }

  // Sembunyikan animasi saat user mengetik
  searchInput.addEventListener("input", () => {
    if (searchInput.value.trim() !== "") {
      typingOverlay.style.display = "none";
    } else {
      if (!userInteracted) {
        typingOverlay.style.display = "block";
      } else {
        typingOverlay.style.display = "none";
      }
    }
  });

  // Hentikan typing effect saat input di klik
  searchInput.addEventListener("focus", () => {
    typingStopped = true;
    userInteracted = true;
    clearTimeout(typingTimer);
    typingOverlay.style.display = "none";
  });

  // Jangan aktifkan ulang saat blur
  searchInput.addEventListener("blur", () => {
    if (searchInput.value.trim() === "") {
      typingStopped = false;
      typingOverlay.style.display = "block";
      typeEffect();
    }
  });

  typeEffect();
}

    
    // Event listener untuk 'keypress' pada elemen dengan id 'search'
}).on('click', '#btn-search', function(e) {
    e.preventDefault();
  
    let frm = $('#search_form');
    let data = serializeFormJSON(frm);
    console.log(data)
    if(data.areas == '' && data.search == ''){ 
            Swal.fire({
            title: "Oops!",
            text: "Please fill place & activities or select Areas!",
            icon: "warning"
            }); return false;
        }
    let originalValue = $('input[type="text"]#search').val();
    const sluggedUrl = slug(originalValue);
    const encodedUrl = encodeURI(sluggedUrl);  
    location.href = BASEURL + '/search/' + encodedUrl + '/';

        
    // if(data.search && data.areas == ''){  
    //     let originalValue = $('input[type="text"]#search').val();
    //     const sluggedUrl = slug(originalValue);
    //     const encodedUrl = encodeURI(sluggedUrl);  
    //     location.href = BASEURL + '/search/' + encodedUrl + '/';
    // }

    // if(data.search == '' && data.areas){
    //     let areaVal = document.getElementById('areas').value;
    //     location.href = BASEURL + '/area/'+ areaVal +'/';
    // }

    // if(data.search && data.areas){
    //     let originalValue = $('input[type="text"]#search').val();
    //     const sluggedUrl = slug(originalValue);
    //     const encodedUrl = encodeURI(sluggedUrl);
    //     let areaVal = document.getElementById('areas').value;
    //     const sluggedAreas = slug(areaVal);
    //     const encodedAreas = encodeURI(sluggedAreas);
    //     $.ajax({
    //     url: BASEURL+"/search/"+encodedUrl+"/area/"+encodedAreas+"/",
    //     type:'POST',
    //     data: {'data':data},
    //     success : function(r){
        
    //     location.href = BASEURL+"/search/"+encodedUrl+"/area/"+encodedAreas+"/";
    //     }
    // })

    // }
}).on('click', '#search_button', function(e){
    e.preventDefault();
  
    let frm = $('#search_form');
    let data = serializeFormJSON(frm);
    console.log(data)

    if(data.search){  
        let originalValue = $('input[type="text"]#search_input').val();
        const sluggedUrl = slug(originalValue);
        const encodedUrl = encodeURI(sluggedUrl);  
        location.href = BASEURL + '/search/' + encodedUrl + '/';
    } else {
        Swal.fire({
        title: "Oops!",
        text: "Please fill your activities !",
        icon: "warning"
        }); return false;
    }

    
})