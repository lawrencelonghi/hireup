const texts = ["Contratar com excelência muda o jogo.", "Não deixe os melhores talentos para seus concorrentes."];
let i = 0;
const animatedTitleElement = document.getElementById("rotating-title-h1");

// Definir o primeiro texto imediatamente
animatedTitleElement.textContent = texts[0];

// Função de rotação
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