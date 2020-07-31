pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'mix deps.get'
        sh 'cd assets && npm i && npm run deploy'
      }
    }
    stage('test') {
      steps {
        sh 'mix test'
      }
    }
  }
}