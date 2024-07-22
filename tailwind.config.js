module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        seenceofplace: {
          "primary": "#BFE0CD",
          "secondary": "#7E615B",
          "accent": "#37cdbe",
          "neutral": "#3d4451",
          "base-100": "#F6F0D0",
          "info": "#C6E4EC",
          "success": "#62CB93",
          "warning": "#CBB162",
          "error": "#B03B3B",
          "text-color": "#7E615B"
        },
      },
    ],
  }
}
