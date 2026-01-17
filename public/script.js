// js para animar o h1
const texts = ["Contratar com excelência muda o jogo.", "Não deixe os melhores talentos para seus concorrentes."];
let i = 0;
const animatedTitleElement = document.getElementById("rotating-title-h1");

// Definir o primeiro texto quando a pagina carrega
animatedTitleElement.textContent = texts[0];

function rotateText() {
  animatedTitleElement.classList.add("roll-out");
  
  setTimeout(() => {
    i = (i + 1) % texts.length;
    animatedTitleElement.textContent = texts[i];
    
    animatedTitleElement.classList.remove("roll-out");
    animatedTitleElement.classList.add("roll-in");
    
    setTimeout(() => {
      animatedTitleElement.classList.remove("roll-in");
    }, 600);
  }, 500);
}

// Iniciar a rotação após 5 segundos e repetir a cada 5 segundos
setTimeout(() => {
  rotateText(); // Primeira troca
  setInterval(rotateText, 5000); // Trocas subsequentes
}, 5000);

//js para abrir e fechar o menu 
const openMenuButton = document.getElementById("open-menu-button");
const closeMenuButton = document.getElementById("close-menu-button");
const openedMenu = document.getElementById("opened-menu");

openMenuButton.addEventListener("click", () => {
  openedMenu.classList.remove("hidden");
  // delay para dar tempo da animacao acontecer
  setTimeout(() => {
    openedMenu.classList.remove("translate-x-full");
  }, 10);
  document.body.style.overflow = 'hidden';
});

closeMenuButton.addEventListener("click", () => {
  openedMenu.classList.add("translate-x-full");
  // espera a animação terminar antes de esconder
  setTimeout(() => {
    openedMenu.classList.add("hidden");
  }, 300); // mesmo tempo da transição do CSS
  document.body.style.overflow = '';
});
