/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./templates/**/*.html",   // templates do Gin
    "./public/**/*.js",        // JS do frontend
    "./public/**/*.html",      // se algum HTML for servido direto
    "./main.go",               // se você usar classes em strings no Go
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
