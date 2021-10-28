<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    builds: gql`query {
        builds {
          build_id
        }
    }`
  },
  // data() {
  //   return {
  //     builds: {}
  //   }
  // }
}
</script>

<template>
  <div>Builds</div>
  <!-- <div>{{ builds }}</div> -->
  <ol>
      <li v-for="build in builds">{{ build.build_id }}</li>
  </ol>
</template>
