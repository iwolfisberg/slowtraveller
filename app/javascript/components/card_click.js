export const initCardDetailsOnClick = () => {
  const cards = document.querySelectorAll('.fa-arrow-circle-down')
  // const x = document.querySelector(".destination-journeys");
  cards.forEach((card) => {
    const x = card.nextElementSibling;
    card.addEventListener('click', (event) => {
      if (x.style.display === "none") {
        x.style.display = "grid";
      } else {
        x.style.display = "none";
      }
    });
  });
};
