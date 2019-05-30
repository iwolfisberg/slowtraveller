export const initCardDetailsOnClick = () => {
  const cards = document.querySelectorAll('.destination-card')
  const x = document.querySelector(".destination-journeys");
  cards.forEach((card) => {
    card.addEventListener('click', (event) => {
      console.log(event);
      if (x.style.display === "none") {
        x.style.display = "grid";
      } else {
        x.style.display = "none";
      }
    });
  });
};
