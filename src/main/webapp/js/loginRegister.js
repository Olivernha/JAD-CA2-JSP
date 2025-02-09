const inputs = document.querySelectorAll(".input-field");
const toggle_btn = document.querySelectorAll(".toggle");
const main = document.querySelector("main");
const bullets = document.querySelectorAll(".bullets span");
const images = document.querySelectorAll(".image");

inputs.forEach((inp) => {
  inp.addEventListener("focus", () => {
    inp.classList.add("active");
  });
  inp.addEventListener("blur", () => {
    if (inp.value != "") return;
    inp.classList.remove("active");
  });
});

toggle_btn.forEach((btn) => {
  btn.addEventListener("click", () => {
    main.classList.toggle("sign-up-mode");
  });
});

function moveSlider() {
  let index = this.dataset.value;

  let currentImage = document.querySelector(`.img-${index}`);
  images.forEach((img) => img.classList.remove("show"));
  currentImage.classList.add("show");

  const textSlider = document.querySelector(".text-group");
  textSlider.style.transform = `translateY(${-(index - 1) * 2.2}rem)`;

  bullets.forEach((bull) => bull.classList.remove("active"));
  this.classList.add("active");
}

bullets.forEach((bullet) => {
  bullet.addEventListener("click", moveSlider);
});

document.addEventListener('DOMContentLoaded', function() {
    const images = document.querySelectorAll('.images-wrapper .image');
    const bullets = document.querySelectorAll('.bullets span');
    const texts = document.querySelectorAll('.text-group h2');
    let currentIndex = 0;
    let interval = 3000; 

    function updateCarousel(index) {
        if (index >= images.length) {
            index = 0;
        } else if (index < 0) {
            index = images.length - 1;
        }

        images.forEach((img, i) => {
            img.classList.remove('show');
            if (i === index) {
                img.classList.add('show');
            }
        });

        bullets.forEach((bullet, i) => {
            bullet.classList.remove('active');
            if (i === index) {
                bullet.classList.add('active');
            }
        });

        const textSlider = document.querySelector('.text-group');
        textSlider.style.transform = `translateY(${-(index) * 2.2}rem)`;

        currentIndex = index;
    }

    function autoCycle() {
        currentIndex++;
        updateCarousel(currentIndex);
    }

    let autoCycleInterval = setInterval(autoCycle, interval);

    bullets.forEach((bullet, index) => {
        bullet.addEventListener('click', () => {
            updateCarousel(index);

            clearInterval(autoCycleInterval);
            autoCycleInterval = setInterval(autoCycle, interval);
        });
    });

    updateCarousel(currentIndex);
});


