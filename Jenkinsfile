pipeline {
  agent none
  
  environment {
    HOME = '/tmp/home'
    FRONTEND_URL = credentials('skuldaring_frontend_url')
    DATABASE_URL = credentials('skuldaring_database_url')
    TEST_DATABASE_URL = credentials('skuldaring_test_database_url')
    KEYCLOAK_URL = credentials('skuldaring_keycloak_url')
    KEYCLOAK_CLIENT_ID = credentials('skuldaring_keycloak_client_id')
    KEYCLOAK_CLIENT_SECRET = credentials('skuldaring_keycloak_client_secret')
  }

  stages {
    stage('install dependencies') {
      agent { 
        docker {
          image 'elixir:1.10'
          args '-v /tmp/home:/tmp/home'
        }
      }
      steps {
        sh 'mix local.hex --force'
        sh 'mix local.rebar'
        sh 'mix deps.get'
      }
    }
    stage('build assets') {
      agent { 
        docker {
          image 'node:10'
          args '-v /tmp/home:/tmp/home'
        }
      }
      steps {
        sh 'cd assets && npm ci && npm run deploy'
      }
    }
    stage('test') {
      agent { 
        docker {
          image 'elixir:1.10'
          args '-v /tmp/home:/tmp/home'
        }
      }
      steps {
        sh 'mix ecto.migrate'
        sh 'mix test'
      }
    }
 }
}