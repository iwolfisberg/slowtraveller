export const initOnClickRemoveAddFavorites = () => {
  const favorites = document.querySelectorAll(".fa-heart");
  favorites.forEach((favorite) => {
    favorite.addEventListener('click', (event) => {
      if (favorite.classList.contains("fas")) {
        favorite.classList.remove("fas");
        favorite.classList.add("far");
      }
      else {
        favorite.classList.remove("far");
        favorite.classList.add("fas");
      }
    });
  });
};

