// Configure the Apollo VSCode plugin.
// https://v4.apollo.vuejs.org/guide/installation.html#visual-studio-code
module.exports = {
    client: {
      service: {
        name: 'cidb',
        url: 'http://localhost:8080/v1/graphql',
      },
      // Files processed by the extension
      includes: [
        'src/**/*.vue',
        'src/**/*.js',
      ],
    },
  }
  