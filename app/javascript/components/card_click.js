export const initCardDetailsOnClick = () => {
  const arrows = document.querySelectorAll('.fa-arrow-circle-down')
  arrows.forEach((arrow) => {
    arrow.addEventListener('click', (event) => {
      const e = arrow.parentNode.parentNode.parentNode.nextElementSibling;
      if (e.style.display) {
        e.style.display = ((e.style.display != 'none') ? 'none' : 'grid');
      }
        else {
          e.style.display = 'grid'
      }
    });
  });
};

