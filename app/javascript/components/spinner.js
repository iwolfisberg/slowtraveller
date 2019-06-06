export const initSpinner = () => {
  const submitSearch = document.querySelector(".submit-search");
  submitSearch.addEventListener("click", (event) => {
    const contentIndex = document.querySelector(".content-index");
    contentIndex.insertAdjacentHTML("afterbegin", `<h3 class="text-spinner">Looking for destinations around you !</h3><img src="/assets/train.png">`)
  });
};
