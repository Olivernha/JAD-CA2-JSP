document.addEventListener("DOMContentLoaded", function () {
    const filterButtons = document.getElementById("filter-btns").children;
    const items = document.querySelectorAll(".categories .scrollbar-item");

    for (let i = 0; i < filterButtons.length; i++) {
        filterButtons[i].addEventListener("click", function() {
            for (let j = 0; j < filterButtons.length; j++) {
                filterButtons[j].classList.remove("active");
            }
            this.classList.add("active");

            const target = this.getAttribute("data-target").replaceAll(" ", "");

            for (let k = 0; k < items.length; k++) {
                items[k].style.display = "none";
                if (items[k].getAttribute("data-id") === target || target === "all") {
                    items[k].style.display = "block"; 
                }
            }
        });
    }
});
