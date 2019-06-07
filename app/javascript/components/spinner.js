export const initSpinner = () => {
  const submitSearch = document.querySelector(".submit-search");
  submitSearch.addEventListener("click", (event) => {
    const contentIndex = document.querySelector(".content-index");
    contentIndex.querySelector("#article_one_index").style.margin = '200px 0 0 0';
    contentIndex.insertAdjacentHTML("afterbegin", `<div class="spinner"><h3 class="text-spinner">Looking for destinations around you !</h3><img class="spinner-train mb-3" src="/assets/train.png"></div>`)
    document.querySelector(".form-banner").style.margin = "30px 0 235px 0"
  });
};
