<script>
import gql from 'graphql-tag'

const QUERY = gql`
  query ($build_id: String = "") {
    build: builds_by_pk(build_id: $build_id) {
      build_id
      test_cases {
        classname
        failed
        name
        skipped
        suite_name
        time
      }
    }
  }
`

export default {
  apollo: {
    build: {
      query: QUERY,
      variables() {
        return {
          build_id: "jenkins:/Users/markaddison/Lab/cidb/test-data/jenkins/builds/2"
        }
      }
    }
  },
  data() {
    return {
      build: { test_cases: [] } // init, filled by apollo
    }
  }
}
</script>

<template>
  <h1>Test Cases</h1>
  <div v-if="$apollo.queries.build.loading">Loading...</div>
  <!-- <div>{{ build }}</div> -->
  <table>
      <tr v-for="(test_case, idx) in build.test_cases" :key="test_case.name">
        <td>{{ idx }}</td>
        <td>{{ test_case.build_id }}</td>
        <td>{{ test_case.classname }}</td>
        <td>{{ test_case.failed }}</td>
        <td>{{ test_case.name }}</td>
        <td>{{ test_case.skipped }}</td>
        <td>{{ test_case.suite_name }}</td>
        <td>{{ test_case.time }}</td>
      </tr>
  </table>
</template>
