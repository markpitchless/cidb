<script>
import gql from 'graphql-tag'

const BUILDS_QUERY = gql`
  query {
    builds {
      repository
      build_id
      branch
      revision
    }
 }
`

export default {
  apollo: {
    builds: {
      query: BUILDS_QUERY,
    }
  },
  data() {
    return {
      builds: [] // init, filled by apollo
    }
  }
}
</script>

<template>
  <h1>Builds</h1>
  <div v-if="$apollo.queries.builds.loading">Loading...</div>
  <!-- <div>{{ builds }}</div> -->
  <table>
      <tr v-for="(build, idx) in builds" :key="build.build_id">
        <td>{{ idx }}</td>
        <td>{{ build.repository }}</td>
        <td>{{ build.build_id }}</td>
        <td>{{ build.branch }}</td>
        <td>{{ build.revision }}</td>
      </tr>
  </table>
</template>
