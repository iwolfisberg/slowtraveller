export const initOnClickRemoveAddFavorites = () => {
  const favorites = document.querySelectorAll(".fa-heart");
  console.log(favorites);
  favorites.forEach((favorite) => {
    favorite.addEventListener('click', (event) => {
      console.log(favorite);
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

