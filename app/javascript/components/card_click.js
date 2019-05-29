export const initCardDetailsOnClick = () => {
  const card = document.querySelector('.destination-infos')
  const x = document.querySelector(".destination-infos-details");
  card.addEventListener('click', (event) => {
    if (x.style.display === "none") {
      x.style.display = "grid";
    } else {
      x.style.display = "none";
    }
  });
};
