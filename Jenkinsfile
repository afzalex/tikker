#!/usr/bin/env groovy
pipeline {
    agent any
    // parameters {
    //     string(name: 'REGISTRY_URL', defaultValue: '', description: '')
    //     string(name: 'BUILDID', defaultValue: 'starwar-app-1', description: '')
    // }
    // environment {
    //     REGISTRY_URL: "${env.REGISTRY_URL}"
    //     BUILDID: "${env.BUILDID}"
    // }
    stages {
        stage('build_jar') {
            agent {
                docker {
                    image 'node:17-alpine3.12'
                    // args '-v jenkins_agent_gradle_cache:/home/gradle/.gradle'
                }
            }
            steps {
                sh '''
                    while [ ! -f flag.continue1 ]; do echo $(date); sleep 5; done; 
                '''
            }
        }
    }
}
