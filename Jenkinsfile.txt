pipeline {
    agent any
    environment {
        FIREBASE_DEPLOY_TOKEN = credentials('firebase-token')
    }

    stages {
        stage('Building') {
            steps {
                echo 'Building...'
                // Uncomment if firebase-tools is not installed on your agent
                // sh 'npm install -g firebase-tools'
            }
        }

        stage('Testing Environment') {
            steps {
                echo 'Deploying to Testing Environment...'
                sh "firebase deploy -P devops-proj-testing --token ${FIREBASE_DEPLOY_TOKEN}"
                
                input message: 'After testing, do you want to continue with Staging Environment? (Click "Proceed" to continue)'
            }
        }

        stage('Staging Environment') {
            steps {
                echo 'Deploying to Staging Environment...'
                sh "firebase deploy -P fir-29310 --token ${FIREBASE_DEPLOY_TOKEN}"
            }
        }

        // stage('Production Environment') {
        //     steps {
        //         echo 'Deploying to Production Environment...'
        //         sh "firebase deploy -P devops-proj-production-bcfd9 --token ${FIREBASE_DEPLOY_TOKEN}"
        //     }
        // }
    }

    post {
        success {
            echo 'Deployment pipeline completed successfully!'
        }
        failure {
            echo 'Deployment pipeline failed. Please check logs.'
        }
    }
}
