export const initCardDetailsOnClick = () => {
  const card = document.querySelector('.card-destination-show-general')
  const x = document.querySelector(".card-destination-show-details");
  card.addEventListener('click', (event) => {
    if (x.style.display === "none") {
      x.style.display = "grid";
    } else {
      x.style.display = "none";
    }
  });
};
