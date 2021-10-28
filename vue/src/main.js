import { createApp, h } from 'vue'
import App from './App.vue'

import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client/core'
import { createApolloProvider } from '@vue/apollo-option'

// Makes apollo available in all components
const apolloProvider = createApolloProvider({
  defaultClient: new ApolloClient({
    link: createHttpLink({
      uri: 'http://localhost:8080/v1/graphql',
    }),
    cache: new InMemoryCache(),
  })
})

const app = createApp(App)
app.use(apolloProvider)
app.mount('#app')
